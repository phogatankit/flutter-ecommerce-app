import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cart/presentation/bloc/cartbloc/cart_bloc.dart';
import '../../cart/presentation/bloc/cartbloc/cart_event.dart';
import '../../cart/presentation/bloc/cartbloc/cart_state.dart';
import '../../dashboard/data/model/product_model.dart';

class ProductDetailPage extends StatefulWidget {
  ProductModel currProduct ;
  ProductDetailPage({required this.currProduct});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  List<Color> mColors = [
    Colors.black,
    Colors.blue,
    Colors.orange,
    Colors.red,
  ];
  int selectedColourIndex=0;
  int activeTabIndex = 0;
  List<Widget> activeTabContant =[
    Center(child: Text(" This is description ", style: TextStyle(fontSize: 17),)),
    Center(child: Text(" This is Specifications ",style: TextStyle(fontSize: 17),)),
    Center(child: Text(" This is Reviews ",style: TextStyle(fontSize: 17),)),

  ];

  int count =1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                  flex: 45,
                  child: Container(
                    color: Colors.grey.shade200,
                    child:  Center(child: Image.network(widget.currProduct.image ?? "")),
                  )),
              Expanded(
                  flex: 55,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(41))
                    ),
                    child:Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 21,vertical: 11),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.currProduct.name!, style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),),
                          Text("\$${widget.currProduct.price!}", style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text('Seller: ', style: TextStyle(fontSize: 14, color: Colors.grey),),
                              Text('Tariqul islam', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Colors.white,
                                      size: 14,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      '4.8',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 10,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(' (320 Review)', style: TextStyle(color: Colors.grey, fontSize: 14),),
                            ],
                          ),
                          Text('Color', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
                          SizedBox(height: 7),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(
                                mColors.length, (index) {
                                return InkWell(
                                  onTap: (){
                                    setState(() {
                                      selectedColourIndex = index; // Update the state
                                    });

                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 4),
                                    width: 40,
                                    height: 40,
                                    decoration: selectedColourIndex==index? BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: mColors[index],
                                        width: 1.5, // Defines the outer ring thickness
                                      ),
                                    ):null,
                                    child: Container(
                                      margin: const EdgeInsets.all(2), // Space between border and center color
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: mColors[index],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              ),
                            ),
                          ),
                          SizedBox(height: 7,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildTabItem("Description", 0),
                              _buildTabItem("Specifications", 1),
                              _buildTabItem("Reviews", 2),
                            ] ,
                          ),
                          activeTabContant[activeTabIndex],
                        ],
                      ),
                    ),
                  ))
            ],
          ),


          Positioned(
              bottom: 0,
              child: Container(
                margin: EdgeInsets.all(21),
                padding: EdgeInsets.only(left: 21, right: 11),
                width: MediaQuery.of(context).size.width-42,
                height: 70,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(50)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.white,
                              width: 2
                          ),
                          borderRadius: BorderRadius.circular(50)
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 16,
                          ),
                          InkWell(
                              onTap: (){
                                setState(() {
                                  if(count>1){
                                    count--;
                                  }
                                });
                              },
                              child: Text("-", style: TextStyle(fontSize: 21, color: Colors.white, fontWeight: FontWeight.bold),)
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          InkWell(
                              child: Text("$count", style: TextStyle(fontSize: 21, color: Colors.white, fontWeight: FontWeight.bold),)
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          InkWell(
                              onTap: (){
                                setState(() {
                                  count++;
                                });
                              },

                              child: Text("+", style: TextStyle(fontSize: 21, color: Colors.white, fontWeight: FontWeight.bold),)
                          ),
                          SizedBox(
                            width: 16,
                          ),
                        ],
                      ),
                    ),
                    BlocConsumer<CartBloc, CartState>(
                      listener: (context, state) {
                        if (state is CartLoadedState) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Product added to cart")),
                          );
                        }

                        if (state is CartErrorState) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.errorMsg)),
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is CartLoadingState) {
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 11),
                            height: 50,
                            width: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.deepOrangeAccent,
                            ),
                            child: Center(
                              child: CircularProgressIndicator(color: Colors.white),
                            ),
                          );
                        }

                        return InkWell(
                          onTap: () {
                            context.read<CartBloc>().add(
                              AddToCartEvent(
                                productId: int.parse(widget.currProduct.id!),
                                qty: count,
                              ),
                            );
                            Navigator.pop(context);
                          },

                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 11),
                            height: 50,
                            width: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.deepOrangeAccent,
                            ),
                            child: Center(
                              child: Text(
                                'Add to Cart',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  ],
                ),
              )
          ),


          Positioned(
              top: 35,
              left: 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(onPressed: (){Navigator.pop(context);}, child: Icon(Icons.arrow_back_ios_new),style: myButtonStyle(bgColor: Colors.white,fgColor: Colors.black,mRadius: 500),),
                  SizedBox(width: 170,),
                  ElevatedButton(onPressed: (){}, child: Icon(Icons.share),style: myButtonStyle(bgColor: Colors.white,fgColor: Colors.black,mRadius: 500)),
                  SizedBox(width: 10,),
                  ElevatedButton(onPressed: (){}, child: Icon(Icons.favorite),style: myButtonStyle(bgColor: Colors.white,fgColor: Colors.black,mRadius: 500)),
                ],
              )
          )


        ],
      ),



    );
  }

  Widget _colorCircle(Color color) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade300, width: 1.5),
      ),
    );
  }
  Widget _buildTabItem(String title, int index) {
    bool isActive = activeTabIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          activeTabIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          // Changes color based on state
          color: isActive ? Colors.orange : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.black54,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
  ButtonStyle myButtonStyle({required Color bgColor, required Color fgColor, double mRadius = 50.0,}) {
    return ElevatedButton.styleFrom(
      backgroundColor: bgColor,
      foregroundColor: fgColor,
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(mRadius),
      ),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}