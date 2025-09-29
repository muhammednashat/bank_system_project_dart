import 'package:bank_system/model/account.dart';

class SavingAccout extends Account {

  SavingAccout({
  required  super.name,
  required super.id,
  required super.dateOpened,
  required super.balance
  }):super(accountType:AccountType.saving );



  factory SavingAccout.formJson(Map<String, dynamic> json) {
    return SavingAccout(
      id: json["id"],
      name: json["name"],
      balance: json["balance"],
      dateOpened:DateTime.parse( json["dateOpened"] as String),
    );
  }


}
