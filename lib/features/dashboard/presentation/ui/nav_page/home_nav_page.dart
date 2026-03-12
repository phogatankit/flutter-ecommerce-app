import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_commerce/features/dashboard/presentation/bloc/categorie/Categorie_state.dart';
import 'package:e_commerce/features/dashboard/presentation/bloc/categorie/categorie_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/widgets/ui helper.dart';
import '../../../../Detail/presentation/detail.dart';
import '../../bloc/categorie/categorie_event.dart';
import '../../bloc/product/Product Bloc.dart';
import '../../bloc/product/Product Event.dart';
import '../../bloc/product/product State.dart';

class HomeNavePage extends StatefulWidget{
  @override
  State<HomeNavePage> createState() => _HomeNavePageState();
}

class _HomeNavePageState extends State<HomeNavePage> {
  TextEditingController _searchController = TextEditingController();

  List<String> mBannerUrls = [
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcShU5RGj0QW-aK-Aqe-_BpNB8EiJw6pZkwgtw&s",
    "https://static.vecteezy.com/system/resources/previews/014/295/515/non_2x/end-of-year-sale-banner-template-design-big-sale-event-on-red-background-social-media-shopping-online-vector.jpg",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQoQigxZ4yA8MVK-3-mjzDrsm1kQZtSX-1N8g&s",
  ];
  List<Color> mColors = [
    Colors.black,
    Colors.blue,
    Colors.orange,
    Colors.red,
    Colors.black,
    Colors.blue,
    Colors.orange,
    Colors.red,
  ];
  List<String> catphoto = [
    "https://images.unsplash.com/photo-1685062428479-e310b7851de5?w=1600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8YW5kcm9pZCUyMGxvZ298ZW58MHx8MHx8fDA%3D",
    "https://images.unsplash.com/photo-1593642632823-8f785ba67e45?q=80&w=1932&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategorieBloc>().add(GetAllCategoryEvent());
      context.read<ProductBloc>().add(FetchAllProductEvent());
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              ///  two icons menu and notifications
              Padding(
                padding: const EdgeInsets.only(top: 10,left: 8,right: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(onTap:(){},
                        child: _circleButton(Icons.grid_view)
                    ),
                    InkWell(onTap:(){},
                        child: _circleButton(Icons.notifications)
                    )
                  ],
                ),

              ),
              /// search bar
              Padding(
                padding: const EdgeInsets.only(top: 8,left: 8,right: 8),
                child: TextFormField(
                  controller: _searchController,
                  decoration:myFieldDecoration2(hint: "search", label: "Search" , onPrefixTap: (){}, onSuffixTap: (){} ),
                ),
              ),
              ///carousel_slider
              Container(
                width: double.infinity,
                height: 150,
                margin: const EdgeInsets.only(left: 11.0, right: 11, top:10),
                child: CarouselSlider.builder(
                  itemCount: mBannerUrls.length,
                  itemBuilder: (_, index, _) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      width: double.infinity,
                      height: 210,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(21),
                        image: DecorationImage(
                          image: NetworkImage(mBannerUrls[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                  options: CarouselOptions(
                    autoPlay: true,
                    enableInfiniteScroll: true,
                    viewportFraction: 1,
                    autoPlayCurve: Curves.slowMiddle,
                  ),
                ),
              ),
              SizedBox(height: 10,),
              /// categorie horizontal slider
              SizedBox(
          height: 110,
          child: BlocListener<CategorieBloc, CategoryState>(
            listener: (context, state) {
              if (state is CategoryErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMsg),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: BlocBuilder<CategorieBloc, CategoryState>(
              builder: (context, state) {
                if (state is CategoryLoadedState) {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: state.mCat.length,
                    itemBuilder: (_, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              radius: 35,
                              backgroundImage: NetworkImage(catphoto[index]),
                            ),
                            Text(state.mCat[index].name ?? ""),
                          ],
                        ),
                      );
                    },
                  );
                }

                if (state is CategoryLoadingState) {
                  return Center(child: CircularProgressIndicator());
                }

                return SizedBox();
              },
            ),
          ),
        ),
              SizedBox(height: 11),
              /// Special for you <TEXT>
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Special for you",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text("See more"),
                  ],
                ),
              ),
              SizedBox(height: 11),
              Expanded(
                child: BlocBuilder<ProductBloc, ProductState>(
                  builder: (context, state) {

                    if (state is ProductErrorState) {
                      return Center(child: Text(state.errorMsg));
                    }

                    print("state : $state");

                    if (state is ProductLoadedState) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GridView.builder(
                          padding: EdgeInsets.zero,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 11,
                            crossAxisSpacing: 11,
                            childAspectRatio: 8 / 9,
                          ),
                          itemCount: state.allProduct.length,
                          itemBuilder: (_, index) {
                            return InkWell(
                              onTap: () {

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductDetailPage(
                                      currProduct: state.allProduct[index],
                                    ),
                                  ),
                                );
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Stack(
                                  children: [

                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: Image.network(
                                              state.allProduct[index].image ??
                                                  "https://cdn.jhattse.com/resize?width=384&file=images/category/electronics.png&quality=75&type=webp",
                                              width: 100,
                                              height: 100,
                                            ),
                                          ),

                                          Text(
                                            state.allProduct[index].name ?? "",
                                            style: TextStyle(
                                              fontSize: 19,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),

                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [

                                              Text(
                                                "₹ ${state.allProduct[index].price ?? ""}",
                                                style: TextStyle(
                                                  fontSize: 19,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),

                                              mColors.length > 4
                                                  ? Row(
                                                children: List.generate(4, (index) {

                                                  if (index == 3) {
                                                    return Container(
                                                      margin: EdgeInsets.only(left: 2),
                                                      width: 20,
                                                      height: 20,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          "+${mColors.length - 3}",
                                                          style: TextStyle(
                                                            fontSize: 11,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  } else {
                                                    return Container(
                                                      margin: EdgeInsets.only(left: 2),
                                                      width: 20,
                                                      height: 20,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                          color: mColors[index],
                                                        ),
                                                      ),
                                                      child: Container(
                                                        margin: EdgeInsets.all(1),
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          color: mColors[index],
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                }),
                                              )
                                                  : Row(
                                                children: List.generate(
                                                  mColors.length,
                                                      (index) {
                                                    return Container(
                                                      margin: EdgeInsets.only(left: 2),
                                                      width: 20,
                                                      height: 20,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                          color: mColors[index],
                                                        ),
                                                      ),
                                                      child: Container(
                                                        margin: EdgeInsets.all(1),
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          color: mColors[index],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),

                                          SizedBox(height: 5),

                                        ],
                                      ),
                                    ),

                                    Positioned(
                                      right: 0,
                                      child: Container(
                                        width: 45,
                                        height: 45,
                                        decoration: BoxDecoration(
                                          color: Colors.deepOrangeAccent,
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(25),
                                            bottomLeft: Radius.circular(11),
                                          ),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.favorite_border,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }

                    return Container();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _circleButton(IconData icon) {
    return Container(
      height: 44,
      width: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey.shade200,
      ),
      child: Icon(icon, color: Colors.black),
    );
  }
}
