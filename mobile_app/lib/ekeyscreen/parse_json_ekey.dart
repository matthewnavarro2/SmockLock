
class GetResults {

  late int userId;
  late int guestId;
  late String tgo;
  late String firstname;
  late String lastname;
  late String email;


  GetResults(this.userId, this.guestId, this.firstname, this.lastname, this.email, this.tgo);


  factory GetResults.fromJson(dynamic json) {
    return GetResults(
        json['userId'] as int,
        json['guestId'] as int,
        json['firstname'] as String,
        json['lastname'] as String,
        json['email'] as String,
        json['tgo'] as String
    );

  }

  @override
  String toString() {
    return '{ ${this.userId},'
        ' ${this.guestId},'
        ' ${this.firstname},'
        ' ${this.lastname},'
        ' ${this.email},'
        ' ${this.tgo} }';
  }


}