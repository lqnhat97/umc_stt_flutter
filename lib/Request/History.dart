class HistoryRequest {
  String idHistory;
  String hoTen;
  int tuoi;

  HistoryRequest(this.idHistory, this.hoTen, this.tuoi);

  factory HistoryRequest.fromJson(Map<String, dynamic> json) {
    var IdHistory = json['idHistory'];
    var HoTen = json['hoTen'];
    var Tuoi = json['tuoi'];
    return HistoryRequest(IdHistory, HoTen, Tuoi);
  }
}

class HistoryRequestList {
  final List<HistoryRequest> list;

  HistoryRequestList({
    this.list,
  });

  factory HistoryRequestList.fromJson(List<dynamic> parsedJson) {

    List<HistoryRequest> history = new List<HistoryRequest>();
    history = parsedJson.map((i)=>HistoryRequest.fromJson(i)).toList();
    return new HistoryRequestList(
      list: history,
    );
  }
}
