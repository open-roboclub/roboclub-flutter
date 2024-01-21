import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:roboclub_flutter/models/member.dart';

class PdfManager {
  Widget getText(
    String text, {
    double fontSize = 15,
    FontWeight fontWeight = FontWeight.normal,
    TextDecoration decoration = TextDecoration.none,
  }) {
    return Text(
      text,
      style: TextStyle(
        decoration: decoration,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }

  Widget getFieldVal(String fieldVal) {
    return Expanded(
      child: Column(
        children: [
          getText(fieldVal),
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: PdfColors.black,
                  width: 1,
                ),
              ),
            ),
            height: 5,
          ),
        ],
      ),
    );
  }

  Widget getFieldRow(
    String fieldName1,
    String fieldVal1,
    String fieldName2,
    String fieldVal2,
  ) {
    return Row(
      children: [
        getText(
          fieldName1,
          fontWeight: FontWeight.bold,
        ),
        getFieldVal(fieldVal1),
        SizedBox(width: 10),
        getText(
          fieldName2,
          fontWeight: FontWeight.bold,
        ),
        getFieldVal(fieldVal2),
      ],
    );
  }

  Widget getSignView(Uint8List image, String name) {
    return Column(
      children: [
        Image(
          MemoryImage(image),
          height: 45,
          width: 90,
          fit: BoxFit.fill,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: PdfColors.black,
                width: 2,
              ),
            ),
          ),
          height: 10,
          width: 100,
        ),
        SizedBox(height: 10),
        getText(
          name,
          fontWeight: FontWeight.bold,
        ),
        getText(
          "Co-ordinator, AMURoboclub",
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ],
    );
  }

  Future<File> createRegSlip(Member member, String regNo) async {
    final logoImage = (await rootBundle.load("assets/img/amuroboclubLogo.png"))
        .buffer
        .asUint8List();
    final maazSign = (await rootBundle.load("assets/img/priyanka_sign.png"))
        .buffer
        .asUint8List();
    final zaidSign = (await rootBundle.load("assets/img/rishab_sign.png"))
        .buffer
        .asUint8List();

    final pdf = Document();
    pdf.addPage(
      MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (Context context) => [
          Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: PdfColors.black,
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    Image(
                      MemoryImage(logoImage),
                      height: 45,
                      width: 350,
                      fit: BoxFit.fill,
                    ),
                    SizedBox(height: 20),
                    getText(
                      "Registration Slip",
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(height: 5),
                    getText(
                      "(Session 2022 - 2023)",
                      fontSize: 13,
                    ),
                    SizedBox(height: 20),
                    getFieldRow(
                      "Name: ",
                      member.name,
                      "Course: ",
                      member.course,
                    ),
                    SizedBox(height: 10),
                    getFieldRow(
                      "Enroll No.: ",
                      member.enrollNo,
                      "Mobile No.: ",
                      member.mobileNo,
                    ),
                    SizedBox(height: 10),
                    getFieldRow(
                      "Faculty No.: ",
                      member.facultyNo,
                      "Registration No.: ",
                      regNo,
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        getText(
                          "Email: ",
                          fontWeight: FontWeight.bold,
                        ),
                        getFieldVal(member.email),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            getText("Total Fees Paid: Rs. 200"),
                            getText("Registration Validity: Session 2022-23"),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        getSignView(maazSign, "Maaz Bin Asad"),
                        SizedBox(width: 10),
                        getSignView(zaidSign, "Zaid Akhtar"),
                      ],
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: PdfColors.blue,
                  border: Border.all(
                    color: PdfColors.black,
                    width: 2,
                  ),
                ),
                child: Text(
                  "For queries contact: amuroboclub@gmail.com",
                  style: TextStyle(
                    color: PdfColors.white,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
    var path = (await getApplicationDocumentsDirectory()).path;
    final fileName = '$path/temp.pdf';
    final File file = File(fileName);
    await file.writeAsBytes(await pdf.save(), flush: true);
    return file;
  }
}
