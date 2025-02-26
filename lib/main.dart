import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '네컷일기',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: false),
      home: MainScreen(),
    );
  }
}

// stful 입력
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "네컷일기",
          style: GoogleFonts.blackHanSans(
            textStyle: TextStyle(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0, // 그림자 없애기
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            color: Color(0xffC7E9AC),
            child: Container(
              width: double.maxFinite,
              height: MediaQuery.of(context).size.width, // width와 같게
              child: GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Container(color: Colors.black),
                  Container(color: Colors.white),
                  Container(color: Colors.green),
                  Container(color: Colors.yellow),
                ],
              ),
            ),
          ),
          // 제목 바탕
          Transform.rotate(
            angle: 60 * math.pi / 100,
            child: Container(
              width: MediaQuery.of(context).size.width / 4,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.all(Radius.elliptical(70, 85)),
              ),
            ),
          ),
          // 제목
          Text(
            "제목입니다",
            style: GoogleFonts.blackHanSans(
              textStyle: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          // 날짜
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Container(
                margin: EdgeInsets.all(8),
                child: Text(
                  "2025.02.26",
                  style: GoogleFonts.blackHanSans(
                    textStyle: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // 수정하기, 삭제하기
          Positioned(
            top: 8,
            right: 0,
            child: PopupMenuButton<String>(
              child: Container(
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
                child: Icon(Icons.more_vert, size: 24, color: Colors.white),
              ),
              itemBuilder:
                  (BuildContext context) => <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(child: Text("수정하기"), onTap: () {}),
                    PopupMenuItem<String>(child: Text("수정하기"), onTap: () {}),
                  ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {},
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
