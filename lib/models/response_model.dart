class ResponseModel {
  ResponseModel(this._isSuccess, this._message);
  bool _isSuccess;
  String _message;

  bool get isSuccess => _isSuccess;
  String get message => _message;
}
