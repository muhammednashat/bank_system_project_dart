
import 'package:bank_system/model/cash_account.dart';
import 'package:bank_system/model/saving_accout.dart';
import 'package:bank_system/model/transaction.dart';
import 'package:uuid/uuid.dart';

enum AccountType{
  saving,
  cash;

}

abstract class Account{

  final List<Transaction> transactions = [];

  String id;
  String name;
  double balance;
  DateTime dateOpened;
  AccountType accountType;

  Account({required this.id, required this.name, required this.balance,required  this.dateOpened, required this.accountType });

  factory Account.formJson(Map<String, dynamic> json){
    final type = AccountType.values.byName(json["accountType"] as String);
    switch(type){
  
      case AccountType.saving:
      return SavingAccout.formJson(json);

      case AccountType.cash:
      return CashAccount.formJson(json);
  
    }



  }
 
  

  
 




  void printTransactions() {
    for (var element in transactions) {
      print(element);
    }
  }

  void saveTranstion(Transaction transaction) {
    transactions.add(transaction);
  }
  Transaction transaction(
    Operation operation,
    Status status,
    double amount,
    Account account,
  ) {
    return Transaction(
      status: status,
      operation: operation,
      amount: amount,
      date: account.dateOpened,
      accountId: account.id,
      balanceAfter: account.balance,
      balancebefore: account.balance - amount,
    );
  }





 Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'balance': balance,
    'dateOpened': dateOpened.toIso8601String(),
    'accountType': accountType.name,
  };


   


   @override
  String toString() {
    return 'Account{id: $id, name: $name, balance: $balance, dateOpened: $dateOpened, accountType: $accountType}';
  }

}