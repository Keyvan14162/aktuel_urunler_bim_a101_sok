import 'package:aktuel_urunler_bim_a101_sok/constants/constants.dart';
import 'package:aktuel_urunler_bim_a101_sok/constants/pages.dart';
import 'package:aktuel_urunler_bim_a101_sok/data/kataloglar_client.dart';
import 'package:aktuel_urunler_bim_a101_sok/models/banner_model.dart';
import 'package:aktuel_urunler_bim_a101_sok/models/store_model.dart';
import 'package:aktuel_urunler_bim_a101_sok/widgets/loadings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class BannerGridView extends StatelessWidget {
  const BannerGridView({required this.store, super.key});
  final StoreModel store;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: store.bannerDataFunc,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData &&
            snapshot.data != null) {
          List<BannerModel> banners = snapshot.data as List<BannerModel>;

          return MasonryGridView.builder(
            physics: const BouncingScrollPhysics(),
            gridDelegate: SliverSimpleGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 0.5.sw,
            ),
            itemCount: banners.length,
            itemBuilder: (context, index) {
              Future brochurePageImagesFuture;
              brochurePageImagesFuture =
                  KataloglarClient().getBrochurePageImageUrls(
                banners[index].bannerUrl.toString(),
              );
              return _banner(
                banners[index].bannerName ?? "",
                banners[index].date ?? "",
                banners[index].bannerImgUrl ?? "",
                store.storeColor,
                brochurePageImagesFuture,
                context,
              );
            },
          );
        } else {
          return Center(
            child: Loadings.animatedLoadingText(),
          );
        }
      },
    );
  }

  _banner(
    String bannerName,
    String date,
    String bannerImgUrl,
    Color color,
    Future brochurePageImagesFuture,
    BuildContext context,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(Pages.gridPage, arguments: [
          brochurePageImagesFuture,
          date,
          color,
        ]);
      },
      child: Card(
        color: Colors.grey.shade200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(Constants.defaultPadding / 2),
              child: Container(
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(Constants.defaultBorderRadius / 2),
                  ),
                ),
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(Constants.defaultPadding),
                  child: Text(
                    date,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            CachedNetworkImage(
              imageUrl: bannerImgUrl,
              fit: BoxFit.fill,
            ),
            Padding(
              padding: const EdgeInsets.all(Constants.defaultPadding / 2),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(Constants.defaultBorderRadius / 2),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(Constants.defaultPadding),
                  child: Text(
                    maxLines: 1,
                    bannerName,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
