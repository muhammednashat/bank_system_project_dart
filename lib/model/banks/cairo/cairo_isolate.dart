import 'dart:isolate' show ReceivePort, SendPort;
import 'package:bank_system/main.dart';
import 'package:bank_system/model/accounts/account.dart';

import '../../../protocol.dart';

import 'package:bank_system/model/banks/cairo/cairo_bank.dart';

final _cairoBank = CairoBank();
final _currentBranch = Branches.cairo.name;
final _cairoReceivePort = ReceivePort();
final _cairoAccounts = _cairoBank.accounts;

void cairoBranch(SendPort mainSendPort) {
  mainSendPort.send(
    map(_currentBranch, Commands.initialSetup.name, _cairoReceivePort.sendPort),
  );

  _cairoReceivePort.listen((message) {
    final senderBranch = message["branch"];
    final cmd = message["command"];
    final data = message["data"];

    if (senderBranch == Branches.main.name) {
      dispatchMainCommands(cmd, data, mainSendPort);
    } else if (senderBranch == Branches.alex) {
      dispatchAlexMessages(cmd, data);
    }
  });
}

dispatchMainCommands(cmd, data, SendPort mainSendPort)async {
  if (cmd == Commands.create.name) {
    final accounts = data as List<Map<String, dynamic>>;
    for (var account in accounts) {
      _cairoBank.createNewAccount(Account.formJson(account));
    }

    mainSendPort.send(
      map(_currentBranch, Commands.accounts.name, jsonList(_cairoAccounts)),
    );
  } else if (cmd == Commands.deposit.name) {
    final toId = data["to"];
    final amount = data["amount"];
    final to = _cairoAccounts.firstWhere((account) => account.id == toId);
    try {
    await to.deposit(amount);
    mainSendPort.send(map(_currentBranch, Commands.deposit.name, {
      "status" : true,
      "msg":"Done"
    }));
    } catch (e) {
       mainSendPort.send(map(_currentBranch, Commands.deposit.name, {
      "status" : false,
      "msg": e
    }));
    }
   
  } else {}
}

void dispatchAlexMessages(cmd, data) {}
