
class GetResults {

  late int userId;
  late int guestId;
  late String tgo;


  GetResults(this.userId, this.guestId, this.tgo);


  factory GetResults.fromJson(dynamic json) {
    return GetResults(
      json['userId'] as int,
      json['guestId'] as int,
      json['tgo'] as String
    );

  }

  @override
  String toString() {
    return '{ ${this.userId},'
        ' ${this.guestId},'
        ' ${this.tgo} }';
  }


}