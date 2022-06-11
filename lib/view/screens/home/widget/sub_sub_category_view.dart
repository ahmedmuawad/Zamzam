import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../data/model/response/category_model.dart';
import '../../../../helper/responsive_helper.dart';
import '../../../../helper/route_helper.dart';
import '../../../../localization/language_constrants.dart';
import '../../../../provider/category_provider.dart';
import '../../../../provider/splash_provider.dart';
import '../../../../provider/theme_provider.dart';
import '../../../../utill/color_resources.dart';
import '../../../../utill/dimensions.dart';
import '../../../../utill/images.dart';
import '../../../../utill/styles.dart';
import '../../../base/title_widget.dart';
import '../../product/category_product_screen.dart';
import 'category_view.dart';

class SubSubCategory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(builder: (context, category, child) {
      return category.ssHomecate != null
          ? ListView.builder(
          itemCount: category.ssHomecate.length,
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Column(
              children: [

                Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TitleWidget(title: category.ssHomecate[index].name),
                ),

                GridView.builder(
                  itemCount: category.ssHomecate[index].subSubList.length /*> 5 ? 6 : category.categoryList.length*/,
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: ResponsiveHelper.isDesktop(context) ? (1 / 1.1) : (1 / 1.2),
                    crossAxisCount: ResponsiveHelper.isDesktop(context)?6:ResponsiveHelper.isMobilePhone()?3:ResponsiveHelper.isTab(context)?4:3,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index1) {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          RouteHelper.getCategoryProductsRoute(category.ssHomecate[index].subSubList[index1].id),
                          arguments: CategoryProductScreen(categoryModel: CategoryModel(
                            id: category.ssHomecate[index].subSubList[index1].id,
                            name: category.ssHomecate[index].subSubList[index1].name,
                          )),
                        );


                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white.withOpacity(Provider.of<ThemeProvider>(context).darkTheme ? 0.05 : 1),
                          boxShadow: Provider.of<ThemeProvider>(context).darkTheme
                              ? null
                              : [BoxShadow(color: Colors.grey[200], spreadRadius: 1, blurRadius: 5)],
                        ),
                        child: Column(children: [
                          Expanded(
                            flex: ResponsiveHelper.isDesktop(context) ? 7 : 6,
                            child: Container(
                                margin: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: ColorResources.getCardBgColor(context),
                                ),
                                child:ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: FadeInImage.assetNetwork(
                                    placeholder: Images.placeholder,
                                    image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.categoryImageUrl}/${category.ssHomecate[index].subSubList[index1].image}',
                                    fit: BoxFit.cover, height: 100, width: 100,
                                    imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder, height: 100, width: 100, fit: BoxFit.cover),
                                  ),
                                )
                            ),
                          ),
                          Expanded(
                            flex: ResponsiveHelper.isDesktop(context) ? 3 : 4,
                            child: Padding(
                              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                              child: Text(
                                category.ssHomecate[index].subSubList[index1].name ,
                                style: poppinsLight,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ]),
                      ),
                    );
                  },
                ),
              ],
            );
          })
          : CategoryShimmer();
    });
  }
}
