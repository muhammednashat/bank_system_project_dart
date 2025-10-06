import 'package:bank_system/data/alex_accounts.dart';
import 'package:bank_system/data/cairo.accounts.dart';
import 'package:bank_system/model/accounts/account.dart';
import 'package:bank_system/model/banks/alex/alex_isolate.dart';
import 'package:bank_system/model/banks/cairo/cairo_isolate.dart';
import 'dart:isolate';
import 'protocol.dart';

final _currentBranch = Branches.main.name;
final mainReceivePort = ReceivePort();
late List<Account> _alexAccounts;
late List<Account> _cairoAccounts;
late String fromId;
late String toId;
double amount = 150.0;
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
      despatchCairoCommands(cmd, data);
    } else {
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
    alexSendPort?.send(
      map(_currentBranch, Commands.withdraw.name, {
        "fromId": fromId,
        "amount": amount,
      }),
    );
  } else if (cmd == Commands.withdraw.name) {
    final status = data["status"];
    toId = _cairoAccounts[0].id;
    if (status) {
      cairoSendPort?.send(
      map(_currentBranch, Commands.deposit.name, {
        "to": toId,
        "amount": amount,
      }),
    );
    }
  }  else if(cmd == Commands.deposit.name){
    final status = data["status"];
    if (status) {
      print("Very Excelnt");
    } else {
      print("Not Excelnt");
    }
  }
  
  
  else {
    print("alex------------------------------alex");
    print(data);
  }
}

SendPort? cairoSendPort;

despatchCairoCommands(cmd, data) {
  if (cmd == Commands.initialSetup.name) {
    cairoSendPort = data as SendPort;
    cairoSendPort?.send(
      map(_currentBranch, Commands.create.name, newCairoAccounts),
    );
  } else if (cmd == Commands.accounts.name) {
    _cairoAccounts =
        (data as List<Map<String, dynamic>>)
            .map((a) => Account.formJson(a))
            .toList();
  
  } else if (cmd == Commands.deposit.name) {
    final staus = data["status"]  as bool;
    final msg = data["msg"] ;
    if(staus){
    print("Exclent");
    }
    else{
      print("need to rollback");
      alexSendPort?.send(map(_currentBranch, Commands.deposit.name, {
        "to":fromId,
        "amount": amount,
      }));
    }
   
  } else {
    print("Cairo------------------------------Cairo");
    print(data);
  }
}
