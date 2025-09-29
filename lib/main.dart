
import 'dart:convert';

import 'package:bank_system/model/account.dart';
import 'package:bank_system/model/alex_bank.dart';
import 'package:bank_system/model/cash_account.dart';
import 'package:bank_system/model/saving_accout.dart';
import 'package:uuid/uuid.dart';
import 'dart:isolate';
void main(List<String> args) async{
  final a = SavingAccout(name: "mohammed ", id: Uuid().v4(), dateOpened: DateTime.now(), balance: 5000.0);
  final as = CashAccount(name: "mohammed ", id: Uuid().v4(), dateOpened: DateTime.now(), balance: 5000.0);
  final alex = AlexBank();
   alex.createNewAccount(a);
   alex.createNewAccount(as);
  final accounts = alex.accounts;

  accounts.forEach((account){
  final json =  account.toJson();
  print(json );
  print('--------------------');
  final acc = Account.formJson(json);

  print(acc );
  });
   


}

void alexBranch(SendPort mainSendPort){
  final newAccounts = [
  ];
  final alexReceivePort = ReceivePort();
   final alex = AlexBank();
}