import 'package:flutter/material.dart';
import 'package:flutter_grocery/provider/category_provider.dart';
import 'package:flutter_grocery/provider/product_provider.dart';
import 'package:flutter_grocery/view/screens/home/widget/category_view.dart';
import 'package:provider/provider.dart';

import '../../../../data/model/response/cart_model.dart';
import '../../../../data/model/response/product_model.dart';
import '../../../../helper/price_converter.dart';
import '../../../../helper/responsive_helper.dart';
import '../../../../helper/route_helper.dart';
import '../../../../localization/language_constrants.dart';
import '../../../../provider/cart_provider.dart';
import '../../../../provider/localization_provider.dart';
import '../../../../provider/splash_provider.dart';
import '../../../../provider/theme_provider.dart';
import '../../../../utill/color_resources.dart';
import '../../../../utill/dimensions.dart';
import '../../../../utill/images.dart';
import '../../../../utill/styles.dart';
import '../../../base/no_data_screen.dart';
import '../../../base/product_shimmer.dart';
import '../../../base/product_widget.dart';
import '../../../base/title_widget.dart';
import '../../product/product_details_screen.dart';

class CategoryDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(builder: (context, category, child) {

      return Column(children: [
        category.subCategoryData.length > 0
            ? ListView.builder(
                itemCount: category.subCategoryData.length,
                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index1) {
                  return Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: TitleWidget(
                            title: category.subCategoryData[index1].category),
                      ),
                      SizedBox(
                          height: 190,
                          child:
                              category.subCategoryData[index1].products.length >
                                      0
                                  ? ListView.builder(
                                      itemCount: category
                                          .subCategoryData[index1]
                                          .products
                                          .length,
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                              Dimensions.PADDING_SIZE_SMALL),
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        double _startingPrice;
                                        double _endingPrice;
                                        if(category.subCategoryData[index1].products[index].variations.length != 0) {
                                          List<double> _priceList = [];
                                          category.subCategoryData[index1].products[index].variations.forEach((variation) => _priceList.add(variation.price));
                                          _priceList.sort((a, b) => a.compareTo(b));
                                          _startingPrice = _priceList[0];
                                          if(_priceList[0] < _priceList[_priceList.length-1]) {
                                            _endingPrice = _priceList[_priceList.length-1];
                                          }
                                        }else {
                                          _startingPrice = category.subCategoryData[index1].products[index].price;
                                        }
                                        return Padding(
                                          padding: EdgeInsets.only(
                                              right: Dimensions
                                                  .PADDING_SIZE_SMALL),
                                          child: Container(
                                            width: 150,
                                            padding: EdgeInsets.all(Dimensions
                                                .PADDING_SIZE_EXTRA_SMALL),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color:
                                                  Theme.of(context).cardColor,
                                            ),
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    height: 100,
                                                    width: 150,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      border: Border.all(
                                                          width: 1,
                                                          color: ColorResources
                                                              .getGreyColor(
                                                                  context)),
                                                    ),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      child: InkWell(
                                                        onTap: () {
                                                          Navigator.of(context).pushNamed(
                                                              RouteHelper.getProductDetailsRoute(
                                                                  category
                                                                      .subCategoryData[
                                                                          index1]
                                                                      .products[
                                                                          index]
                                                                      .id),
                                                              arguments: ProductDetailsScreen(
                                                                  product: category
                                                                      .subCategoryData[
                                                                          index1]
                                                                      .products[index],
                                                                  cart: null));
                                                        },
                                                        child: FadeInImage
                                                            .assetNetwork(
                                                          placeholder: Images
                                                              .placeholder,
                                                          width: 100,
                                                          height: 150,
                                                          fit: BoxFit.cover,
                                                          image:
                                                              '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productImageUrl}'
                                                              '/${category.subCategoryData[index1].products[index].image[0]}',
                                                          imageErrorBuilder: (c,
                                                                  o, s) =>
                                                              Image.asset(
                                                                  Images
                                                                      .placeholder,
                                                                  width: 80,
                                                                  height: 50,
                                                                  fit: BoxFit
                                                                      .cover),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      height: Dimensions
                                                          .PADDING_SIZE_EXTRA_SMALL),
                                                  Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          category
                                                              .subCategoryData[
                                                                  index1]
                                                              .products[index]
                                                              .name,
                                                          style: poppinsMedium
                                                              .copyWith(
                                                                  fontSize:
                                                                      Dimensions
                                                                          .FONT_SIZE_SMALL),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                        Text(
                                                          '${category.subCategoryData[index1].products[index].capacity} ${category.subCategoryData[index1].products[index].unit}',
                                                          style: poppinsRegular
                                                              .copyWith(
                                                                  fontSize:
                                                                      Dimensions
                                                                          .FONT_SIZE_EXTRA_SMALL),
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                        Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    PriceConverter.convertPrice(context, category.subCategoryData[index1].products[index].price,
                                                                      discount: category
                                                                          .subCategoryData[
                                                                              index1]
                                                                          .products[
                                                                              index]
                                                                          .discount,
                                                                      discountType: category
                                                                          .subCategoryData[
                                                                              index1]
                                                                          .products[
                                                                              index]
                                                                          .discountType,
                                                                    ),
                                                                    style: poppinsBold.copyWith(
                                                                        fontSize:
                                                                            Dimensions.FONT_SIZE_SMALL),
                                                                  ),
                                                                  category.subCategoryData[index1].products[index].discount > 0
                                                                      ? Text(
                                                                    '${PriceConverter.convertPrice(context, _startingPrice)}'
                                                                        '${_endingPrice!= null ? '  ${PriceConverter.convertPrice(context, _endingPrice)}' : ''}',
                                                                    style: poppinsBold.copyWith(color: Colors.red, fontSize: Dimensions.FONT_SIZE_SMALL, decoration: TextDecoration.lineThrough),
                                                                  )
                                                                      : SizedBox(),
                                                                ],
                                                              ),
                                                              Container(
                                                                margin:
                                                                    EdgeInsets
                                                                        .all(2),
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  border: Border.all(
                                                                      width: 1,
                                                                      color: ColorResources.getHintColor(
                                                                              context)
                                                                          .withOpacity(
                                                                              0.2)),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                ),
                                                                child: InkWell(
                                                                  onTap: () {
                                                                    double _price = category
                                                                        .subCategoryData[
                                                                            index1]
                                                                        .products[
                                                                            index]
                                                                        .price;
                                                                    int _stock = category.subCategoryData[index1].products[index].variations.length >
                                                                            0
                                                                        ? category
                                                                            .subCategoryData[
                                                                                index1]
                                                                            .products[
                                                                                index]
                                                                            .variations[
                                                                                0]
                                                                            .stock
                                                                        : category
                                                                            .subCategoryData[index1]
                                                                            .products[index]
                                                                            .totalStock;
                                                                    CartModel
                                                                        _cartModel =
                                                                        CartModel(
                                                                      category
                                                                          .subCategoryData[
                                                                              index1]
                                                                          .products[
                                                                              index]
                                                                          .id,
                                                                      category
                                                                          .subCategoryData[
                                                                              index1]
                                                                          .products[
                                                                              index]
                                                                          .image[0],
                                                                      category
                                                                          .subCategoryData[
                                                                              index1]
                                                                          .products[
                                                                              index]
                                                                          .name,
                                                                      _price,
                                                                      PriceConverter.convertWithDiscount(
                                                                          context,
                                                                          _price,
                                                                          category
                                                                              .subCategoryData[
                                                                                  index1]
                                                                              .products[
                                                                                  index]
                                                                              .discount,
                                                                          category
                                                                              .subCategoryData[index1]
                                                                              .products[index]
                                                                              .discountType),
                                                                      1,
                                                                      category.subCategoryData[index1].products[index].variations.length >
                                                                              0
                                                                          ? category
                                                                              .subCategoryData[index1]
                                                                              .products[index]
                                                                              .variations[0]
                                                                          : null,
                                                                      (_price -
                                                                          PriceConverter.convertWithDiscount(
                                                                              context,
                                                                              _price,
                                                                              category.subCategoryData[index1].products[index].discount,
                                                                              category.subCategoryData[index1].products[index].discountType)),
                                                                      (_price -
                                                                          PriceConverter.convertWithDiscount(
                                                                              context,
                                                                              _price,
                                                                              category.subCategoryData[index1].products[index].tax,
                                                                              category.subCategoryData[index1].products[index].taxType)),
                                                                      category
                                                                          .subCategoryData[
                                                                              index1]
                                                                          .products[
                                                                              index]
                                                                          .capacity,
                                                                      category
                                                                          .subCategoryData[
                                                                              index1]
                                                                          .products[
                                                                              index]
                                                                          .unit,
                                                                      _stock,
                                                                    );
                                                                    bool
                                                                        isExistInCart =
                                                                        Provider.of<CartProvider>(context, listen: false).isExistInCart(_cartModel) !=
                                                                            -1;
                                                                    int cardIndex = Provider.of<CartProvider>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .isExistInCart(
                                                                            _cartModel);
                                                                    if (!isExistInCart) {
                                                                      Provider.of<CartProvider>(
                                                                              context,
                                                                              listen:
                                                                                  false)
                                                                          .addToCart(
                                                                              _cartModel);
                                                                    }
                                                                    Navigator.pushNamed(
                                                                        context,
                                                                        RouteHelper
                                                                            .cart);

                                                                    /*Navigator.of(context).pushNamed(RouteHelper.getProductDetailsRoute(category.subCategoryData[index1].products[index].id),
                                            arguments: ProductDetailsScreen(product: category.subCategoryData[index1].products[index],
                                                cart: isExistInCart ? Provider.of<CartProvider>(context, listen: false).cartList[cardIndex] : null));*/
                                                                  },
                                                                  child: Icon(
                                                                      Icons.add,
                                                                      size: 20,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .primaryColor),
                                                                ),
                                                              ),
                                                            ]),
                                                      ]),
                                                ]),
                                          ),
                                        );
                                      },
                                    )
                                  : SizedBox(
                                      height: 10,
                                    )),
                    ],
                  );
                })
            : SizedBox(
                height: 10,
              )
      ]);
    });
  }
}
