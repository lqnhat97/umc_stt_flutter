class ConfirmNurse {
  String
  iDPhieuKham,

      STT,

      thoiDiem,
      tinhTrang;

  ConfirmNurse({
    this.iDPhieuKham,

    this.STT,

    this.thoiDiem,
    this.tinhTrang});

  factory ConfirmNurse.fromJson(Map<String, dynamic> json) {
    return ConfirmNurse(
        iDPhieuKham: json['IDPhieuKham'].toString(),
        STT: json['STT'].toString(),
        thoiDiem: json['ThoiDiem'].toString(),
        tinhTrang: json['TinhTrang'].toString());
  }
}

class ListConfirmNurse {
  List<ConfirmNurse> list;

  ListConfirmNurse(this.list);

  factory ListConfirmNurse.fromJson(Map<String, dynamic> json) {
    var listLs = json['danhSachYeuCau'] as List;
    if(listLs!=[]) {
      List<ConfirmNurse> list = listLs.map((i) => ConfirmNurse.fromJson(i))
          .toList();
      return ListConfirmNurse(list);
    }else{
      return ListConfirmNurse(listLs);
    }
  }
}
