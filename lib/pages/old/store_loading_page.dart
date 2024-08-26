import 'package:aktuel_urunler_bim_a101_sok/constants/constants.dart';
import 'package:aktuel_urunler_bim_a101_sok/constants/enums.dart';
import 'package:aktuel_urunler_bim_a101_sok/data/kataloglar_client.dart';
import 'package:aktuel_urunler_bim_a101_sok/models/banner_model.dart';
import 'package:aktuel_urunler_bim_a101_sok/pages/old/store_page_old.dart';
import 'package:aktuel_urunler_bim_a101_sok/widgets/expansion_panel/custom_expansion_panel.dart';
import 'package:aktuel_urunler_bim_a101_sok/widgets/loadings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StoreLoadingPage extends StatelessWidget {
  const StoreLoadingPage({required this.stores, super.key});
  final List<StoreCode> stores;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: createExpansionPanelItems(stores, 1.sw),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Loadings.manWalkinLottie();

              case ConnectionState.none:
                return Loadings.manWalkinLottie();

              case ConnectionState.active:
              case ConnectionState.done:
                if (snapshot.data != null) {
                  return StorePageOld(
                    expansionPanelItemsList: snapshot.data as List<Widget>,
                  );
                } else {
                  return Loadings.manWalkinLottie();
                }
              default:
                return Loadings.manWalkinLottie();
            }
          },
        ),
      ),
    );
  }

  Future<List<Widget>> createExpansionPanelItems(
    List<StoreCode> storeCodeList,
    double width,
  ) async {
    List<Widget> expansionPanelList = [];

    for (var storeCode in storeCodeList) {
      switch (storeCode) {
        case StoreCode.a101:
          await KataloglarClient()
              .getBannerData(Constants.a101BannerPageUrl)
              .then(
                (List<BannerModel> bannerModelsList) => expansionPanelList.add(
                  CustomExpansionPanel(
                    bannerModelsList: bannerModelsList,
                    logoPath: Constants.a101LogoPath,
                    headerText: "A101 Aktüel Katalogları",
                    color: Constants.a101Color,
                    storeCode: storeCode,
                  ),
                ),
              )
              .onError(
                (error, stackTrace) => debugPrint(
                  error.toString(),
                ),
              );
          break;
        case StoreCode.bim:
          await KataloglarClient()
              .getBannerData(Constants.bimBannerPageUrl)
              .then(
                (List<BannerModel> bannerModelsList) => expansionPanelList.add(
                  CustomExpansionPanel(
                    bannerModelsList: bannerModelsList,
                    logoPath: Constants.bimLogoPath,
                    headerText: "Bim Aktüel Katalogları",
                    color: Constants.bimColor,
                    storeCode: storeCode,
                  ),
                ),
              )
              .onError(
                (error, stackTrace) => debugPrint(
                  error.toString(),
                ),
              );
          break;

        case StoreCode.sok:
          await KataloglarClient()
              .getBannerData(Constants.sokBannerPageUrl)
              .then(
                (List<BannerModel> bannerModelsList) => expansionPanelList.add(
                  CustomExpansionPanel(
                    bannerModelsList: bannerModelsList,
                    logoPath: Constants.sokLogoPath,
                    headerText: "Şok Aktüel Katalogları",
                    color: Constants.sokColor,
                    storeCode: storeCode,
                  ),
                ),
              )
              .onError(
                (error, stackTrace) => debugPrint(
                  error.toString(),
                ),
              );
          break;
        case StoreCode.bizim:
          await KataloglarClient()
              .getBannerData(Constants.bizimBannerPageUrl)
              .then(
                (List<BannerModel> bannerModelsList) => expansionPanelList.add(
                  CustomExpansionPanel(
                    bannerModelsList: bannerModelsList,
                    logoPath: Constants.bizimLogoPath,
                    headerText: "Bizim Aktüel Katalogları",
                    color: Constants.bizimColor,
                    storeCode: storeCode,
                  ),
                ),
              )
              .onError(
                (error, stackTrace) => debugPrint(
                  error.toString(),
                ),
              );
          break;

        case StoreCode.migros:
          await KataloglarClient()
              .getBannerData(Constants.migrosBannerPageUrl)
              .then(
                (List<BannerModel> bannerModelsList) => expansionPanelList.add(
                  CustomExpansionPanel(
                    bannerModelsList: bannerModelsList,
                    logoPath: Constants.migrosLogoPath,
                    headerText: "Migros Aktüel Katalogları",
                    color: Constants.migrosColor,
                    storeCode: storeCode,
                  ),
                ),
              )
              .onError(
                (error, stackTrace) => debugPrint(
                  error.toString(),
                ),
              );
          break;

        default:
      }
    }

    return expansionPanelList;
  }
}
