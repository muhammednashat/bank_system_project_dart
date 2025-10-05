import 'package:bank_system/data/alex_accounts.dart';
import 'package:bank_system/data/cairo.accounts.dart';
import 'package:bank_system/model/accounts/account.dart';
import 'package:bank_system/model/banks/alex/alex_isolate.dart';
import 'package:bank_system/model/banks/cairo/cairo_isolate.dart';
import 'dart:isolate';
import 'protocol.dart';

final _currentBranch = Branches.main.name;
final mainReceivePort = ReceivePort();

void main(List<String> args) async {
  await Isolate.spawn(alexBranch, mainReceivePort.sendPort);
  await Isolate.spawn(cairoBranch, mainReceivePort.sendPort);

  mainReceivePort.listen((message) {
    final senderBranch = message["branch"];
    final cmd = message["command"];
    final data = message["data"];
    if (senderBranch == Branches.alex.name) {
      despatchAlexCommands(cmd, data);
    } else if (senderBranch == Branches.cairo.name) {
      print("ca");
      despatchCairoCommands(cmd, data);
    } else {
      print(message);
      print("$_currentBranch unkown command:$cmd");
    }
  });
}

SendPort? alexSendPort;

despatchAlexCommands(cmd, data) {
  if (cmd == Commands.initialSetup.name) {
    print("1");

    alexSendPort = data as SendPort;
    alexSendPort?.send(
      map(_currentBranch, Commands.create.name, newAlexAccounts),
    );
  } else if (cmd == Commands.accounts.name) {
    print("3");
    final accounts =
        (data as List<Map<String, dynamic>>)
            .map((account) => Account.formJson(account))
            .toList();
    final fromId = accounts[0].id;
    alexSendPort?.send(
      map(_currentBranch, Commands.withdraw.name, {
        "fromId": fromId,
        "amount": 150.0,
      }),
    );

    // print(accounts);
  } else {
    print("alex------------------------------alex");
    print(data);
  }
}

SendPort? cairoSendPort;

despatchCairoCommands(cmd, data) {
  if (cmd == Commands.initialSetup.name) {
    print("2");
    cairoSendPort = data as SendPort;
    cairoSendPort?.send(
      map(_currentBranch, Commands.create.name, newCairoAccounts),
    );
  } else if (cmd == Commands.accounts.name) {
    print("4");
    print(data);
  } else {
    print("Cairo------------------------------Cairo");
    print(data);
  }
}
