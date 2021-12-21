import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
class User {
  int id;
  String email;
  String first_name;
  String last_name;
  String avatar;
  User(this.id, this.email, this.first_name, this.last_name, this.avatar);
  factory User.fromJson(Map<dynamic, dynamic> json) => _$UserFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<dynamic, dynamic> toJson() => _$UserToJson(this);
}
