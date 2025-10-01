

import 'package:bank_system/model/accounts/account.dart';
import 'package:bank_system/model/transaction.dart';

abstract class Bank {

 
 void createNewAccount(Account account);

 void transfer(String fromId, String toId, double amount); 




}