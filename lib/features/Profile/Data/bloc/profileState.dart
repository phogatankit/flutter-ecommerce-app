import '../model/profileModel.dart';

abstract class ProfileState {}

class ProfileInitialState extends ProfileState {}

class ProfileLoadingState extends ProfileState {}

class ProfileLoadedState extends ProfileState {
  final ProfileModel profileData;

  ProfileLoadedState({required this.profileData});
}

class ProfileErrorState extends ProfileState {
  final String errorMsg;

  ProfileErrorState({required this.errorMsg});
}