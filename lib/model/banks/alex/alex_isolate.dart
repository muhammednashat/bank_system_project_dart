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

    if (senderBranch == Branches.main.name && cmd == Commands.create.name) {
      final account = Account.formJson((data as Map<String, dynamic>));
      _alexBank.createNewAccount(account);
    } else if (senderBranch == Branches.main.name &&
        cmd == Commands.accounts.name) {
      mainSendPort.send(
        map(
          _currentBranch,
          Commands.accounts.name,
          jsonList(_alexBank.accounts),
        ),
      );
    } else if (senderBranch == Branches.main.name &&
        cmd == Commands.transfer.name) {
      print(message);
      final map = data as Map<String, dynamic>;
      final status = await _alexBank.transfer(map["from"], map["to"], map["amount"]);
       print("done");
    } else {
      print("$_currentBranch Unknown commond:$cmd");
    }
  });
}

List<Map<String, dynamic>> jsonList(List<Account> accounts) {
  return accounts.map((account) => account.toJson()).toList();
}
