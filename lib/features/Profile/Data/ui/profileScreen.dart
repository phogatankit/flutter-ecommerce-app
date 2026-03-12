import 'package:e_commerce/core/constants/app_constants.dart';
import 'package:e_commerce/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../bloc/profile Event.dart';
import '../bloc/profileBloc.dart';
import '../bloc/profileState.dart';
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String myUserId = prefs.getString(AppConstants.prefUserID) ?? "1";
        if(mounted){
          int parsedId = int.tryParse(myUserId) ?? 1;
          context.read<ProfileBloc>().add(FetchUserProfileEvent(userId: parsedId));
        }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "My Profile",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  IconButton(onPressed: (){
                    Navigator.pushReplacementNamed(context, AppRoutes.login_page);
                  }, icon: Icon(Icons.logout))
                ],
              ),
            ),
            Expanded(
              child: BlocConsumer<ProfileBloc, ProfileState>(
                listener: (context, state) {
                  if (state is ProfileErrorState) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.errorMsg),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is ProfileLoadingState) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.black),
                    );
                  }
                  if (state is ProfileErrorState) {
                    return Center(
                      child: Column(
                        mainAxisAlignment:MainAxisAlignment.center,
                        children: [
                          Text(state.errorMsg, style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
                          ElevatedButton(
                            onPressed: () {context.read<ProfileBloc>().add(FetchUserProfileEvent(userId: 2));},
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white,),
                            child: const Text("Try Again"),
                          ),
                        ],
                      ),
                    );
                  }
                  if (state is ProfileLoadedState) {
                    final profile = state.profileData;

                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [

                          Center(
                            child: Stack(
                              children: [
                                Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: const Color(0xFFFF6600), width: 3),
                                    image: DecorationImage(
                                      image: NetworkImage("https://image.petmd.com/files/styles/863x625/public/CANS_dogsmiling_379727605.jpg"),fit: BoxFit.fill
                                    ),
                                  ),
                                ),

                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFF6600),
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white, width: 2),
                                    ),
                                    child: const Icon(Icons.edit, color: Colors.white, size: 20),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(profile.name ?? "Unknown User", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),),
                          const SizedBox(height: 30),
                          DetailCard(icon: Icons.email_outlined, title: "Email", value: profile.email ?? "No email provided",),
                          const SizedBox(height: 15),
                          DetailCard(icon: Icons.phone_android_outlined, title: "Mobile Number", value: profile.mobileNumber ?? "No number provided",),
                          const SizedBox(height: 15),
                          DetailCard(icon: Icons.calendar_today_outlined, title: "Joined", value: Datekafun(profile.createdAt), ),




                        ],
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget DetailCard({required IconData icon, required String title, required String value}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F3F3),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: const Color(0xFFFF6600)),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String Datekafun(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return "Unknown";
    try {
      return rawDate.split(" ")[0];
    } catch (e) {
      return rawDate;
    }
  }
}