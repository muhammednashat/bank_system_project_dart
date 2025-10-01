import 'package:bank_system/model/banks/alex/alex_isolate.dart';
import 'package:bank_system/model/banks/cairo/cairo_isolate.dart';
import 'package:bank_system/model/accounts/account.dart';
import 'package:bank_system/model/accounts/saving_accout.dart';
import 'package:uuid/uuid.dart';
import 'dart:isolate';

import 'protocol.dart';

final _currentBranch = Branches.main.name;
final mainReceivePort = ReceivePort();

final newAccounts = [
  SavingAccout(
    name: "mohammed",
    id: Uuid().v4(),
    dateOpened: DateTime.now(),
    balance: 5000.0,
    nameBranch: "Alex Bank",
  ).toJson(),
  SavingAccout(
    name: "mohammed",
    id: Uuid().v4(),
    dateOpened: DateTime.now(),
    balance: 4000.0,
    nameBranch: "Alex Bank",
  ).toJson(),
  SavingAccout(
    name: "mohammed",
    id: Uuid().v4(),
    dateOpened: DateTime.now(),
    balance: 6000.0,
    nameBranch: "Alex Bank",
  ).toJson(),
  SavingAccout(
    name: "mohammed",
    id: Uuid().v4(),
    dateOpened: DateTime.now(),
    balance: 1000.0,
    nameBranch: "Alex Bank",
  ).toJson(),
];

void main(List<String> args) async {
  SendPort? alexSendPort;
  await Isolate.spawn(alexBranch, mainReceivePort.sendPort);
  await Isolate.spawn(cairoBranch, mainReceivePort.sendPort);

  mainReceivePort.listen((message) {
    final senderBranch = message["branch"];
    final cmd = message["command"];
    final data = message["data"];

    if (senderBranch == Branches.alex.name &&
        cmd == Commands.initialSetup.name) {
      alexSendPort = data as SendPort;
      for (var account in newAccounts) {
        alexSendPort?.send(map(_currentBranch, Commands.create.name, account));
      }
      alexSendPort?.send(map(_currentBranch, Commands.accounts.name, null));
    } else if (senderBranch == Branches.alex.name &&
        cmd == Commands.accounts.name) {
        final accounts = data as List<Map<String, dynamic>>; 
        alexSendPort?.send(map(_currentBranch, Commands.transfer.name, {
          "from":accounts[0]["id"],
          "to":accounts[1]["id"],
          "amount":150.0 
        })); 
       


    } else {
      print(message);
      print("$_currentBranch unkown command:$cmd");
    }
  });
}
