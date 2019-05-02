class Profile {
  String iD;

  String lastName;
  String middleName;
  String firstName;
  String idCardNumber;
  String gender;
  String birthDay;
  String homeTowm;
  String professional;
  String phoneNumber;
  String address;

  Profile(
      {this.iD,
      this.lastName,
      this.middleName,
      this.firstName,
      this.idCardNumber,
      this.gender,
      this.birthDay,
      this.homeTowm,
      this.professional,
      this.phoneNumber,
      this.address});

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
        iD: json['ID'],
        lastName: json['Ho'],
        middleName: json['TenLot'],
        firstName: json['Ten'],
        idCardNumber: json['CMND_CCCD'],
        gender: json['GioiTinh'],
        birthDay: json['NgaySinh'],
        homeTowm: json['QueQuan'],
        professional: json['NgheNghiep'],
        phoneNumber: json['SDT'],
        address: json['Diachi']);
  }
}
