abstract class UserEvent {}

class UserAuthenticateEvent extends UserEvent {
  String email;
  String pass;

  UserAuthenticateEvent({
    required this.email,
    required this.pass,
  });
}

class UserRegisterEvent extends UserEvent {
  String email;
  String name;
  String mobNo;
  String pass;

  UserRegisterEvent({
    required this.email,
    required this.pass,
    required this.name,
    required this.mobNo,
  });
}
