abstract class ProfileEvent {}

class FetchUserProfileEvent extends ProfileEvent {
  final int userId;

  FetchUserProfileEvent({required this.userId});
}