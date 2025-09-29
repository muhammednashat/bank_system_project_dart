
enum Status{
  success,
  faild
}

enum Operation{
  withdraw,
  deposit,
  creatAccount,
  
}
class Transaction {
  Status status;
  Operation operation;
  double amount;
  double balanceAfter;
  double balancebefore;
  DateTime date;
  String accountId;

  Transaction({
    required this.status,
    required this.operation,
    required this.amount,
    required this.date,
    required this.accountId,
    required this.balanceAfter,
    required this.balancebefore,
  });

  @override
  String toString() {
    return 'Transaction(status: $status, operation: $operation, amount: $amount, date: $date, accountId: $accountId, balanceAfter: $balanceAfter, balancebefore: $balancebefore)';
  }
}
