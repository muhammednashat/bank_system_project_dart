

import 'package:bank_system/model/accounts/account.dart';
import 'package:bank_system/model/transaction.dart';
import 'package:bank_system/util/validation_amount.dart';

abstract class Bank with ValidationAmount {

 
 void createNewAccount(Account account);

 void transfer(String fromId, String toId, double amount); 




}