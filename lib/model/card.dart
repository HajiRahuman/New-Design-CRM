
class CardDet {
 final int id;
  final int resellerId;
  final int cardType;
  final int cardPrice;
  final String expiration;
  final int packId;
  final int dlLimit;
  final int upLimit;
  final int totalLimit;
  final int timeLimit;
  final int cardExpiry;
  final int cardDuration;
  final int cardDurationType;
  final int simultaneousUse;
  final String profileId;
  final String authPassword;
  final String packMode;
  final String packName;
  final String conn;
  final int soc;
  final String username;
  final int verifyMobile;
  CardDet( {
   required this.id,
    required this.resellerId,
    required this.cardType,
    required this.cardPrice,
    required this.expiration,
    required this.packId,
    required this.dlLimit,
    required this.upLimit,
    required this.totalLimit,
    required this.timeLimit,
    required this.cardExpiry,
    required this.cardDuration,
    required this.cardDurationType,
    required this.simultaneousUse,
    required this.profileId,
    required this.authPassword,
    required this.packMode,
    required this.packName,
    required this.conn,
    required this.soc,
    required this.username,
    required this.verifyMobile,
  });
  factory CardDet.toJson(Map<dynamic, dynamic> json) {
    return CardDet(
      id: json['id']?? 0,
      resellerId: json['resellerid']?? 0,
      cardType: json['cardtype']?? 0,
      cardPrice: json['cardprice']?? 0,
      expiration: json['expiration']?? "",
      packId: json['packid']?? "",
      dlLimit: json['dllimit']?? 0,
      upLimit: json['uplimit']?? 0,
      totalLimit: json['totallimit']?? 0,
      timeLimit: json['timelimit']?? 0,
      cardExpiry: json['cardexpiry']?? 0,
      cardDuration: json['cardduration']?? 0,
      cardDurationType: json['carddurationtype']?? 0,
      simultaneousUse: json['simultaneoususe']?? 0,
      profileId: json['profileid']?? "",
      authPassword: json['authpsw']?? "",
      packMode: json['packmode']?? "",
      packName: json['packname']?? "",
      conn: json['conn']?? "",
      soc: json['soc']?? 0,
      username: json['username']?? "",
      verifyMobile: json['verifymobile']?? 0,
    );
  }
}

class CardResp {
  final String msg;
  final bool error;
  final List<CardDet>? data;

  CardResp({required this.msg, required this.error, this.data});

  factory CardResp.toJson(Map<dynamic, dynamic> data) {
    return CardResp(
        error: data['error'],
        msg: data['msg'],
        data: data['data'] is List
            ? List<CardDet>.from(
            data['data'].map((e) => CardDet.toJson(e)))
            : []);
  }
}



class UpadteCardUserDet {
 final int id;
  final int resellerId;
  final int cardType;
  final int cardPrice;
  final String expiration;
  final int packId;
  final int dlLimit;
  final int ulLimit;
  final int totalLimit;
  final int timeLimit;
  final int cardExpiry;
  final int cardDuration;
  final int cardDurationType;
  final int simultaneousUse;
  final String profileId;

  UpadteCardUserDet(
      {
   required this.id,
    required this.resellerId,
    required this.cardType,
    required this.cardPrice,
    required this.expiration,
    required this.packId,
    required this.dlLimit,
    required this.ulLimit,
    required this.totalLimit,
    required this.timeLimit,
    required this.cardExpiry,
    required this.cardDuration,
    required this.cardDurationType,
    required this.simultaneousUse,
    required this.profileId,});
  factory UpadteCardUserDet.toJson(Map<dynamic, dynamic> json) {
    return UpadteCardUserDet(
        id: json['id']??0,
      resellerId: json['resellerid']??0,
      cardType: json['cardtype']??0,
      cardPrice: json['cardprice']??0,
      expiration:json['expiration']??"",
      packId: json['packid']??0,
      dlLimit: json['dllimit']??0,
      ulLimit: json['uplimit']??0,
      totalLimit: json['totallimit']??0,
      timeLimit: json['timelimit']??0,
      cardExpiry: json['cardexpiry']??0,
      cardDuration: json['cardduration']??0,
      cardDurationType: json['carddurationtype']??0,
      simultaneousUse: json['simultaneoususe']??0,
      profileId: json['profileid']??""
    );
  }
}

class UpadteCardUserDetResp {
  final String msg;
  final bool error;
  final UpadteCardUserDet? data;
  UpadteCardUserDetResp({required this.error, required this.msg, this.data});

  factory UpadteCardUserDetResp.toJson(Map<dynamic, dynamic> json) {
    return UpadteCardUserDetResp(
        error: json['error'],
        msg: json['msg'],
        data: json['data'] != null
            ? UpadteCardUserDet.toJson(json['data'])
            : null);
  }
}
