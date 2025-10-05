import 'package:bank_system/model/accounts/account.dart';
import 'package:bank_system/model/banks/bank.dart';
import 'package:bank_system/model/transaction.dart';
import 'package:bank_system/util/custom_exception.dart';

class AlexBank extends Bank {
  List<Account> accounts = [];

  @override
  void createNewAccount(Account account) {
    final ac = account;
    ac.saveTranstion(
      ac.transaction(Operation.creatAccount, Status.success, account.balance),
    );
    accounts.add(ac);
  }

  @override
  Future<void> transfer(String fromId, String toId, double amount) async {
    final from = accounts.firstWhere((a) => a.id == fromId);
    final to = accounts.firstWhere((a) => a.id == toId);

    if (from.nameBranch != to.nameBranch) {
      throw MyException("Cross-branch transfer not allowed");
    }
    try {
      isAmountValid(amount);
      await from.withdraw(amount);

      try {
        to.incrementBalance(amount);
      } catch (e) {
        from.balance += amount;
        rethrow;
      }
    } catch (e) {
      rethrow;
    }
  }
}
