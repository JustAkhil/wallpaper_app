class AppException implements Exception {
  String msg;
  String title;

  AppException({required this.msg, required this.title});

  @override
  String toString() {
    return "$title";
  }
}

class FetchDataException extends AppException {
  FetchDataException({required String errMsg})
      : super(msg: errMsg, title: "No Internet Connection");
}

class BadRequestException extends AppException {
  BadRequestException({required String errMsg})
      : super(msg: errMsg, title: "Invalid Request");
}

class UnauthorisedException extends AppException {
  UnauthorisedException({required String errMsg})
      : super(msg: errMsg, title: "Unauthorised");
}

class InvalidInputException extends AppException {
  InvalidInputException({required String errMsg})
      : super(msg: errMsg, title: "Invalid Input");
}


