import 'package:bank_system/model/accounts/account.dart';
import 'package:bank_system/model/banks/bank.dart';
import 'package:bank_system/model/transaction.dart';

class CairoBank extends Bank {
List<Account> accounts= [];
  @override
  void createNewAccount(Account account) {
    final ac = account;
    ac.saveTranstion(ac.transaction( Operation.creatAccount,Status.success,account.balance,));
    accounts.add(ac);
  
  }
  
  @override
  void transfer(String from, String to, double amount) {
  }


}
