class AddressBook {
  String alicename;
  String? address;
  // String region;
  // int country;
  String? state;
  String? district;
  String block;
  int pincode;
  String village;
  AddressBook({
    required this.alicename,
    required this.address,
    // required this.region,
    // required this.country,
    required this.state,
    required this.district,
    required this.block,
    required this.pincode,
    required this.village,
  });

  factory AddressBook.toJson(Map<String, dynamic> resp) {
    return AddressBook(
      alicename: resp['alicename'] != null ? resp['alicename'] : '',
      address: resp['address'] != null ? resp['address'] : '',
      // region: resp['region'] != null ? resp['region'] : '',
      // country: resp['country'] != null ? resp['country'] : 0,
      state: resp['state'] != null ? resp['state'] : '',
      district: resp['district'] != null ? resp['district'] : '',
      block: resp['block'] != null ? resp['block'] : '',
      pincode: resp['pincode'] != null ? resp['pincode'] : 0,
      village: resp['village'] != null ? resp['village'] : '',
    );
  }
}
