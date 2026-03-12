class AppException implements Exception{
  String exTitle, exMsg;
  AppException({required this.exTitle , required this.exMsg});

  @override
  String toString() {
    return "$exTitle : $exMsg";
  }

}
class NoInternetException extends AppException {
  NoInternetException({required String msg})
      : super(exTitle: "No Internet", exMsg: msg);
}

//500 and above
class ServerException extends AppException {
  ServerException({required String msg})
      : super(exTitle: "Server Error", exMsg: msg);
}

class BadRequestException extends AppException {
  BadRequestException({required String msg})
      : super(exTitle: "Bad Request", exMsg: msg);
}

class UnauthorizedException extends AppException {
  UnauthorizedException({required String msg})
      : super(exTitle: "Unauthorized", exMsg: msg);
}

//404
class NotFoundException extends AppException {
  NotFoundException({required String msg})
      : super(exTitle: "Not Found", exMsg: msg);
}

class InvalidInputException extends AppException {
  InvalidInputException({required String msg})
      : super(exTitle: "Invalid Input", exMsg: msg);
}
