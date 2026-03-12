import 'package:e_commerce/core/constants/app_constants.dart';
import 'package:e_commerce/core/constants/app_url.dart';
import 'package:e_commerce/core/services/api_service.dart';
import 'package:e_commerce/features/on_boarding/presntation/bloc/user_event.dart';
import 'package:e_commerce/features/on_boarding/presntation/bloc/user_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserBloc extends Bloc<UserEvent,UserState>{
  APIService apiService;
  UserBloc({required this.apiService}):super(UserInitialState()){


    on<UserRegisterEvent>((event, emit) async {
      emit(UserLoadingState());
      try{
      var responseBody = await apiService.postAPI(url: AppUrls.sign_up_url,isLoginRegister: true,mBody:{
          "name":event.name,
          "mobile_number":event.mobNo,
          "email":event.email,
          "password": event.pass
        } );
      if(responseBody["status"]==true){
        emit(UserSuccessState());
      }else{
        emit(UserFailureState(msg: responseBody["message"]));
      }

      }catch(e){
        emit(UserFailureState(msg: e.toString()));
      }
      
      
      
    });


    on<UserAuthenticateEvent>((event, emit) async {

      emit(UserLoadingState());
      try {
        var responseBody = await apiService.postAPI(url: AppUrls.login_url, isLoginRegister: true, mBody: {"email": event.email, "password": event.pass});

        if (responseBody["status"] == true) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String token = responseBody["tokan"];
          prefs.setString(AppConstants.prefUserToken, token);
          Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
          String realUserId = decodedToken["user_id"]?.toString() ?? decodedToken["id"]?.toString() ?? "1";
          prefs.setString(AppConstants.prefUserID, realUserId);
          emit(UserSuccessState());
        } else {
          emit(UserFailureState(msg: responseBody["message"]));
        }
      } catch (e) {
        emit(UserFailureState(msg: e.toString()));
      }
    });
  }

  }

