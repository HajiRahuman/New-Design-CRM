
class GetOPT {
  final bool error;
  final String msg;
  final String clientId;

  GetOPT({
    required this.error,
    required this.msg,
    required this.clientId,
  });

  factory GetOPT.toJson(Map<String, dynamic> json) {
    return GetOPT(
      error: json['error'] ?? false,
      msg: json['msg'] ?? '',
      clientId: json['client_id'] ?? '',
    );
  }

  // Optional: Convert MyDataModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'error': error,
      'msg': msg,
      'client_id': clientId,
    };
  }
}
