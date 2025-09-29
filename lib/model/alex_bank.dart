import 'package:bank_system/model/account.dart';
import 'package:bank_system/model/bank.dart';
import 'package:bank_system/model/transaction.dart';

class AlexBank implements Bank {
  
  List<Account> accounts= [];

  @override
  void createNewAccount(Account account) {

    final ac = account;
    ac.saveTranstion(ac.transaction( Operation.creatAccount,Status.success,account.balance, account));
    accounts.add(ac);
  
  }
  


  




}
