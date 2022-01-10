import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:roboclub_flutter/configs/remoteConfig.dart';
import 'package:roboclub_flutter/forms/membership.dart';
import 'package:roboclub_flutter/helper/dimensions.dart';
import 'package:roboclub_flutter/helper/pdf_manager.dart';
import 'package:roboclub_flutter/models/member.dart';
import 'package:roboclub_flutter/services/email.dart';
import 'package:roboclub_flutter/services/member.dart';
import 'package:roboclub_flutter/widgets/appBar.dart';
import 'package:roboclub_flutter/widgets/drawer.dart';
import 'package:roboclub_flutter/widgets/member_card.dart';
import 'package:string_encryption/string_encryption.dart';

class RegMembersScreen extends StatefulWidget {
  const RegMembersScreen({Key? key}) : super(key: key);

  @override
  _RegMembersScreenState createState() => _RegMembersScreenState();
}

class _RegMembersScreenState extends State<RegMembersScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isLoading = true;
  List<Member> membersList = [];
  late Razorpay _razorpay;
  String key = dotenv.env['Razorpay_key'] ?? "";
  String scrtKey = dotenv.env['Razor_Pay_key_secret'] ?? "";
  final cryptor = StringEncryption();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocNode = FocusNode();

  List<Member> searchResult = [];

  bool showButton = false;
  late Member member;
  late int amount;
  File? pdf;
  @override
  void initState() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    Remoteconfig().showMmebershipOpen().then((value) {
      setState(() {
        showButton = value;
      });
      MemberService().fetchMembers().then((value) {
        addMemberList(value);
        setState(() {
          _isLoading = false;
        });
      });
    });
    initEncryption();
    amount = Remoteconfig().getMembershipAmount();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  Future<void> generateOrderId(Member mem) async {
    member = mem;
    // print(member);
    String recieptId = Random.secure().nextInt(1 << 32).toString();

    print(recieptId);
    final client = HttpClient();
    final request =
        await client.postUrl(Uri.parse('https://api.razorpay.com/v1/orders'));
    request.headers
        .set(HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8");
    // print(key);
    // print(scrtKey);
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$key:$scrtKey'));
    request.headers.set(HttpHeaders.authorizationHeader, basicAuth);
    request.add(utf8.encode(json.encode(
        {"amount": amount * 100, "currency": "INR", "receipt": recieptId})));
    final response = await request.close();
    response.transform(utf8.decoder).listen((contents) {
      String orderId = contents.split(',')[0].split(":")[1];
      // print(contents);
      orderId = orderId.substring(1, orderId.length - 1);
      // print(orderId);
      Map<String, dynamic> checkoutOptions = {
        'key': key,
        'amount': amount * 100,
        "currency": "INR",
        'name': 'AMURoboclub',
        'description': 'Membership amount',
        'order_id': orderId,
        'prefill': {'contact': member.mobileNo, 'email': member.email},
        "method": {
          "netbanking": false,
          "card": false,
          "upi": true,
          "wallet": false,
        }, // Generate order_id using Orders API
        'timeout': 300,
      };
      // log.call(checkoutOptions);
      // debugPrint(checkoutOptions.toString());
      try {
        _razorpay.open(checkoutOptions);
      } catch (e) {
        print(e.toString());
      }
    });
  }

  void initEncryption() async {
    _firestore
        .collection("/keys")
        .doc("razorpayKey")
        .get()
        .then((fcmKeySnap) async {
      String password = fcmKeySnap.get('password');
      String salt = fcmKeySnap.get('salt');
      // print(scrtKey);
      String? encrptyKey =
          await cryptor.generateKeyFromPassword(password, salt);
      // encrpy=cryptor.encrypt("", key)
      scrtKey = await cryptor.decrypt(scrtKey, encrptyKey!) ?? "";
      // print("decrypted $scrtKey");
    });
  }

  Future<void> generatePdf() async {
    var regNo = 'RT';
    regNo += new Random.secure().nextInt(1 << 6).toString();
    // print(regNo);
    pdf = await PdfManager().createRegSlip(member, regNo);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    String sig = response.signature!;
    var bytes = utf8.encode(response.orderId! + "|" + response.paymentId!);

    Hmac hmac = new Hmac(sha256, utf8.encode(scrtKey));
    var digest = hmac.convert(bytes);
    if (digest.toString() == sig) {
      print("Payment Status Updated ");
      Fluttertoast.showToast(msg: "Payment Completed Successfully");
      MemberService().updatePaymentStatus(member).then((value) async {
        await generatePdf();
        EmailService().sendRegistrationEmail(
          recipent: member.email,
          payment: true,
          pdf: pdf,
          username: member.name,
        );
      });
      setState(() {
        member.isPaid = true;
      });
      MemberService().postPaymentDetails({
        "orderId": response.orderId,
        "paymentId": response.paymentId,
        "name": member.name,
        "email": member.email,
        "facultyNo": member.facultyNo,
        "mobileNo": member.mobileNo
      });
    } else {
      Fluttertoast.showToast(msg: "Payment not successful");
    }
    // print("Success" + response.paymentId!);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("Error" + response.code.toString() + " - " + response.message!);
    Fluttertoast.showToast(msg: "Something went wrong");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("Expernal Wallet" + response.walletName!);
  }

  void addMemberList(List<Member> members) {
    members.forEach((item) {
      if (showButton) {
        if (item.isPaid) {
          membersList.insert(0, item);
        } else {
          membersList.add(item);
        }
      } else {
        if (item.isPaid) {
          membersList.add(item);
        }
      }
    });
  }

  onSearchTextChanged(String text) async {
    searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    membersList.forEach((memberDetail) {
      if (memberDetail.name.toLowerCase().contains(text.toLowerCase()))
        searchResult.add(memberDetail);
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var vpH = getViewportHeight(context);
    var vpW = getViewportWidth(context);
    return SafeArea(
        child: Scaffold(
            key: _scaffoldKey,
            drawer: appdrawer(context, page: "Registered Members"),
            appBar: appBar(
              context,
              strTitle: "MEMBERS",
              isDrawer: true,
              isNotification: false,
              scaffoldKey: _scaffoldKey,
            ),
            body: _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: vpH * 0.005,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Card(
                            child: TextFormField(
                              autofocus: false,
                              controller: searchController,
                              focusNode: searchFocNode,
                              onChanged: onSearchTextChanged,
                              decoration: InputDecoration(
                                filled: false,
                                hintText: 'Search by name',
                                border: InputBorder.none,
                                suffixIcon: searchFocNode.hasFocus
                                    ? IconButton(
                                        onPressed: () {
                                          searchController.clear();
                                          onSearchTextChanged('');
                                          searchFocNode.unfocus();
                                        },
                                        icon: Icon(
                                          Icons.cancel,
                                        ),
                                      )
                                    : null,
                                prefixIcon: IconButton(
                                  onPressed: () {
                                    searchFocNode.requestFocus();
                                  },
                                  icon: Icon(
                                    Icons.search,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: vpH * 0.9,
                          width: vpW,
                          child: searchController.text.isNotEmpty
                              ? searchResult.length != 0
                                  ? new ListView.builder(
                                      physics: BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: searchResult.length,
                                      scrollDirection: Axis.vertical,
                                      itemBuilder: (context, index) {
                                        return MemberCard(
                                          member: searchResult[index],
                                          createOrderId: generateOrderId,
                                        );
                                      },
                                    )
                                  : Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.search_off_rounded,
                                            size: 80,
                                          ),
                                          Text(
                                            "No Result Found",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5,
                                          ),
                                        ],
                                      ),
                                    )
                              : ListView.builder(
                                  physics: BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: membersList.length,
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (context, index) {
                                    return MemberCard(
                                      member: membersList[index],
                                      createOrderId: generateOrderId,
                                    );
                                  },
                                ),
                        )
                      ],
                    ),
                  ),
            floatingActionButton: showButton
                ? FloatingActionButton.extended(
                    icon: Icon(Icons.check_circle_rounded),
                    label: Text("Apply now"),
                    onPressed: () async {
                      var result = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return Membership();
                          },
                        ),
                      );
                      if (result != null) {
                        if (result["success"]) {
                          setState(() {
                            _isLoading = true;
                            membersList.clear();
                            MemberService().fetchMembers().then((value) {
                              addMemberList(value);
                              setState(() {
                                _isLoading = false;
                              });
                            });
                          });
                        }
                      }
                    },
                  )
                : null));
  }
}
