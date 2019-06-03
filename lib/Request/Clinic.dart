class Clinic {
  List<Clinical> lamSang;
  List<Subclinical> canLamSang;

  Clinic({this.lamSang, this.canLamSang});

  factory Clinic.fromJson(Map<String, dynamic> json) {
    var listLs = json['lamSang'] as List;
    var listCls = json['canLamSang'] as List;
    List<Clinical> listClinical =
        listLs.map((i) => Clinical.fromJson(i)).toList();
    List<Subclinical> listSubclinical =
        listCls.map((i) => Subclinical.fromJson(i)).toList();

    return Clinic(lamSang: listClinical, canLamSang: listSubclinical);
  }
}

class Subclinical {
  String maPhongCls,
      tenPhong = "?",
      thoiGianDuKien,
      tenKhu,
      tenLau,
      sttHienTai,
      sttXetNghiem;
  int stt;

  Subclinical(
      {this.maPhongCls,
      this.tenPhong,
      this.stt,
      this.sttHienTai,
      this.thoiGianDuKien,
      this.tenKhu,
      this.tenLau,
      this.sttXetNghiem});

  factory Subclinical.fromJson(Map<String, dynamic> json) {
    return Subclinical(
        maPhongCls: json['maPhongCls'],
        tenPhong: json['tenPhong'],
        stt: json['stt'],
        sttHienTai: json['sttHienTai'],
        thoiGianDuKien: json['thoiGianDuKien'],
        tenKhu: json['tenKhu'],
        tenLau: json['tenLau'],
        sttXetNghiem: json['sttXetNghiem']);
  }
}

class Clinical {
  String maPhong, thoiGianDuKien, tenChuyenKhoa, tenKhu, tenLau, maPhieuKham;
  int stt, sttHienTai;

  Clinical(
      {this.maPhong,
      this.stt,
      this.sttHienTai,
      this.thoiGianDuKien,
      this.tenChuyenKhoa,
      this.tenKhu,
      this.tenLau,
      this.maPhieuKham});

  factory Clinical.fromJson(Map<String, dynamic> json) {
    return Clinical(
        maPhong: json['maPhong'],
        stt: json['stt'],
        sttHienTai: json['sttHienTai'],
        thoiGianDuKien: json['thoiGianDuKien'],
        tenChuyenKhoa: json['tenChuyenKhoa'],
        tenKhu: json['tenKhu'],
        tenLau: json['tenLau'],
        maPhieuKham: json['maPhieuKham']);
  }
}
