import 'package:flutter/material.dart';
import 'package:flutter_grocery/view/base/custom_button.dart';
import 'package:flutter_grocery/view/screens/select_address/select_Address_Screen.dart';
import 'package:provider/provider.dart';

import '../../../helper/route_helper.dart';
import '../../../localization/language_constrants.dart';
import '../../../provider/localization_provider.dart';
import '../../../utill/app_constants.dart';
import '../../../utill/color_resources.dart';
import '../../../utill/dimensions.dart';
import '../../../utill/styles.dart';

class LanguageScreen extends StatefulWidget {
  bool isFirst;

  LanguageScreen({@required this.isFirst});

  @override
  _LanguageScreenState createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  int selected_index = -1;

  void set_Ar_Lang() {
    Provider.of<LocalizationProvider>(context, listen: false)
        .setLanguage(Locale(
      AppConstants.languages[0].languageCode,
      AppConstants.languages[0].countryCode,
    ));

    selected_index = 0;
  }

  void set_En_Lang() {
    Provider.of<LocalizationProvider>(context, listen: false)
        .setLanguage(Locale(
      AppConstants.languages[1].languageCode,
      AppConstants.languages[1].countryCode,
    ));

    selected_index = 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          getTranslated('select_lang', context),
          style: TextStyle(color: Theme
              .of(context)
              .primaryColor),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.1,
            ),
            Text(
              getTranslated('choose_language', context),
              style: TextStyle(
                  color: Theme
                      .of(context)
                      .primaryColor,
                  fontSize: Dimensions.FONT_SIZE_OVER_LARGE),
            ),

            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selected_index = 0;
                          });
                          set_Ar_Lang();
                        },
                        child: Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: selected_index == 0
                                ? ColorResources.getHintColor(context)
                                : Theme
                                .of(context)
                                .primaryColor,
                            boxShadow: [
                              BoxShadow(color: Colors.white, spreadRadius: 3),
                            ],
                          ),
                          height: 40,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('assets/image/egypt.png'),
                                SizedBox(width: 5,),
                                Text(getTranslated('languageAr', context),
                                    style: poppinsMedium.copyWith(
                                        color: Colors.white,
                                        fontSize: Dimensions.FONT_SIZE_LARGE)),
                              ],
                            ),
                          ),
                        ),
                      )),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selected_index = 1;
                          });
                          set_En_Lang();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: selected_index == 1
                                ? ColorResources.getHintColor(context)
                                : Theme
                                .of(context)
                                .primaryColor,
                            boxShadow: [
                              BoxShadow(color: Colors.white, spreadRadius: 3),
                            ],
                          ),
                          height: 40,
                          child: Center(

                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('assets/image/united_kingdom.png'),
                                SizedBox(width: 5,),
                                Text(getTranslated('languageEn', context),
                                    style: poppinsMedium.copyWith(
                                        color: Colors.white,
                                        fontSize: Dimensions.FONT_SIZE_LARGE)),
                              ],
                            ),
                          ),
                        ),
                      )),
                  /*Expanded(flex : 1,child: CustomButton(buttonText: getTranslated('languageAr', context), onPressed: set_Ar_Lang)),
                  */ /*SizedBox(width: 10,),*/ /*
                  Expanded(flex : 1,child: CustomButton(buttonText: getTranslated('languageEr', context), onPressed: set_En_Lang)),*/
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
                child: Image.asset('assets/image/na_january_20.png')),
            SizedBox(height: MediaQuery
                .of(context)
                .size
                .height * 0.1,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SelectAddressScreen(isFirst: widget.isFirst,)),
                  );
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color:  Theme
                        .of(context)
                        .primaryColor,
                    boxShadow: [
                      BoxShadow(color: Colors.white, spreadRadius: 3),
                    ],
                  ),
                  height: 40,
                  child: Center(

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/image/location_zamzam.png' , width: 30, height: 25,),
                        SizedBox(width: 5,),
                        Text(getTranslated('select_delivery_address', context),
                            style: poppinsMedium.copyWith(
                                color: Colors.white,
                                fontSize: Dimensions.FONT_SIZE_LARGE)),
                      ],
                    ),
                  ),
                ),
              ) /*TextButton(
                onPressed: () {

                },
                child: Text(getTranslated('select_delivery_address', context),
                    style: poppinsMedium.copyWith(
                        color: Colors.white,
                        fontSize: Dimensions.FONT_SIZE_LARGE)),
                style: TextButton.styleFrom(
                  backgroundColor: Theme
                      .of(context)
                      .primaryColor,
                  minimumSize: Size(MediaQuery
                      .of(context)
                      .size
                      .width, 40),
                ),
              )*/,
            ),
          ],
        ),
      ),
    );
  }
}
