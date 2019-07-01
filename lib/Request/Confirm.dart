class Confirm {
  String iDYeuCau,
      iDPhieuKham,
      banKham,
      Phong,
      STT,
      caKham,
      thoiDiem,
      tinhTrang;

  Confirm(
      {this.iDYeuCau,
      this.iDPhieuKham,
      this.banKham,
      this.Phong,
      this.STT,
      this.caKham,
      this.thoiDiem,
      this.tinhTrang});

  factory Confirm.fromJson(Map<String, dynamic> json) {
    return Confirm(
        iDYeuCau: json['IDYeuCau'],
        iDPhieuKham: json['IDPhieuKham'],
        banKham: json['BanKham'],
        Phong: json['Phong'],
        STT: json['STT'],
        caKham: json['CaKham'],
        thoiDiem: json['ThoiDiem'],
        tinhTrang: json['TinhTrang']);
  }
}

class ListConfirm{
  List<Confirm> list;
  ListConfirm(this.list);
  factory ListConfirm.fromJson(Map<String, dynamic> json) {
    var listLs = json['danhSachYeuCau'] as List;
    print(listLs);

    List<Confirm> list = listLs.map((i) => Confirm.fromJson(i)).toList();
    print(list);
    return ListConfirm(list);
  }
}
