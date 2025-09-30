
abstract interface class MyException implements Exception{
  factory MyException(String message) => _CustomException(message:message);
}

class _CustomException implements MyException {
   final String message;
  _CustomException({required this.message});

   @override
  String toString() {
    return "CustomeException( message: $message)" ;
  }


}