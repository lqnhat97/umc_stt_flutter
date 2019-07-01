class NurseRequest {
  bool isCLS;
  bool isXetNghiem;
  String tenThuKi, tenChuyenKhoa, tenKhuVuc, Lau, soPhong, caKham, idPhong;
  List<ClinicTable> danhSachBan;

  NurseRequest(
      {this.isXetNghiem,
      this.isCLS,
      this.tenChuyenKhoa,
      this.tenKhuVuc,
      this.Lau,
      this.soPhong,
      this.caKham,
      this.danhSachBan,
      this.idPhong,
      this.tenThuKi});

  factory NurseRequest.fromJson(Map<String, dynamic> json) {
    var ListBan = json['danhSachBan'] as List;
    List<ClinicTable> list =
        ListBan.map((i) => ClinicTable.fromJson(i)).toList();
    return NurseRequest(
        isXetNghiem: json['isXetNghiem'],
        isCLS: json['isCLS'],
        tenChuyenKhoa: json['tenChuyenKhoa'],
        tenKhuVuc: json['tenKhuVuc'],
        Lau: json['Lau'],
        soPhong: json['soPhong'],
        caKham: json['caKham'],
        danhSachBan: list,
        idPhong: json['IDPhong'],
        tenThuKi: json['tenThuKi']);
  }
}

class ClinicTable {
  String IDBan, soBan, bacSi, BenhNhan, STTCuoi, STTHienTai, SoLuongRequest;

  ClinicTable(
      {this.IDBan,
      this.soBan,
      this.bacSi,
      this.BenhNhan,
      this.STTCuoi,
      this.STTHienTai,
      this.SoLuongRequest});

  factory ClinicTable.fromJson(Map<String, dynamic> json) {
    return ClinicTable(
        IDBan: json['IDBan'],
        soBan: json['soBan'],
        bacSi: json['bacSi'],
        BenhNhan: json['BenhNhan'],
        STTCuoi: json['STTCuoi'],
        STTHienTai: json['STTHienTai'],
        SoLuongRequest: json['SoLuongRequest']);
  }
}
