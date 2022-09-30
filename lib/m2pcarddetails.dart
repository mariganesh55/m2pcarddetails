library m2pcarddetails;

import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth/local_auth.dart';
import 'package:m2pcarddetails/home_screen/bloc/home_bloc.dart';
import 'package:m2pcarddetails/home_screen/bloc/home_event.dart';
import 'package:m2pcarddetails/utils/apputils.dart';
import 'package:m2pcarddetails/utils/color_resource.dart';
import 'package:m2pcarddetails/utils/constants.dart';
import 'package:m2pcarddetails/utils/image_resource.dart';
import 'package:m2pcarddetails/utils/time_utils.dart';
import 'package:m2pcarddetails/widget/custom_dialog.dart';
import 'package:m2pcarddetails/widget/custom_switch.dart';
import 'package:m2pcarddetails/widget/custom_text.dart';
import 'package:m2pcarddetails/widget/enter_verificationcode_dialog.dart';
import 'package:m2pcarddetails/widget/plain_textfield.dart';
import 'package:m2pcarddetails/widget/primary_button.dart';
import 'package:m2pcarddetails/widget/transaction_limit_widget.dart';

import 'home_screen/bloc/home_state.dart';

class CardDetailScreen extends StatefulWidget {
  String tenatname;
  String accessToken;
  String kitNumber;
  String entityId;
  String dob;

  CardDetailScreen(this.tenatname, this.accessToken, this.kitNumber,
      this.entityId, this.dob);

  @override
  _CardDetailScreenState createState() => _CardDetailScreenState();
}

class _CardDetailScreenState extends State<CardDetailScreen>
    with SingleTickerProviderStateMixin {
  bool isSecurityCodeHidden = true;

  String cardNumber = "6666989045907890";
  String expiryDate = "08/22";
  String securityCode = "456";

  late String cardholderName;

  late Image cardBackGroundImage;
  late Image cardTypeImage;
  late TabController _tabController;

  late Timer _timer;
  int pendingSeconds = 180;

  bool setpinVisibility = false;
  bool blockCardVisibility = false;
  bool cardPreferenceVisibility = false;

  late HomeBloc bloc;

  final localAuth = LocalAuthentication();

  static const platform = const MethodChannel('samples.flutter.dev/battery');

  Future<void> getPublicAndPrivateKeys() async {
    try {
      bloc.publicKeyString = await platform.invokeMethod('getPublicString');
      bloc.privateKeyString = await platform.invokeMethod('getPrivateString');
      bloc.deviceId = await platform.invokeMethod('getDeviceId');

      //save keys in local

      Constants.publicKey = bloc.publicKeyString;
      Constants.privateKey = bloc.privateKeyString;
      Constants.deviceId = bloc.deviceId;

      setState(() {});
    } on PlatformException catch (e) {
      print("Failed to get battery level: '${e.message}'.");
    }
  }

  @override
  void initState() {
    bloc = HomeBloc()..add(HomeInitialEvent());
    if (isSecurityCodeHidden) {
      bloc.securityCodeTextController.text = "***";
    } else {
      bloc.securityCodeTextController.text = securityCode;
    }

    _tabController = new TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
    startTimer();

    getPublicAndPrivateKeys();

    super.initState();
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (pendingSeconds == 0) {
          setState(() {
            timer.cancel();
          });
          Navigator.pop(context);
        } else {
          setState(() {
            pendingSeconds--;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: bloc,
      listener: (BuildContext context, HomeState state) async {
        if (state is HomeSecretKeyState) {
          try {
            if (Platform.isIOS)
              bloc.secretKeyString = await platform.invokeMethod(
                  'getSecretString', bloc.serverPublicKey);
            String decrypted = await platform.invokeMethod('getCardDetail', {
              "detailMessage": bloc.cardDetailMessage,
              "serverPublicKey": bloc.serverPublicKey
            });

            print(decrypted);
          } on PlatformException catch (e) {
            print("Failed to get battery level: '${e.message}'.");
          }
        }
        if (state is HomeConformOtpAlertState) {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return EnterVerificationCodeDialogBox((text) {
                  bloc.add(HomeCustomDialogEvent());
                });
              });
        }

        if (state is HomeTemperaryBlockOtpVerificationState) {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return EnterVerificationCodeDialogBox((text) {
                  bloc.add(HomeTemperaryBlockCustomDialogEvent());
                });
              });
        }

        if (state is HomePeramanantBlockOtpVerificationState) {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return EnterVerificationCodeDialogBox((text) {
                  bloc.add(HomePermanantBlockCustomDialogEvent());
                });
              });
        }

        if (state is HomeTemperaryUnBlockOtpVerificationState) {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return EnterVerificationCodeDialogBox((text) {
                  bloc.add(HomeTemperaryUnBlockCustomDialogEvent());
                });
              });
        }

        if (state is HomePeramanantUnBlockOtpVerificationState) {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return EnterVerificationCodeDialogBox((text) {
                  bloc.add(HomePermanantUnBlockCustomDialogEvent());
                });
              });
        }

        if (state is HomeCustomDialogState) {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return CustomDialog(
                    Container(
                      width: 56,
                      height: 56,
                      child: Image(
                        image: ImageResource.tickImage,
                        fit: BoxFit.cover,
                      ),
                    ),
                    "Your PIN has been updated Successfully",
                    "Continue", () {
                  Navigator.pop(context);
                });
              });
        }

        if (state is HomeTemperaryBlockCustomDialogState) {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return CustomDialog(
                    Container(
                      width: 56,
                      height: 56,
                      child: Image(
                        image: ImageResource.tickImage,
                        fit: BoxFit.cover,
                      ),
                    ),
                    "Your card has been Blocked Temporarily ",
                    "Continue", () {
                  setState(() {
                    bloc.blockTemporary = true;
                  });

                  Navigator.pop(context);
                });
              });
        }

        if (state is HomePermanantBlockCustomDialogState) {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return CustomDialog(
                    Container(
                      width: 56,
                      height: 56,
                      child: Image(
                        image: ImageResource.tickImage,
                        fit: BoxFit.cover,
                      ),
                    ),
                    "Your card has been Permanently Blocked ",
                    "Continue", () {
                  setState(() {
                    bloc.blockPermanant = true;
                    bloc.blockTemporary = false;
                  });
                  Navigator.pop(context);
                });
              });
        }

        if (state is HomeTemperaryUnBlockCustomDialogState) {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return CustomDialog(
                    Container(
                      width: 56,
                      height: 56,
                      child: Image(
                        image: ImageResource.tickImage,
                        fit: BoxFit.cover,
                      ),
                    ),
                    "Your card has been Unblocked",
                    "Continue", () {
                  setState(() {
                    bloc.blockTemporary = false;
                  });
                  Navigator.pop(context);
                });
              });
        }

        if (state is HomePermanantUnBlockCustomDialogState) {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return CustomDialog(
                    Container(
                      width: 56,
                      height: 56,
                      child: Image(
                        image: ImageResource.tickImage,
                        fit: BoxFit.cover,
                      ),
                    ),
                    "Your card has been Unblocked",
                    "Continue", () {
                  setState(() {
                    bloc.blockPermanant = false;
                  });
                  Navigator.pop(context);
                });
              });
        }

        if (state is HomeCardLockCustomDialogState) {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return CustomDialog(
                    Container(
                      width: 81,
                      height: 81,
                      child: Image(
                        image: ImageResource.lock,
                        fit: BoxFit.cover,
                      ),
                    ),
                    "${state.cardPreference} has been locked",
                    "Continue", () {
                  lockCardPreferenceValue(state.cardPreference);
                  Navigator.pop(context);
                });
              });
        }

        if (state is HomeCardUnLockCustomDialogState) {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return CustomDialog(
                    Container(
                      width: 81,
                      height: 81,
                      child: Image(
                        image: ImageResource.unlock,
                        fit: BoxFit.cover,
                      ),
                    ),
                    "${state.cardPreference} has been Unlocked",
                    "Continue", () {
                  unlockCardPreferenceValue(state.cardPreference);
                  Navigator.pop(context);
                });
              });
        }

        if (state is HomePeramanantBlockAlertState) {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return CustomDialog(
                  Container(
                    width: 75,
                    height: 75,
                    child: Image(
                      image: ImageResource.blockCardConformation,
                      fit: BoxFit.cover,
                    ),
                  ),
                  "You cannot undo this action. Do you want to continue?",
                  "Yes, Block Card",
                  () {
                    Navigator.pop(context);
                    bloc.add(HomePermanantBlockOtpVerificationEvent());
                  },
                  isCancelButtonRequired: true,
                );
              });
        }

        if (state is HomeTemperaryBlockAlertState) {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return CustomDialog(
                  Container(
                    width: 75,
                    height: 75,
                    child: Image(
                      image: ImageResource.blockCardConformation,
                      fit: BoxFit.cover,
                    ),
                  ),
                  "You cannot undo this action. Do you want to continue?",
                  "Block Temporarily",
                  () {
                    Navigator.pop(context);
                    bloc.add(HomeTemperaryBlockCustomDialogEvent());
                    // bloc.add(HomeTemperaryBlockOtpVerificationEvent());
                  },
                  isCancelButtonRequired: true,
                );
              });
        }

        if (state is HomeErrorState) {
          AppUtils.showErrorToast(state.error);
        }
      },
      child: BlocBuilder(
          bloc: bloc,
          builder: (BuildContext context, HomeState state) {
            return Scaffold(
              backgroundColor: Color.fromRGBO(250, 250, 250, 1),
              body: (state is HomeInitialState)
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : SafeArea(
                      child: Container(
                        color: Colors.transparent,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 22.0,
                                    ),
                                    child: CustomText(
                                      "Virtual Card",
                                      fontSize: 16,
                                      color: ColorResource.color1515151,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 20),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 19.5,
                                            height: 19.5,
                                            child: Image(
                                                image:
                                                    ImageResource.cancelImage,
                                                fit: BoxFit.cover),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          CustomText(
                                            "Close",
                                            fontSize: 13,
                                            color: ColorResource.color1515151
                                                .withOpacity(0.5),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(20.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: Container(
                                  width: double.infinity,
                                  child: Stack(
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        height: 200,
                                        child: Image(
                                          image: ImageResource.cardBgImage,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        height: 200,
                                        child: Image(
                                          image: ImageResource.wavesImage,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 30.0, left: 16, right: 16),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                CustomText(
                                                  widget.tenatname,
                                                  fontSize: 15,
                                                  color: Colors.white,
                                                ),
                                                Spacer(),
                                                Container(
                                                  width: 44,
                                                  height: 28,
                                                  child: Image(
                                                      image: ImageResource
                                                          .tenetBgImage),
                                                )
                                              ],
                                            ),
                                            Container(
                                              height: 32,
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 30.0),
                                              child: Row(
                                                children: [
                                                  CustomText(
                                                    getCardNumber(
                                                        isSecurityCodeHidden),
                                                    fontSize: 16,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600,
                                                    letterSpacing: 2,
                                                  ),
                                                  Spacer(),
                                                  if (isSecurityCodeHidden)
                                                    GestureDetector(
                                                      onTap: () {
                                                        Clipboard.setData(
                                                            ClipboardData(
                                                                text:
                                                                    cardNumber));
                                                        AppUtils.hideKeyBoard(
                                                            context);
                                                        AppUtils.showToast(
                                                            "Cardnumber copied");
                                                      },
                                                      child: Container(
                                                        width: 32,
                                                        height: 32,
                                                        child: Image(
                                                          image: ImageResource
                                                              .copy,
                                                          color: Colors.white,
                                                          // fit: BoxFit.contain,
                                                        ),
                                                      ),
                                                    )
                                                ],
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    CustomText(
                                                      "Valid Thru ",
                                                      color: Colors.white,
                                                      fontSize: 9,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 6.0),
                                                      child: CustomText(
                                                        expiryDate,
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 50.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      CustomText(
                                                        "CVV",
                                                        color: Colors.white,
                                                        fontSize: 9,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 6.0),
                                                        child: CustomText(
                                                          bloc.securityCodeTextController
                                                              .text,
                                                          color: Colors.white,
                                                          fontSize: 12,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Spacer(),
                                                InkWell(
                                                  onTap: () async {
                                                    // isSecurityCodeHidden =
                                                    //     !isSecurityCodeHidden;
                                                    // List<BiometricType>
                                                    //     availableBiometrics =
                                                    //     await localAuth
                                                    //         .getAvailableBiometrics();

                                                    // bool canCheck = await localAuth
                                                    //     .canCheckBiometrics;
                                                    if (isSecurityCodeHidden) {
                                                      try {
                                                        bool didAuthenticate =
                                                            await localAuth.authenticate(
                                                                localizedReason:
                                                                    'Please authenticate to view CVV',
                                                                biometricOnly:
                                                                    true,
                                                                useErrorDialogs:
                                                                    true,
                                                                stickyAuth:
                                                                    false);
                                                        if (didAuthenticate) {
                                                          bloc.securityCodeTextController
                                                                  .text =
                                                              securityCode;
                                                          isSecurityCodeHidden =
                                                              false;
                                                        } else {
                                                          AppUtils.showErrorToast(
                                                              "Not authenticated");
                                                        }
                                                      } on PlatformException catch (e) {
                                                        if (e.code ==
                                                            auth_error
                                                                .notAvailable) {
                                                          // Handle this exception here.
                                                        }
                                                      }
                                                    } else {
                                                      bloc.securityCodeTextController
                                                          .text = "***";
                                                      isSecurityCodeHidden =
                                                          true;
                                                    }
                                                    setState(() {});
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors.grey),
                                                        color:
                                                            Colors.transparent,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20)),
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    child: CustomText(
                                                      isSecurityCodeHidden
                                                          ? "View CVV"
                                                          : "Hide CVV",
                                                      fontSize: 10,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: _buildTabBar(),
                            )),
                            Container(
                              width: double.infinity,
                              height: 28,
                              color: Colors.white,
                              child: Center(
                                child: CustomText(
                                  "The Screen will automatically close in $pendingSeconds sec",
                                  fontSize: 9,
                                  fontWeight: FontWeight.w400,
                                  color: ColorResource.colorEB001C,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            );
          }),
    );
  }

  String getCardNumber(bool isSecurityCodeHidden) {
    var buffer = new StringBuffer();
    for (int i = 0; i < cardNumber.length; i++) {
      if (isSecurityCodeHidden) {
        buffer.write(cardNumber[i]);
      } else {
        if (i == 0 ||
            i == 1 ||
            i == 2 ||
            i == 3 ||
            i == cardNumber.length - 1 ||
            i == cardNumber.length - 2 ||
            i == cardNumber.length - 3 ||
            i == cardNumber.length - 4) {
          buffer.write(cardNumber[i]);
        } else {
          buffer.write("X");
        }
      }

      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != cardNumber.length) {
        buffer.write('  '); // Add double spaces.
      }
    }
    return buffer.toString();
  }

  Widget _buildTabBar() {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          // the tab bar with two items

          TabBar(
            indicatorColor: ColorResource.color4D7DFF,
            indicatorWeight: 3,
            controller: _tabController,
            tabs: [
              Tab(
                child: CustomText(
                  "Manage Card",
                  fontSize: 14,
                  color: _tabController.index == 0
                      ? ColorResource.color4D7DFF
                      : ColorResource.color1515151.withOpacity(0.5),
                ),
                // icon: Icon(Icons.directions_bike),
              ),
              Tab(
                child: CustomText(
                  "Transaction Limit",
                  fontSize: 14,
                  color: _tabController.index == 1
                      ? ColorResource.color4D7DFF
                      : ColorResource.color1515151.withOpacity(0.5),
                ),
                // icon: Icon(Icons.directions_bike),
              ),
            ],
          ),

          // create widgets for each tab bar here
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // first tab bar view widget
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 9.0, vertical: 18),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 15),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    child: Image(
                                        image: ImageResource.setpinImage,
                                        fit: BoxFit.cover),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 12.0),
                                    child: CustomText(
                                      "Set PIN",
                                      fontSize: 14,
                                      color: ColorResource.color1515151
                                          .withOpacity(0.8),
                                    ),
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        setpinVisibility = !setpinVisibility;
                                      });
                                    },
                                    child: Container(
                                      width: 24,
                                      height: 24,
                                      child: Image(
                                          image: setpinVisibility
                                              ? ImageResource.upArrowImage
                                              : ImageResource.downArrowImage,
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                ],
                              ),
                              AnimatedSize(
                                vsync: this,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeIn,
                                child: Container(
                                  color: Colors.white,
                                  // height: setpinVisibility ? 270 : 0,
                                  child: Visibility(
                                    visible: setpinVisibility,
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Column(
                                        children: [
                                          PlainTextField(
                                            "DOB",
                                            bloc.dobTextController,
                                            isReadOnly: true,
                                            onTapped: () {
                                              showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(1900),
                                                lastDate: DateTime.now(),
                                              ).then((value) {
                                                setState(() {
                                                  bloc.dobTextController.text =
                                                      TimeUtils
                                                          .convertdateTimeToDDMMMYYYY(
                                                              value!);
                                                });
                                              });
                                            },
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 16.0),
                                            child: PlainTextField(
                                              "Enter PIN",
                                              bloc.enterPinTextController,
                                              obscureText: true,
                                              maximumWordCount: 4,
                                              keyBoardType: TextInputType
                                                  .numberWithOptions(
                                                      signed: true),
                                            ),
                                          ),
                                          PlainTextField(
                                            "Confirm PIN",
                                            bloc.conformPinTextController,
                                            obscureText: true,
                                            maximumWordCount: 4,
                                            keyBoardType:
                                                TextInputType.numberWithOptions(
                                                    signed: true),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 16.0),
                                            child: PrimaryButton(
                                              "Set",
                                              isShadowrequired: false,
                                              onClick: () {
                                                bloc.add(
                                                    HomeEnterVerificationCodeAlertEvent());
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 16),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 15),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    child: Image(
                                        image: ImageResource.blockCardImage,
                                        fit: BoxFit.cover),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 12.0),
                                    child: CustomText(
                                      "Block your Card",
                                      fontSize: 14,
                                      color: ColorResource.color1515151
                                          .withOpacity(0.8),
                                    ),
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        blockCardVisibility =
                                            !blockCardVisibility;
                                      });
                                    },
                                    child: Container(
                                      width: 24,
                                      height: 24,
                                      child: Image(
                                          image: blockCardVisibility
                                              ? ImageResource.upArrowImage
                                              : ImageResource.downArrowImage,
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                ],
                              ),
                              AnimatedSize(
                                vsync: this,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeIn,
                                child: Visibility(
                                  visible: blockCardVisibility,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20.0),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 12,
                                        ),
                                        CustomSwitch(
                                            "Block Temporarily",
                                            "Prevents transaction on this Card",
                                            bloc.blockTemporary,
                                            bloc.blockPermanant
                                                ? (value) {}
                                                : (value) {
                                                    if (value) {
                                                      bloc.add(
                                                          HomeTemperaryBlockAlertEvent());
                                                    } else {
                                                      bloc.add(
                                                          HomeTemperaryUnBlockCustomDialogEvent());
                                                      // bloc.add(
                                                      //     HomeTemperaryUnBlockOtpVerificationEvent());
                                                    }
                                                  }),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        CustomSwitch(
                                            "Block Permanent",
                                            "Once blocked, card can’t be used again",
                                            bloc.blockPermanant, (value) {
                                          if (value) {
                                            bloc.add(
                                                HomePremanantBlockAlertEvent());
                                          } else {
                                            bloc.add(
                                                HomePermanantUnBlockOtpVerificationEvent());
                                          }
                                        })
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 15),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    child: Image(
                                        image:
                                            ImageResource.cardPreferenceImage,
                                        fit: BoxFit.cover),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 12.0),
                                    child: CustomText(
                                      "Card Preference",
                                      fontSize: 14,
                                      color: ColorResource.color1515151
                                          .withOpacity(0.8),
                                    ),
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        cardPreferenceVisibility =
                                            !cardPreferenceVisibility;
                                      });
                                    },
                                    child: Container(
                                      width: 24,
                                      height: 24,
                                      child: Container(
                                        width: 24,
                                        height: 24,
                                        child: Image(
                                            image: cardPreferenceVisibility
                                                ? ImageResource.upArrowImage
                                                : ImageResource.downArrowImage,
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              AnimatedSize(
                                vsync: this,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeIn,
                                child: Visibility(
                                  visible: cardPreferenceVisibility,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20.0),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 12,
                                        ),
                                        CustomSwitch("ATM Transactions", null,
                                            bloc.atmTransactions, (value) {
                                          if (value) {
                                            bloc.add(
                                                HomeCardLockCustomDialogEvent(
                                                    "ATM Transactions"));
                                          } else {
                                            bloc.add(
                                                HomeCardUnLockCustomDialogEvent(
                                                    "ATM Transactions"));
                                          }
                                        }),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        CustomSwitch("POS Transactions", null,
                                            bloc.posTransactions, (value) {
                                          if (value) {
                                            bloc.add(
                                                HomeCardLockCustomDialogEvent(
                                                    "POS Transactions"));
                                          } else {
                                            bloc.add(
                                                HomeCardUnLockCustomDialogEvent(
                                                    "POS Transactions"));
                                          }
                                        }),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        CustomSwitch("Ecom Transactions", null,
                                            bloc.ecomTransactions, (value) {
                                          if (value) {
                                            bloc.add(
                                                HomeCardLockCustomDialogEvent(
                                                    "Ecom Transactions"));
                                          } else {
                                            bloc.add(
                                                HomeCardUnLockCustomDialogEvent(
                                                    "Ecom Transactions"));
                                          }
                                        }),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        CustomSwitch(
                                            "International Transactions",
                                            null,
                                            bloc.internationalTransactions,
                                            (value) {
                                          if (value) {
                                            bloc.add(HomeCardLockCustomDialogEvent(
                                                "International Transactions"));
                                          } else {
                                            bloc.add(
                                                HomeCardUnLockCustomDialogEvent(
                                                    "International Transactions"));
                                          }
                                        }),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        CustomSwitch("Contactless Transaction",
                                            null, bloc.contactlessTransactions,
                                            (value) {
                                          if (value) {
                                            bloc.add(
                                                HomeCardLockCustomDialogEvent(
                                                    "Contactless Transaction"));
                                          } else {
                                            bloc.add(
                                                HomeCardUnLockCustomDialogEvent(
                                                    "Contactless Transaction"));
                                          }
                                        })
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                // second tab bar viiew widget
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 9),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 12,
                            ),
                            TransactionLimitWidget(
                              "ATM Transactions",
                              bloc.atmTransactionsLimit,
                              (value) {
                                setState(() {
                                  bloc.atmTransactionsLimit = value;
                                });
                              },
                              Container(
                                width: 24,
                                height: 24,
                                child: Image(image: ImageResource.atm),
                              ),
                              bloc.atmLimitTextController,
                              (limit) {
                                // setState(() {
                                //   bloc.atmLimit = limit;
                                // });
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TransactionLimitWidget(
                              "POS Transactions",
                              bloc.posTransactionsLimit,
                              (value) {
                                bloc.posTransactionsLimit = value;
                              },
                              Container(
                                width: 20,
                                height: 15,
                                child: Image(image: ImageResource.pos),
                              ),
                              bloc.posLimitTextController,
                              (limit) {
                                // setState(() {
                                //   bloc.posLimit = limit;
                                // });
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TransactionLimitWidget(
                              "Ecom Transactions",
                              bloc.ecomTransactionsLimit,
                              (value) {
                                bloc.ecomTransactionsLimit = value;
                              },
                              Container(
                                width: 24,
                                height: 24,
                                child: Image(image: ImageResource.ecom),
                              ),
                              bloc.ecomLimitTextController,
                              (limit) {
                                // setState(() {
                                //   bloc.ecomlimit = limit;
                                // });
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void lockCardPreferenceValue(String text) {
    if (text == "ATM Transactions") {
      bloc.atmTransactions = true;
    } else if (text == "POS Transactions") {
      bloc.posTransactions = true;
    } else if (text == "Ecom Transactions") {
      bloc.ecomTransactions = true;
    } else if (text == "International Transactions") {
      bloc.internationalTransactions = true;
    } else if (text == "Contactless Transaction") {
      bloc.contactlessTransactions = true;
    }
    setState(() {});
  }

  void unlockCardPreferenceValue(String text) {
    if (text == "ATM Transactions") {
      bloc.atmTransactions = false;
    } else if (text == "POS Transactions") {
      bloc.posTransactions = false;
    } else if (text == "Ecom Transactions") {
      bloc.ecomTransactions = false;
    } else if (text == "International Transactions") {
      bloc.internationalTransactions = false;
    } else if (text == "Contactless Transaction") {
      bloc.contactlessTransactions = false;
    }
    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _timer.cancel();
    super.dispose();
  }
}
