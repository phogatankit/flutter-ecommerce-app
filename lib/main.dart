import 'package:e_commerce/core/routes/app_routes.dart';
import 'package:e_commerce/core/services/api_service.dart';
import 'package:e_commerce/features/on_boarding/presntation/bloc/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/Profile/Data/bloc/profileBloc.dart';
import 'features/cart/presentation/bloc/cartbloc/cart_bloc.dart';
import 'features/dashboard/presentation/bloc/categorie/categorie_bloc.dart';
import 'features/dashboard/presentation/bloc/product/Product Bloc.dart';
import 'features/order/bloc/OrderBloc/OrderBloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiBlocProvider(providers: [
    BlocProvider(create: (context)=>UserBloc(apiService: APIService())),
    BlocProvider(create: (context)=>CategorieBloc(apiService: APIService())),
    BlocProvider(create: (context)=>ProductBloc(apiService: APIService())),
    BlocProvider(create: (context)=>CartBloc(apiService: APIService())),
    BlocProvider(create: (context)=>ProfileBloc(apiService: APIService())),
    BlocProvider(create: (context)=>OrderBloc(apiService: APIService()))
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash_page,
      routes: AppRoutes.mRoutes ,
    );
  }
}
