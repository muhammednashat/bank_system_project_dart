import 'dart:isolate';

import 'package:bank_system/model/accounts/account.dart';
import 'package:bank_system/model/banks/alex/alex_bank.dart';
import '../../../protocol.dart';

final _currentBranch = Branches.alex.name;
final _alexBank = AlexBank();
final _alexReceivePort = ReceivePort();
final _alexAccounts = _alexBank.accounts;

void alexBranch(SendPort mainSendPort) {
  mainSendPort.send(
    map(_currentBranch, Commands.initialSetup.name, _alexReceivePort.sendPort),
  );

  _alexReceivePort.listen((message) async {
    final senderBranch = message["branch"];
    final cmd = message["command"];
    final data = message["data"];

    if (senderBranch == Branches.main.name) {
      despatchMainCommands(cmd, data, mainSendPort);
    } else {
      print("$_currentBranch Unknown commond:$cmd");
    }
  });
}

void despatchMainCommands(cmd, data, SendPort mainSendPort) async {
  if (cmd == Commands.create.name) {
    final accounts = data as List<Map<String, dynamic>>;
    for (var account in accounts) {
      _alexBank.createNewAccount(Account.formJson(account));
    }
    mainSendPort.send(
      map(_currentBranch, Commands.accounts.name, jsonList(_alexAccounts)),
    );
  } else if (cmd == Commands.transfer.name) {
     data as Map<String, dynamic>;
    try {
      final status = await _alexBank.transfer(
        data["from"],
        data["to"],
        data["amount"],
      );
      mainSendPort.send(map(_currentBranch, Commands.transfer.name, {
        "status":true,
        "msg":"Done"
      }));
    } catch (e) {
       mainSendPort.send(map(_currentBranch, Commands.transfer.name, {
        "status":false,
        "msg": e
      }));
    }
  }else if(cmd == Commands.deposit.name){
    final amount = data["amount"];
    final account = _alexAccounts.firstWhere((a) => a.id == data["accountId"]);
    print(account.balance);
    try {
    await  account.deposit(amount);
    print(account.balance);

    mainSendPort.send(map(_currentBranch, Commands.deposit.name, {
      "status":true,
      "msg":"Done"
    }));
      
    } catch (e) {
         mainSendPort.send(map(_currentBranch, Commands.deposit.name, {
      "status":true,
      "msg":e
    }));
    }
  }
  
  
   else if (cmd == Commands.withdraw.name) {
    final fromId = data["fromId"];
    final amount = data["amount"];
    final from = _alexAccounts.firstWhere((a) {
      return a.id == fromId;
    });
    await from.withdraw(amount);
    mainSendPort.send(
      map(_currentBranch, Commands.withdraw.name, {"status": true}),
    );
  } else {
    print("No thing to exceute");
  }
}
