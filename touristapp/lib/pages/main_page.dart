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
    return  Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
      Stack(children: [
Image.asset('images/display_image1.jpg',),Positioned(
  top: 10,
  left: 10,
  right: 10,

  child: TextField(decoration: InputDecoration(
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
    
  ),hintText: 'What are you looking for?',
  suffixIcon: IconButton(onPressed: (){}, icon: Icon(Icons.search)),
 
  hintStyle: TextStyle(color: Colors.black)),))
      ],),


],
           
           
          
        ),
      ),
      bottomNavigationBar: BottomNav(),
    );
  }
}
