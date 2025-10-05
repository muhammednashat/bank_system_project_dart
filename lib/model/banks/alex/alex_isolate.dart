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

     if(senderBranch == Branches.main.name){
      despatchMainCommands(cmd, data, mainSendPort);
        
    } else {
      print("$_currentBranch Unknown commond:$cmd");
    }
  });
}
void despatchMainCommands(cmd, data , SendPort mainSendPort) async{
  if ( cmd == Commands.create.name) {
      final accounts = data as  List<Map<String, dynamic>>;
       for (var account in accounts) {
         _alexBank.createNewAccount(Account.formJson(account));
       }
      mainSendPort.send(
        map(
          _currentBranch,
          Commands.accounts.name,
          jsonList(_alexAccounts),
        ),
      );
    } else if (cmd == Commands.transfer.name) {
   
      final map = data as Map<String, dynamic>;
      try {
        final status = await _alexBank.transfer(
          map["from"],
          map["to"],
          map["amount"],
        );
        print("done");
      } catch (e) {
        print(e);
      }
    } else if (cmd == Commands.withdraw.name) {
      final fromId = data["fromId"];
      final amount = data["amount"];
      final from = _alexAccounts.firstWhere((a){
      return a.id == fromId;
      });
      await from.withdraw(amount);
    mainSendPort.send(map(_currentBranch, Commands.withdraw_status, "done"));
       
}else{
  print("No thing to exceute");
}
}
