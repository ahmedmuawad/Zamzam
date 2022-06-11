import 'dart:collection';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter_grocery/data/model/response/address_model.dart';
import 'package:flutter_grocery/helper/price_converter.dart';
import 'package:flutter_grocery/provider/localization_provider.dart';
import 'package:flutter_grocery/view/base/custom_divider.dart';
import 'package:flutter_grocery/view/base/custom_snackbar.dart';
import 'package:flutter_grocery/view/base/custom_text_field.dart';
import 'package:flutter_grocery/view/base/main_app_bar.dart';
import 'package:flutter_grocery/view/screens/checkout/widget/delivery_fee_dialog.dart';
import 'package:flutter_grocery/view/screens/menu/menu_screen.dart';
import 'package:universal_html/html.dart' as html;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_grocery/data/model/body/place_order_body.dart';
import 'package:flutter_grocery/data/model/response/cart_model.dart';
import 'package:flutter_grocery/data/model/response/config_model.dart';
import 'package:flutter_grocery/data/model/response/order_model.dart';
import 'package:flutter_grocery/helper/date_converter.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/provider/auth_provider.dart';
import 'package:flutter_grocery/provider/cart_provider.dart';
import 'package:flutter_grocery/provider/coupon_provider.dart';
import 'package:flutter_grocery/provider/location_provider.dart';
import 'package:flutter_grocery/provider/order_provider.dart';
import 'package:flutter_grocery/provider/product_provider.dart';
import 'package:flutter_grocery/provider/profile_provider.dart';
import 'package:flutter_grocery/provider/splash_provider.dart';
import 'package:flutter_grocery/provider/theme_provider.dart';
import 'package:flutter_grocery/utill/app_constants.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/view/base/custom_app_bar.dart';
import 'package:flutter_grocery/view/base/custom_button.dart';
import 'package:flutter_grocery/view/base/not_login_screen.dart';
import 'package:flutter_grocery/view/screens/address/add_new_address_screen.dart';
import 'package:flutter_grocery/view/screens/checkout/order_successful_screen.dart';
import 'package:flutter_grocery/view/screens/checkout/payment_screen.dart';
import 'package:flutter_grocery/view/screens/checkout/widget/custom_check_box.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../address/widget/location_search_dialog.dart';
import '../auth/login_screen.dart';

class SelectAddressScreen extends StatefulWidget {

  bool isFirst ;
  SelectAddressScreen({@required this.isFirst});
  @override
  _SelectAddressScreenState createState() => _SelectAddressScreenState();
}

class _SelectAddressScreenState extends State<SelectAddressScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  GoogleMapController _controller;
  TextEditingController _locationController = TextEditingController();
  CameraPosition _cameraPosition;
  List<Branches> _branches = [];

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text(value)));
  }

  @override
  void initState() {
    super.initState();
    Provider.of<LocationProvider>(context, listen: false).setPickData();
    _branches = Provider.of<SplashProvider>(context, listen: false).configModel.branches;

  }
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _openSearchDialog(BuildContext context, GoogleMapController mapController) async {
    showDialog(context: context, builder: (context) => LocationSearchDialog(mapController: mapController));
  }

  @override
  Widget build(BuildContext context) {
    if (Provider.of<LocationProvider>(context).address != null) {
      _locationController.text = '${Provider.of<LocationProvider>(context).address.name ?? ''}, '
          '${Provider.of<LocationProvider>(context).address.subAdministrativeArea ?? ''}, '
          '${Provider.of<LocationProvider>(context).address.isoCountryCode ?? ''}';
    }
    bool _isAvailable = _branches.length == 1 && (_branches[0].latitude == null || _branches[0].latitude.isEmpty);
    return Scaffold(
      key: _scaffoldKey,
      appBar: ResponsiveHelper.isDesktop(context)? MainAppBar(): CustomAppBar(title: getTranslated('select_delivery_address', context), isCenter: true),
      body: Center(
        child: Container(
          width: 1170,
          child: Consumer<LocationProvider>(
            builder: (context, locationProvider, child) => Stack(

              clipBehavior: Clip.none,
              children: [
                GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(locationProvider.position.latitude, locationProvider.position.longitude),
                    zoom: 17,
                  ),
                  zoomControlsEnabled: false,
                  compassEnabled: false,
                  indoorViewEnabled: true,
                  mapToolbarEnabled: true,
                  onCameraIdle: () {
                    locationProvider.updatePosition(_cameraPosition, false, null, context);
                  },
                  onCameraMove: ((_position) => _cameraPosition = _position),
                  // markers: Set<Marker>.of(locationProvider.markers),
                  onMapCreated: (GoogleMapController controller) {
                    _controller = controller;
                    locationProvider.getCurrentLocation(context, false, mapController: controller);
                  },
                ),
                locationProvider.pickAddress != null
                    ? InkWell(
                  onTap: () => _openSearchDialog(context, _controller),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE, vertical: 18.0),
                    margin: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE, vertical: 23.0),
                    decoration:
                    BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL)),
                    child: Row(children: [
                      Expanded(child: Text(locationProvider.pickAddress.name != null
                          ? '${locationProvider.pickAddress.name ?? ''} ${locationProvider.pickAddress.subAdministrativeArea ?? ''} ${locationProvider.pickAddress.isoCountryCode ?? ''}'
                          : '', maxLines: 1, overflow: TextOverflow.ellipsis)),
                      Icon(Icons.search, size: 20),
                    ]),
                  ),
                )
                    : SizedBox.shrink(),
                Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          locationProvider.getCurrentLocation(context, false, mapController: _controller);
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          margin: EdgeInsets.only(right: Dimensions.PADDING_SIZE_LARGE),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                            color: ColorResources.getCardBgColor(context),
                          ),
                          child: Icon(
                            Icons.my_location,
                            color: Theme.of(context).primaryColor,
                            size: 35,
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                          child: CustomButton(
                            buttonText: getTranslated('select_location', context),
                            onPressed: () {

                              if(!_isAvailable) {
                                double _distance = Geolocator.distanceBetween(
                                  double.parse(_branches[0].latitude), double.parse(_branches[0].longitude),
                                  locationProvider.pickPosition.latitude, locationProvider.pickPosition.longitude,
                                ) / 1000;
                                _isAvailable = _distance < _branches[0].coverage;
                              }
                              locationProvider.setAddAddressData();
                              if(_isAvailable){
                                if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
                                  Provider.of<AuthProvider>(context, listen: false).updateToken();
                                  Navigator.of(context).pushNamedAndRemoveUntil(RouteHelper.menu, (route) => false, arguments: MenuScreen());
                                } else {
                                  Navigator.of(context).pushReplacementNamed(RouteHelper.login, arguments: LoginScreen());
                                }



                                //Navigator.of(context).pop();
                              }else{
                                showInSnackBar(getTranslated('out_of_coverage_for_this_branch', context));
                              }

                              /*if(widget.googleMapController != null) {
                                widget.googleMapController.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(
                                  locationProvider.pickPosition.latitude, locationProvider.pickPosition.longitude,
                                ), zoom: 17)));
                                locationProvider.setAddAddressData();
                              }
                              Navigator.of(context).pop();*/
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                    child: Icon(
                      Icons.location_on,
                      color: Theme.of(context).primaryColor,
                      size: 50,
                    )),
                locationProvider.loading
                    ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)))
                    : SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }



}
