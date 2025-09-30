import 'package:bank_system/model/accounts/account.dart';

class SavingAccout extends Account {
  SavingAccout({
    required super.nameBranch,
    required super.name,
    required super.id,
    required super.dateOpened,
    required super.balance,
  }) : super(accountType: AccountType.saving);

  factory SavingAccout.formJson(Map<String, dynamic> json) {
    return SavingAccout(
      nameBranch: json["nameBranch"],
      id: json["id"],
      name: json["name"],
      balance: json["balance"],
      dateOpened: DateTime.parse(json["dateOpened"] as String),
    );
  }


}
