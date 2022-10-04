import 'package:aktuel_urunler_bim_a101_sok/helpers/a101.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:hexcolor/hexcolor.dart';
import 'package:shimmer/shimmer.dart';

class A101GridView extends StatefulWidget {
  const A101GridView({required this.categoryUrl, super.key});
  final String categoryUrl;

  @override
  State<A101GridView> createState() => _A101GridViewState();
}

class _A101GridViewState extends State<A101GridView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.categoryUrl.split("/")[3].replaceAll("-", " ").toUpperCase(),
        ),
      ),
      body: FutureBuilder(
        future: A101().getBrochurePageImageUrls(widget.categoryUrl),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<String> brochurePages = snapshot.data as List<String>;
            // grid view
            return GridView.builder(
              itemCount: brochurePages.length,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: MediaQuery.of(context).size.width / 3,
                childAspectRatio: 1 / 1.5,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemBuilder: (BuildContext ctx, index) {
                // gridview items
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed("/a101BannerPage",
                        arguments: [widget.categoryUrl, index]);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 1,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      // IMAGE
                      child: CachedNetworkImage(
                        fit: BoxFit.contain,
                        imageUrl: brochurePages[index],
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: HexColor("#fcfcfc"),
                          highlightColor: HexColor("#edebe6"),
                          child: Image.network(
                            brochurePages[0],
                            fit: BoxFit.contain,
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                  // color
                  ),
            );
          }
        },
      ),
    );
  }
}
