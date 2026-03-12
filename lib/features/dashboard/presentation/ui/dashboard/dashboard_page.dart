import 'package:e_commerce/features/dashboard/presentation/ui/nav_page/home_nav_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../Profile/Data/ui/profileScreen.dart';
import '../../../../cart/presentation/ui/cart _page.dart';
import '../../../../order/ui/All_order_page.dart';

class DashBoardPage extends StatefulWidget{
  @override
  State<DashBoardPage> createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {

  List<Widget> mPages =[
    OrderScreen(),
    Container(color:Colors.white,child:Center(child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: Text("There was no API for Adding Likes to Product.So that's why i was unable to show anything in this page ", style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),),
    )),),
    HomeNavePage(),
    CartScreen(),
    ProfileScreen()
  ];

  int selectedIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: mPages[selectedIndex],
      bottomNavigationBar : BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 7,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(onPressed: (){
              selectedIndex=0;
              setState(() {});
            }, icon: Icon(Icons.window_rounded,size: 32,),color: selectedIndex ==0?Color(0xffFF650E).withAlpha(100):Colors.black26,),
            IconButton(onPressed: (){
              selectedIndex=1;
              setState(() {});
            }, icon: Icon(Icons.favorite_border,size: 32,),color:  selectedIndex ==1?Color(0xffFF650E).withAlpha(100):Colors.black26,),
            SizedBox(width: 60,),
            IconButton(onPressed: (){
              selectedIndex=3;
              setState(() {});
            }, icon: Icon(Icons.shopping_cart_outlined,size: 32,),color:  selectedIndex ==3?Color(0xffFF650E).withAlpha(100):Colors.black26,),
            IconButton(onPressed: (){
              selectedIndex=4;
              setState(() {});
            }, icon: Icon(Icons.person,size: 32,),color:  selectedIndex ==4?Color(0xffFF650E).withAlpha(100):Colors.black26,),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xffFF650E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        onPressed: (){
          selectedIndex=2;
          setState(() {});
        },
        child: Icon(Icons.home_outlined,color: Colors.white,),
      ),
    );
  }
}