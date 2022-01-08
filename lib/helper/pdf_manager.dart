import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pwidget;
import 'package:roboclub_flutter/models/member.dart';

class PdfManager {
  Future<Uint8List> createRegSlip(Member member, String regNo) async {
    final logoImage = (await rootBundle.load("assets/img/amuroboclubLogo.png"))
        .buffer
        .asUint8List();
    final priyankaSign = (await rootBundle.load("assets/img/priyanka_sign.png"))
        .buffer
        .asUint8List();
    final rishabSign = (await rootBundle.load("assets/img/rishab_sign.png"))
        .buffer
        .asUint8List();

    final pdf = pwidget.Document();
    pdf.addPage(
      pwidget.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pwidget.Context context) => [
          pwidget.Column(
            children: [
              pwidget.Container(
                padding: pwidget.EdgeInsets.symmetric(horizontal: 20),
                alignment: pwidget.Alignment.center,
                decoration: pwidget.BoxDecoration(
                  border: pwidget.Border.all(
                    color: PdfColors.black,
                    width: 2,
                  ),
                ),
                child: pwidget.Column(
                  children: [
                    pwidget.Image(
                      pwidget.MemoryImage(logoImage),
                      height: 45,
                      width: 350,
                      fit: pwidget.BoxFit.fill,
                    ),
                    pwidget.SizedBox(height: 20),
                    pwidget.Text(
                      "Registration Slip",
                      style: pwidget.TextStyle(
                        decoration: pwidget.TextDecoration.underline,
                        fontSize: 15,
                        fontWeight: pwidget.FontWeight.bold,
                      ),
                    ),
                    pwidget.SizedBox(height: 5),
                    pwidget.Text(
                      "(Session 2021 - 2022)",
                      style: pwidget.TextStyle(
                        fontSize: 13,
                      ),
                    ),
                    pwidget.SizedBox(height: 20),
                    pwidget.Row(
                      mainAxisAlignment: pwidget.MainAxisAlignment.spaceBetween,
                      children: [
                        pwidget.Text(
                          "Name: ",
                          style: pwidget.TextStyle(
                            fontSize: 15,
                            fontWeight: pwidget.FontWeight.bold,
                          ),
                        ),
                        pwidget.Text(
                          member.name,
                          style: pwidget.TextStyle(
                            decoration: pwidget.TextDecoration.underline,
                            fontSize: 15,
                          ),
                        ),
                        pwidget.SizedBox(width: 10),
                        pwidget.Text(
                          "Course: ",
                          style: pwidget.TextStyle(
                            fontSize: 15,
                            fontWeight: pwidget.FontWeight.bold,
                          ),
                        ),
                        pwidget.Text(
                          member.course,
                          style: pwidget.TextStyle(
                            decoration: pwidget.TextDecoration.underline,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    pwidget.SizedBox(height: 10),
                    pwidget.Row(
                      mainAxisAlignment: pwidget.MainAxisAlignment.spaceBetween,
                      children: [
                        pwidget.Text(
                          "Enroll No: ",
                          style: pwidget.TextStyle(
                            fontSize: 15,
                            fontWeight: pwidget.FontWeight.bold,
                          ),
                        ),
                        pwidget.Text(
                          member.enrollNo,
                          style: pwidget.TextStyle(
                            decoration: pwidget.TextDecoration.underline,
                            fontSize: 15,
                          ),
                        ),
                        pwidget.SizedBox(width: 10),
                        pwidget.Text(
                          "Mobile No.: ",
                          style: pwidget.TextStyle(
                            fontSize: 15,
                            fontWeight: pwidget.FontWeight.bold,
                          ),
                        ),
                        pwidget.Text(
                          member.mobileNo,
                          style: pwidget.TextStyle(
                            decoration: pwidget.TextDecoration.underline,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    pwidget.SizedBox(height: 10),
                    pwidget.Row(
                      mainAxisAlignment: pwidget.MainAxisAlignment.spaceBetween,
                      children: [
                        pwidget.Text(
                          "Faculty No.: ",
                          style: pwidget.TextStyle(
                            fontSize: 15,
                            fontWeight: pwidget.FontWeight.bold,
                          ),
                        ),
                        pwidget.Text(
                          member.facultyNo,
                          style: pwidget.TextStyle(
                            decoration: pwidget.TextDecoration.underline,
                            fontSize: 15,
                          ),
                        ),
                        pwidget.SizedBox(width: 10),
                        pwidget.Text(
                          "Registration No.: ",
                          style: pwidget.TextStyle(
                            fontSize: 15,
                            fontWeight: pwidget.FontWeight.bold,
                          ),
                        ),
                        pwidget.Text(
                          regNo,
                          style: pwidget.TextStyle(
                            decoration: pwidget.TextDecoration.underline,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    pwidget.SizedBox(height: 10),
                    pwidget.Row(
                      children: [
                        pwidget.Text(
                          "Email: ",
                          style: pwidget.TextStyle(
                            fontSize: 15,
                            fontWeight: pwidget.FontWeight.bold,
                          ),
                        ),
                        pwidget.Text(
                          member.email,
                          style: pwidget.TextStyle(
                            decoration: pwidget.TextDecoration.underline,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    pwidget.SizedBox(height: 10),
                    pwidget.Column(
                      crossAxisAlignment: pwidget.CrossAxisAlignment.start,
                      children: [
                        pwidget.Text(
                          "Total Fees Paid: Rs. 150",
                          style: pwidget.TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        pwidget.Text(
                          "Registration Validity: Session 2021-22",
                          style: pwidget.TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    pwidget.Row(
                      mainAxisAlignment: pwidget.MainAxisAlignment.spaceBetween,
                      children: [
                        pwidget.Column(
                          children: [
                            pwidget.Image(
                              pwidget.MemoryImage(priyankaSign),
                              height: 45,
                              width: 90,
                              fit: pwidget.BoxFit.fill,
                            ),
                            pwidget.Container(
                              decoration: pwidget.BoxDecoration(
                                border: pwidget.Border(
                                  bottom: pwidget.BorderSide(
                                      color: PdfColors.black, width: 2),
                                ),
                              ),
                              height: 10,
                              width: 100,
                            ),
                            pwidget.SizedBox(height: 10),
                            pwidget.Text(
                              "Priyanka Gupta",
                              style: pwidget.TextStyle(
                                fontSize: 15,
                                fontWeight: pwidget.FontWeight.bold,
                              ),
                            ),
                            pwidget.Text(
                              "Co-ordinator, AMURoboclub",
                              style: pwidget.TextStyle(
                                fontSize: 12,
                                fontWeight: pwidget.FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        pwidget.SizedBox(width: 10),
                        pwidget.Column(
                          children: [
                            pwidget.Image(
                              pwidget.MemoryImage(rishabSign),
                              height: 55,
                              width: 90,
                              fit: pwidget.BoxFit.fill,
                            ),
                            pwidget.Container(
                              decoration: pwidget.BoxDecoration(
                                border: pwidget.Border(
                                  bottom: pwidget.BorderSide(
                                      color: PdfColors.black, width: 2),
                                ),
                              ),
                              height: 10,
                              width: 100,
                            ),
                            pwidget.SizedBox(height: 10),
                            pwidget.Text(
                              "Rishab Sharma",
                              style: pwidget.TextStyle(
                                fontSize: 15,
                                fontWeight: pwidget.FontWeight.bold,
                              ),
                            ),
                            pwidget.Text(
                              "Co-ordinator, AMURoboclub",
                              style: pwidget.TextStyle(
                                fontSize: 12,
                                fontWeight: pwidget.FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              pwidget.Container(
                alignment: pwidget.Alignment.center,
                padding: pwidget.EdgeInsets.all(10),
                decoration: pwidget.BoxDecoration(
                  color: PdfColors.blue,
                  border: pwidget.Border.all(
                    color: PdfColors.black,
                    width: 2,
                  ),
                ),
                child: pwidget.Text(
                  "For queries contact: amuroboclub@gmail.com",
                  style: pwidget.TextStyle(
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
    Uint8List fileBytes = await pdf.save();
    return fileBytes;
  }
}
