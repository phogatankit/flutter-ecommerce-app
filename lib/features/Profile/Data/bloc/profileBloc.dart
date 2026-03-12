import 'package:e_commerce/features/Profile/Data/bloc/profile%20Event.dart';
import 'package:e_commerce/features/Profile/Data/bloc/profileState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce/core/constants/app_url.dart'; // Adjust import path
import 'package:e_commerce/core/services/api_service.dart'; // Adjust import path

import '../model/profileModel.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  APIService apiService;

  ProfileBloc({required this.apiService}) : super(ProfileInitialState()) {

    on<FetchUserProfileEvent>((event, emit) async {
      emit(ProfileLoadingState());

      try {
        var responseBody = await apiService.postAPI(url: AppUrls.Profile_Url, mBody: {"user_id": event.userId,},);

        if (responseBody != null && (responseBody["status"] == "true" || responseBody["status"] == true)) {
          Map<String, dynamic>? dataMap = responseBody["data"];
          if (dataMap != null) {
            ProfileModel profile = ProfileModel.fromJson(dataMap);
            emit(ProfileLoadedState(profileData: profile));
          } else {
            emit(ProfileErrorState(errorMsg: "Profile data is empty."));
          }

        } else {
          emit(ProfileErrorState(errorMsg: responseBody?["message"] ?? "Failed to load profile."));
        }
      } catch (e) {
        emit(ProfileErrorState(errorMsg: "Error fetching profile: $e"));
      }
    });
  }
}