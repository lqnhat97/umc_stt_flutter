class HistoryRequest {
  String idHistory;
  String hoTen;
  BigInt tuoi;

  HistoryRequest(this.idHistory, this.hoTen, this.tuoi);

  factory HistoryRequest.fromJson(Map<String, dynamic> json) {
    var IdHistory = json['idHistory'];
    var HoTen = json['hoTen'];
    var Tuoi = json['tuoi'];
    return HistoryRequest(IdHistory, HoTen, Tuoi);
  }
}
