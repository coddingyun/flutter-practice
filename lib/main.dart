import 'dart:io';
import 'dart:math' as math;
import 'dart:nativewrappers/_internal/vm/lib/typed_data_patch.dart';

import 'package:flutter/material.dart';
import 'package:four_diary/database_helper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

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

  int selectedDate = 0; // 선택된 날짜

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
                  validator: (val) => titleValidator(val),
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
              onTap: () => _selectedDate(context),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                alignment: Alignment.centerLeft,
                width: double.maxFinite,
                height: 56,
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xffe1e1e1)),
                ),
                child: Container(
                  margin: EdgeInsets.only(left: 8),
                  child:
                      selectedDate == 0
                          ? Text(
                            "날짜를 선택해주세요",
                            style: GoogleFonts.blackHanSans(
                              textStyle: TextStyle(
                                fontSize: 16,
                                color: Color(0xffacacac),
                              ),
                            ),
                          )
                          : Text(
                            DateFormat('yyyy.MM.dd').format(
                              DateTime.fromMillisecondsSinceEpoch(selectedDate),
                            ),
                            style: GoogleFonts.blackHanSans(
                              textStyle: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
              width: double.maxFinite,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                child: Container(
                  margin: EdgeInsets.all(16),
                  child: Text(
                    "저장하기",
                    style: GoogleFonts.blackHanSans(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
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

  Future _selectedDate(BuildContext context) async {
    // 날짜를 선택하는 함수
    final DateTime? selected = await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );
    if (selected != null) {
      selectedDate = selected.millisecondsSinceEpoch;
      setState(() {});
    }
  }

  dynamic titleValidator(val) {
    // 제목 유효성 검사
    if (val.isEmpty) {
      return "제목을 입력해주세요";
    }
    return null;
  }

  void validateInput() {
    // 유효성 검사 함수
    if (formKey.currentState!.validate() &&
        isImgFieldValidate() &&
        isDateValidate()) {
      // 모두 입력이 되었으면
      saveData();
    }
  }

  void saveData() async {
    // 일기 저장
    DiaryModel diaryModel = DiaryModel(
      title: inputTitleController.text,
      imageTopLeft: await selectImgTopLeft.value!.readAsBytes(),
      imageTopRight: await selectImgTopRight.value!.readAsBytes(),
      imageBottomLeft: await selectImgBottomLeft.value!.readAsBytes(),
      imageBottomRight: await selectImgBottomRight.value!.readAsBytes(),
      date: selectedDate,
    );

    await DatabaseHelper().initDatabase();
    await DatabaseHelper().insertInfo(diaryModel);

    final snackBar = SnackBar(content: Text("일기가 저장되었습니다."));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  bool isImgFieldValidate() {
    // 이미지 4개가 선택되었는지 확인

    bool isImgSelected =
        selectImgTopRight.value != null &&
        selectImgTopLeft.value != null &&
        selectImgBottomLeft != null &&
        selectImgBottomRight != null;

    if (isImgSelected) {
      return true;
    }
    final snackBar = SnackBar(content: Text("이미지를 선택해주세요"));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    return false;
  }

  bool isDateValidate() {
    // 날짜가 선택되었는지 확인

    bool isDateValidate = selectedDate != 0; // 초기화 숫자가 0이었음
    if (isDateValidate) {
      return true;
    }
    final snackBar = SnackBar(content: Text("날짜를 선택해주세요"));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    return false;
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

class DiaryModel {
  int? id;
  String title;
  Uint8List imageTopLeft;
  Uint8List imageTopRight;
  Uint8List imageBottomLeft;
  Uint8List imageBottomRight;
  int date;

  DiaryModel({
    this.id,
    required this.title,
    required this.imageTopLeft,
    required this.imageTopRight,
    required this.imageBottomLeft,
    required this.imageBottomRight,
    required this.date,
  });

  // freezed package로 자동 생성 가능
  factory DiaryModel.formMap(Map<dynamic, dynamic> map) {
    return DiaryModel(
      title: map['id'],
      imageTopLeft: map['imageTopLeft'],
      imageTopRight: map['imageTopRight'],
      imageBottomLeft: map['imageBottomLeft'],
      imageBottomRight: map['imageBottomRight'],
      date: map['date'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'imageTopLeft': imageTopLeft,
      'imageTopRight': imageTopRight,
      'imageBottomLeft': imageBottomLeft,
      'imageBottomRight': imageBottomRight,
      'date': date,
    };
  }
}
