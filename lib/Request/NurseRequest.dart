class NurseRequest {
  bool isCLS;
  String tenThuKi,
      tenChuyenKhoa,
      tenKhuVuc,
      Lau,
      soPhong,
      caKham,
      STTCuoi,
      STTHienTai,
      idPhong;
  List<ClinicTable> danhSachBan;

  NurseRequest(
      {this.isCLS,
      this.tenChuyenKhoa,
      this.tenKhuVuc,
      this.Lau,
      this.soPhong,
      this.caKham,
      this.STTCuoi,
      this.STTHienTai,
      this.danhSachBan,
      this.idPhong,
      this.tenThuKi});

  factory NurseRequest.fromJson(Map<String, dynamic> json) {
    var ListBan = json['danhSachBan'] as List;
    List<ClinicTable> list =
    ListBan.map((i) => ClinicTable.fromJson(i)).toList();
    return NurseRequest(
        isCLS: json['isCLS'],
        tenChuyenKhoa: json['tenChuyenKhoa'],
        tenKhuVuc: json['tenKhuVuc'],
        Lau: json['Lau'],
        soPhong: json['soPhong'],
        caKham: json['caKham'],
        STTCuoi: json['STTCuoi'],
        STTHienTai: json['STTHienTai'],
        danhSachBan:list,
        idPhong: json['idPhong'],
        tenThuKi: json['tenThuKi']);
  }
}

class ClinicTable {
  bool checkVal =false;
  String IDBan, soBan, bacSi, BenhNhan;

  ClinicTable({this.IDBan, this.soBan, this.bacSi, this.BenhNhan});

  factory ClinicTable.fromJson(Map<String, dynamic> json) {
    return ClinicTable(
        IDBan: json['IDBan'],
        soBan: json['soBan'],
        bacSi: json['bacSi'],
        BenhNhan: json['BenhNhan']);
  }
}
