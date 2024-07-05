
class UpdateSubsResp {
  bool error;
  String msg;
  UpdateSubsDet? data;

  UpdateSubsResp({required this.error, required this.msg, required this.data});

  factory UpdateSubsResp.toJson(Map<String, dynamic> json) {
    return UpdateSubsResp(
      error: json['error'],
      msg: json['msg'],
      data: UpdateSubsDet.toJson(json['data']),
    );
  }
}

class UpdateSubsDet {
  int id;
  int resellerid;
  int circleid;
  int acctype;
  int enablemac;
  bool usermode;
  int packid;
  String profileid;
  String expiration;
  String dllimit;
  String totallimit;
  int conntype;
  String ipv4;
  String ipv6;
  String username;
  int simultaneoususe;
  String createdon;
  UpdateSubsDetInfo info;
  List<AddressBook> addressBook;
  int acctstatus;
  int ipmode;
  int ip6mode;
  int ipv4id;
  int ipv6id;
  UpdateSubsDet({
    required this.id,
    required this.resellerid,
    required this.circleid,
    required this.acctype,
    required this.enablemac,
    required this.usermode,
    required this.packid,
    required this.profileid,
    required this.expiration,
    required this.dllimit,
    required this.totallimit,
    required this.conntype,
    required this.ipv4,
    required this.ipv6,
    required this.username,
    required this.simultaneoususe,
    required this.createdon,
    required this.info,
    required this.addressBook,
    required this.acctstatus,
    required this.ipmode,
    required this.ip6mode,
    required this.ipv4id,
    required this.ipv6id,

  });

  factory UpdateSubsDet.toJson(Map<String, dynamic> json) {

    return UpdateSubsDet(
      id: json['id'],
      resellerid: json['resellerid'],
      circleid: json['circleid'],
      acctype: json['acctype'],
      enablemac: json['enablemac'],

      usermode: json['usermode'],
      packid: json['packid'],
      profileid: json['profileid'],
      expiration: json['expiration'],
      dllimit: json['dllimit'],

      totallimit: json['totallimit'],
      conntype: json['conntype'],
      ipv4: json['ipv4'],
      ipv6: json['ipv6'],
      username: json['username'],
      simultaneoususe: json['simultaneoususe'],
      createdon: json['createdon'],
      info: UpdateSubsDetInfo.toJson(json['info']),
      addressBook: List<AddressBook>.from(
          json['address_book'].map((address) => AddressBook.toJson(address))),
      acctstatus: json['acctstatus'],
      ipmode: json['ipmode'],
      ip6mode: json['ip6mode'],
      ipv4id:json['ipv4id'],
      ipv6id:json['ipv6id'],

    );
  }
}

class UpdateSubsDetInfo {
  int id;
  String fullname;
  String emailpri;
  // String emailsec;
  String mobile;
  // String telnum;
  bool addressflag;
  // String company;
  // String contractfrom;
  // String contractto;
  bool gststatus;
  String ugst;
  // String desc;
  // double latitude;
  // double longitude;
  int aliceid;
  int ulmm;
  int locality;

  UpdateSubsDetInfo({
    required  this.id,
    required this.fullname,
    required this.emailpri,
    // required this.emailsec,
    required this.mobile,
    // required this.telnum,
    required  this.addressflag,
    // required this.company,
    // required this.contractfrom,
    // required this.contractto,
    required this.gststatus,
    required this.ugst,
    // required this.desc,
    // required this.latitude,
    // required  this.longitude,
    required  this.aliceid,
    required  this.ulmm,
    required  this.locality,
  });

  factory UpdateSubsDetInfo.toJson(Map<String, dynamic> json) {
    return UpdateSubsDetInfo(
      id: json['id'],
      fullname: json['fullname'],
      emailpri: json['emailpri'],
      // emailsec: json['emailsec'],
      mobile: json['mobile'],
      // telnum: json['telnum'],
      addressflag: json['addressflag'],
      // company: json['company'],
      // contractfrom: json['contractfrom'],
      // contractto: json['contractto'],
      gststatus: json['gststatus'],
      ugst: json['ugst'],
      // desc: json['desc'],
      // latitude: json['latitude'],
      // longitude: json['longitude'],
      aliceid: json['aliceid'],
      ulmm: json['ulmm'],
      locality: json['locality'],
    );
  }
}

class AddressBook {
  int aliceid;
  String alicename;
  int resellerid;
  String address;
  String region;
  int country;
  String state;
  String district;
  String block;
  int pincode;
  String village;

  AddressBook({
    required this.aliceid,
    required this.alicename,
    required  this.resellerid,
    required this.address,
    required this.region,
    required this.country,
    required this.state,
    required  this.district,
    required this.block,
    required  this.pincode,
    required this.village,
  });
  factory AddressBook.toJson(Map<String, dynamic> json) {
    return AddressBook(
      aliceid: json['aliceid']  ?? 0,
      alicename: json['alicename']??'',
      resellerid: json['resellerid'] ?? 0,
      address: json['address'] ?? '',
      region: json['region'] ?? '',
      country: json['country']??0,
      state: json['state']??'',
      district: json['district']??'',
      block: json['block']??'',
      pincode: json['pincode']??0,
      village: json['village']?? '',
    );
  }
}
