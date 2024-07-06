import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:touristapp/utilities/bottom_nav.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.asset(
                  'images/display_image1.jpg',
                ),
                Positioned(
                    top: 10,
                    left: 10,
                    right: 10,
                    child: TextField(
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                          hintText: 'What are you looking for?',
                          suffixIcon: IconButton(
                              onPressed: () {}, icon: Icon(Icons.search)),
                          hintStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold)),
                    ))
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Suggested',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
                      IconButton(onPressed: (){}, icon: Icon(Icons.arrow_forward))

                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          decoration:BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(17)
                          ) ,
                          
                          height: 160,
                          width: 190,
                          
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              
                              Image.asset('images/muchison.jpg',),
                              Text('Murchison Falls',style: TextStyle(
                                fontWeight: FontWeight.bold,fontSize: 17
                              ),),Text('Masindi',style: TextStyle(
                                fontWeight: FontWeight.bold,fontSize: 14)
                          )],
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          height: 160,
                          width: 190,
                          decoration:BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(17)
                          ) ,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          height: 160,
                          width: 190,
                          decoration:BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(17)
                          ) ,
                        ),
                      ],
                    ),
                  ),
                   SizedBox(
              height: 10,
            ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Top rated',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
                      IconButton(onPressed: (){}, icon: Icon(Icons.arrow_forward)),
                      

                    ],
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          decoration:BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(17)
                          ) ,
                          
                          height: 200,
                          width: 200,
                          
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              
                              Image.asset('images/muchison.jpg',),
                              Text('Murchison Falls',style: TextStyle(
                                fontWeight: FontWeight.bold,fontSize: 17
                              ),),Text('Masindi',style: TextStyle(
                                fontWeight: FontWeight.bold,fontSize: 14)
                          ),
                          Row(
                            children: [
                              IconButton(onPressed: (){}, icon: Icon(Icons.star),color: Colors.yellow,),IconButton(onPressed: (){}, icon: Icon(Icons.star),color: Colors.yellow,),
                              IconButton(onPressed: (){}, icon: Icon(Icons.star),color: Colors.yellow,),
                              IconButton(onPressed: (){}, icon: Icon(Icons.star),color: Colors.grey,),
                              IconButton(onPressed: (){}, icon: Icon(Icons.star),color: Colors.grey,)
                            ],
                          )
                          ],
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          height: 200,
                          width: 200,
                          decoration:BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(17),
                            
                          ) ,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              
                              Image.asset('images/muchison.jpg',),
                              Text('Lake Mburo',style: TextStyle(
                                fontWeight: FontWeight.bold,fontSize: 17
                              ),),Text('Toro',style: TextStyle(
                                fontWeight: FontWeight.bold,fontSize: 14)
                          ),
                          Row(
                            children: [
                              IconButton(onPressed: (){}, icon: Icon(Icons.star),color: Colors.yellow,),IconButton(onPressed: (){}, icon: Icon(Icons.star),color: Colors.yellow,),
                              IconButton(onPressed: (){}, icon: Icon(Icons.star),color: Colors.yellow,),
                              IconButton(onPressed: (){}, icon: Icon(Icons.star),color: Colors.grey,),
                              IconButton(onPressed: (){}, icon: Icon(Icons.star),color: Colors.grey,)
                            ],
                          )
                          ],
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          height: 200,
                          width: 200,
                          decoration:BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(17)
                          ) ,child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              
                              Image.asset('images/muchison.jpg',),
                              Text('Queen Elizabeth',style: TextStyle(
                                fontWeight: FontWeight.bold,fontSize: 17
                              ),),Text('Masindi',style: TextStyle(
                                fontWeight: FontWeight.bold,fontSize: 14)
                          ),
                          Row(
                            children: [
                              IconButton(onPressed: (){}, icon: Icon(Icons.star),color: Colors.yellow,),IconButton(onPressed: (){}, icon: Icon(Icons.star),color: Colors.yellow,),
                              IconButton(onPressed: (){}, icon: Icon(Icons.star),color: Colors.yellow,),
                              IconButton(onPressed: (){}, icon: Icon(Icons.star),color: Colors.grey,),
                              IconButton(onPressed: (){}, icon: Icon(Icons.star),color: Colors.grey,)
                            ],
                          )
                          ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNav(),
    );
  }
}
