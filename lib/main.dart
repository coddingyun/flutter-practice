import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

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
      routes: {
        '/main': (context) => MainScreen(),
        '/write': (context) => WriteScreen(),
      },
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
                    PopupMenuItem<String>(child: Text("삭제하기"), onTap: () {}),
                  ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          Navigator.of(context).pushNamed('/write');
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class WriteScreen extends StatefulWidget {
  const WriteScreen({super.key});

  @override
  State<WriteScreen> createState() => _WriteScreenState();
}

class _WriteScreenState extends State<WriteScreen> {
  late ValueNotifier<dynamic> selectImgTopLeft;
  late ValueNotifier<dynamic> selectImgTopRight;
  late ValueNotifier<dynamic> selectImgBottomLeft;
  late ValueNotifier<dynamic> selectImgBottomRight;

  TextEditingController inputTitleController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    selectImgBottomRight = ValueNotifier(null);
    selectImgBottomLeft = ValueNotifier(null);
    selectImgTopLeft = ValueNotifier(null);
    selectImgTopRight = ValueNotifier(null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "네컷일기 작성하기",
          style: GoogleFonts.blackHanSans(
            textStyle: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        leading: GestureDetector(
          child: Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 이미지 선택 위젯
            Container(
              margin: EdgeInsets.all(8),
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
                    SelectedImg(selectImg: selectImgTopLeft),
                    SelectedImg(selectImg: selectImgTopRight),
                    SelectedImg(selectImg: selectImgBottomLeft),
                    SelectedImg(selectImg: selectImgBottomRight),
                  ],
                ),
              ),
            ),
            // 텍스트 작성 필드
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "한 줄 일기",
                style: GoogleFonts.blackHanSans(
                  textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Form(
                key: formKey,
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "한 줄 일기를 작성해주세요 (최대 8글자)",
                    hintStyle: GoogleFonts.blackHanSans(fontSize: 16),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xffE1E1E1)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  maxLength: 8,
                  controller: inputTitleController,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "날짜",
                style: GoogleFonts.blackHanSans(
                  textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            GestureDetector(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xffe1e1e1)),
                ),
                child: Text(
                  "날짜를 선택해주세요",
                  style: GoogleFonts.blackHanSans(
                    textStyle: TextStyle(
                      fontSize: 16,
                      color: Color(0xffacacac),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SelectedImg extends StatefulWidget {
  final ValueNotifier<dynamic>? selectImg;
  const SelectedImg({super.key, this.selectImg});

  @override
  State<SelectedImg> createState() => _SelectedImgState();
}

class _SelectedImgState extends State<SelectedImg> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Color(0xffF4F4F4),
        ),
        child:
            widget.selectImg?.value == null
                ? const Icon(Icons.image, color: Color(0xff868686))
                : Container(
                  height: MediaQuery.of(context).size.width,
                  child: Image.file(widget.selectImg!.value, fit: BoxFit.cover),
                ),
      ),
      onTap: () => getGalleryImage(),
    );
  }

  void getGalleryImage() async {
    // Todo: 갤러리에서 이미지 가지고오는 함수

    var image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 10,
    );

    if (image != null) {
      // 이미지가 선택 된 경우
      widget.selectImg?.value = File(image.path);
      setState(() {});
      return;
    }
  }
}
