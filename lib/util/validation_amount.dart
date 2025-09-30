import 'package:bank_system/util/custom_exception.dart';

mixin ValidationAmount {
  
  void isAmountValid(double amount) {
    if (amount == 0) {
      throw MyException("Amount equals zero");
    } else if (amount < 0) {
      throw MyException("Amount is less than zero");
    }
  }
}
