class CompanyInfoDet {
  late final String privacy;
  final String refund;
  final String terms;
  final String url;
 
  

  CompanyInfoDet( {
    required this.privacy,
    required this.refund,
    required this.terms,
    required this.url,
    });

  factory CompanyInfoDet.toJson(Map<dynamic, dynamic> data){
    return CompanyInfoDet(

     privacy:data['privacy']?? "",
      refund: data['refund']?? "",
      terms:data['terms']??"",
      url: data['url']??"",
    );
  }

}

class CompanyInfoDetResp {
  final String msg;
  final bool error;
  final CompanyInfoDet? summary;
  CompanyInfoDetResp({required this.error, required this.msg, this.summary});

  factory CompanyInfoDetResp.toJson(Map<dynamic, dynamic> data) {
    return CompanyInfoDetResp(
        error: data['error'],
        msg: data['msg'],
        summary: data['data'] != null
            ? CompanyInfoDet.toJson(data['data'])
            : null);
  }
}

