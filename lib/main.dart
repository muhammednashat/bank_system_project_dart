
import 'dart:convert';

import 'package:bank_system/model/accounts/account.dart';
import 'package:bank_system/model/banks/alex_bank.dart';
import 'package:bank_system/model/banks/cairo_bank.dart';
import 'package:bank_system/model/accounts/cash_account.dart';
import 'package:bank_system/model/accounts/saving_accout.dart';
import 'package:uuid/uuid.dart';
import 'dart:isolate';

  enum Branches{
    alex,
    cairo;
  }
 enum Commonds{
  ready,
  create,
  withdraw,
  deposit;
 }
   
  final newAccounts = [
   SavingAccout(name: "mohammed", id: Uuid().v4(), dateOpened: DateTime.now(), balance: 5000.0 , nameBranch: "Alex Bank"),
   SavingAccout(name: "mohammed", id: Uuid().v4(), dateOpened: DateTime.now(), balance: 4000.0 , nameBranch: "Alex Bank"),
   SavingAccout(name: "mohammed", id: Uuid().v4(), dateOpened: DateTime.now(), balance: 6000.0 , nameBranch: "Alex Bank"),
   SavingAccout(name: "mohammed", id: Uuid().v4(), dateOpened: DateTime.now(), balance: 1000.0 , nameBranch: "Alex Bank"),
   ];

Map<String, dynamic> map(String branch, String commond, dynamic data) => {
  "branch": branch,
  "commond": commond,
  "data": data,
};




void main(List<String> args) async{
  
  final mainReceivePort = ReceivePort();
   await Isolate.spawn(alexBranch, mainReceivePort.sendPort);
   await Isolate.spawn(cairoBranch, mainReceivePort.sendPort);

  mainReceivePort.listen((message){
    if (message is Map) {

      final data  = message["data"];
      final cmd = message["commond"];
      final branch = message["branch"];  
      if (branch == Branches.alex.name) {
      
      } else {
        print("ur");
        
      }
      
    }else{
    print(message);

    }
  }); 

}

void alexBranch(SendPort mainSendPort){
   final branch = Branches.alex.name;
  final alexBank = AlexBank();
  final alexReceivePort = ReceivePort();

  mainSendPort.send(map(branch, Commonds.ready.name, null));
  
}




















void cairoBranch(SendPort mainSendPort){

  final cairoBank = CairoBank();
}


