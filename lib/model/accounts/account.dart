import 'package:bank_system/model/accounts/cash_account.dart';
import 'package:bank_system/model/accounts/saving_accout.dart';
import 'package:bank_system/model/transaction.dart';
import 'package:bank_system/util/custom_exception.dart';
import 'package:bank_system/util/validation_amount.dart';

enum AccountType { saving, cash }

abstract class Account with ValidationAmount {
  final List<Transaction> transactions = [];

  String nameBranch;
  String id;
  String name;
  double balance;
  DateTime dateOpened;
  AccountType accountType;

  Account({
    required this.nameBranch,
    required this.id,
    required this.name,
    required this.balance,
    required this.dateOpened,
    required this.accountType,
  });

  void deposit(double amount) {
    Status status = Status.success;
    try {
      isAmountValid(amount);
      incrementBalance(amount);
    } catch (e) {
      print(e);
      status = Status.faild;
    } finally {
      saveTranstion(transaction(Operation.deposit, status, amount));
    }
  }

  void withdraw(double amount) {
    Status status = Status.success;
    try {
      isAmountValid(amount);
      if (amount > balance) {
        print("Insufficent -----------");
        throw MyException("Insufficient balance");
      }
    
      decreaseBalance(amount);
    } catch (e) {
      print(e);
      status = Status.faild;
    }finally{
      saveTranstion(transaction(Operation.withdraw,status,amount));
    }
  }
  factory Account.formJson(Map<String, dynamic> json) {
    final type = AccountType.values.byName(json["accountType"] as String);
    switch (type) {
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

  void incrementBalance(double amount) {
    balance += amount;
  }

  void decreaseBalance(double amount) {
    balance -= amount;
  }

  void saveTranstion(Transaction transaction) {
    transactions.add(transaction);
  }

  Transaction transaction(Operation operation, Status status, double amount) {
    return Transaction(
      nameBranch: nameBranch,
      status: status,
      operation: operation,
      amount: amount,
      date: DateTime.now(),
      accountId: id,
      balanceAfter: balance,
      balancebefore: (status == Status.success) ? balance - amount : balance ,
    );
  }

  Map<String, dynamic> toJson() => {
    'nameBranch': nameBranch,
    'id': id,
    'name': name,
    'balance': balance,
    'dateOpened': dateOpened.toIso8601String(),
    'accountType': accountType.name,
  };

  @override
  String toString() {
    return 'Account{nameBranch: $nameBranch, id: $id, name: $name, balance: $balance, dateOpened: $dateOpened, accountType: $accountType}';
  }
}
