import 'package:aktuel_urunler_bim_a101_sok/constants/constants.dart';
import 'package:aktuel_urunler_bim_a101_sok/constants/enums.dart';
import 'package:aktuel_urunler_bim_a101_sok/constants/pages.dart';
import 'package:aktuel_urunler_bim_a101_sok/data/kataloglar_client.dart';
import 'package:aktuel_urunler_bim_a101_sok/models/banner_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExpansionBody extends StatelessWidget {
  const ExpansionBody(
      {required this.data,
      required this.color,
      required this.storeCode,
      super.key});

  final List<BannerModel> data;
  final Color color;
  final StoreCode storeCode;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, right: 4.0),
      child: SizedBox(
        width: double.infinity,
        height: 1.sw / 2 * 1.6,
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          clipBehavior: Clip.none,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: data.length,
          itemBuilder: (context, index) {
            Future brochurePageImagesFuture;
            brochurePageImagesFuture =
                KataloglarClient().getBrochurePageImageUrls(
              data[index].bannerUrl.toString(),
            );

            return GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(Pages.gridPage, arguments: [
                  brochurePageImagesFuture,
                  data[index].date ?? "hata",
                  color,
                ]);
              },
              child: Container(
                width: 0.5.sw,
                color: Colors.white,
                child: Column(
                  children: [
                    // category text
                    Padding(
                      padding: const EdgeInsets.fromLTRB(1, 0, 1, 0),
                      child: Container(
                        width: 0.5.sw,
                        height: 40,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(4),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(
                              Constants.defaultPadding / 4),
                          child: Center(
                            child: Text(
                              data[index].bannerName ?? "hata",
                              overflow: TextOverflow.fade,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // date
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                          Constants.defaultPadding,
                          12,
                          Constants.defaultPadding,
                          4,
                        ),
                        child: Text(
                          data[index].date ?? "hata",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    // image
                    Expanded(
                      child: CachedNetworkImage(
                        imageUrl: data[index].bannerImgUrl ?? "",
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
