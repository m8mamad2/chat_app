class UserEntity{
  final int? id;
  final String? uid;
  final String? phone;
  final String? email;
  final String? groupUid;
  final bool? inOnline;
  final String? timestamp;
  final String? image;
  final String? name;
  final String? info;
  UserEntity({
    required this.id,
    required this.uid,
    required this.phone,
    required this.email,
    this.groupUid,
    required this.inOnline,
    this.timestamp,
    this.image,
    this.name,
    this.info
    });
}