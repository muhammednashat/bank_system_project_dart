import 'package:bank_system/data/alex_accounts.dart';
import 'package:bank_system/model/accounts/account.dart';
import 'package:bank_system/model/banks/alex/alex_isolate.dart';
import 'package:bank_system/model/transaction.dart';
import 'dart:isolate';
import 'protocol.dart';

final _currentBranch = Branches.main.name;
final mainReceivePort = ReceivePort();
late List<Account> _alexAccounts;
late String fromId;
late String toId;
double amount = 150.0;
void main(List<String> args) async {
  await Isolate.spawn(alexBranch, mainReceivePort.sendPort);

  mainReceivePort.listen((message) {
    final senderBranch = message["branch"];
    final cmd = message["command"];
    final data = message["data"];
    if (senderBranch == Branches.alex.name) {
      despatchAlexCommands(cmd, data);
    }else {
      print("$_currentBranch unkown command:$cmd");
    }
  });
}

SendPort? alexSendPort;

despatchAlexCommands(cmd, data) {
  if (cmd == Commands.initialSetup.name) {

    alexSendPort = data as SendPort;
    alexSendPort?.send(
      map(_currentBranch, Commands.create.name, newAlexAccounts),
    );
  } else if (cmd == Commands.accounts.name) {
    _alexAccounts =
        (data as List<Map<String, dynamic>>)
            .map((account) => Account.formJson(account))
            .toList();
     fromId = _alexAccounts[0].id;
     toId = _alexAccounts[1].id;
   alexSendPort?.send(map(_currentBranch, Commands.transfer.name, {
    "from":fromId,
    "to":toId,
    "amount":amount
   }))   ;

  }else if(cmd == Commands.transfer.name){
  final Status = data["status"];
  if (Status) {
    print("Donee");
  } else {
    print(data["msg"]);
    
  }
  }
  
  
  else {
    print("alex------------------------------alex");
    print(data);
  }
}



