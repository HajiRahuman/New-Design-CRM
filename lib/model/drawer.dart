
class DepositSummary {
  
 final int total;
 final int online;
 final int other;

  DepositSummary(
      {
     required this.total,
     required this.online,
     required this.other,
     
     });
  factory DepositSummary.toJson(Map<dynamic, dynamic> data) {
    return DepositSummary(
        total: data['total'] ?? '0',
        online: data['online'] ?? '0',
        other: data['other'] ?? '0',
   
        );
  }
}

class DepositSummaryResp {
  final String msg;
  final bool error;
  final DepositSummary? summary;
  DepositSummaryResp({required this.error, required this.msg, this.summary});

  factory DepositSummaryResp.toJson(Map<dynamic, dynamic> data) {
    return DepositSummaryResp(
        error: data['error'],
        msg: data['msg'],
        summary: data['summary'] != null
            ? DepositSummary.toJson(data['summary'])
            : null);
  }
}
