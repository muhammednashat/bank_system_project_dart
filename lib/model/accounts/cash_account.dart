import 'package:bank_system/model/accounts/account.dart';

class CashAccount extends Account {
  CashAccount({
    required super.nameBranch,
    required super.id,
    required super.name,
    required super.dateOpened,
    required super.balance,
  }) : super(accountType: AccountType.cash);

  factory CashAccount.formJson(Map<String, dynamic> json) {
    return CashAccount(
      nameBranch: json['nameBranch'],
      id: json['id'],
      name: json["name"],
      balance: json['balance'],
      dateOpened: DateTime.parse(json["dateOpened"] as String),
    );
  }

 
}
