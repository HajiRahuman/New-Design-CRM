class PingResp {
  bool error;
  String msg;
  PingResp({
    required this.error,
    required this.msg
  });
  
  factory PingResp.toJson(Map<dynamic, dynamic> data) {
    return PingResp(
      error: data['error'],
      msg: data['msg']
    );
  }
}