import 'package:bank_system/model/accounts/saving_accout.dart';
import 'package:uuid/uuid.dart';

final newAlexAccounts = [
  SavingAccout(
    name: "mohammed",
    id: Uuid().v4(),
    dateOpened: DateTime.now(),
    balance: 5000.0,
    nameBranch: "Alex Bank",
  ).toJson(),
  SavingAccout(
    name: "mohammed",
    id: Uuid().v4(),
    dateOpened: DateTime.now(),
    balance: 4000.0,
    nameBranch: "Alex Bank",
  ).toJson(),
  SavingAccout(
    name: "mohammed",
    id: Uuid().v4(),
    dateOpened: DateTime.now(),
    balance: 6000.0,
    nameBranch: "Alex Bank",
  ).toJson(),
  SavingAccout(
    name: "mohammed",
    id: Uuid().v4(),
    dateOpened: DateTime.now(),
    balance: 1000.0,
    nameBranch: "Alex Bank",
  ).toJson(),
];