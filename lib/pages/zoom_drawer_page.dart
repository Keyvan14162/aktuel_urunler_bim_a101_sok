import 'dart:async';

import 'package:aktuel_urunler_bim_a101_sok/constants/constants.dart';
import 'package:aktuel_urunler_bim_a101_sok/constants/enums.dart';
import 'package:aktuel_urunler_bim_a101_sok/data/kataloglar_client.dart';
import 'package:aktuel_urunler_bim_a101_sok/models/store_model.dart';
import 'package:aktuel_urunler_bim_a101_sok/pages/old/store_loading_page.dart';
import 'package:aktuel_urunler_bim_a101_sok/pages/store_page.dart';
import 'package:aktuel_urunler_bim_a101_sok/providers/is_old_change_notifier.dart';
import 'package:aktuel_urunler_bim_a101_sok/widgets/custom_appbar.dart';
import 'package:aktuel_urunler_bim_a101_sok/widgets/zoom_drawer/zoom_drawer_menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ZoomDrawerScreen extends StatefulWidget {
  const ZoomDrawerScreen({super.key});

  @override
  State<ZoomDrawerScreen> createState() => _ZoomDrawerScreenState();
}

class _ZoomDrawerScreenState extends State<ZoomDrawerScreen>
    with TickerProviderStateMixin {
  final _drawerController = ZoomDrawerController();
  int currentIndex = 0;
  late StreamSubscription<InternetConnectionStatus> internetConnectionListener;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _setIsOld();
    });

    internetConnectionListener =
        InternetConnectionChecker().onStatusChange.listen((status) {
      ScaffoldMessenger.of(context).clearSnackBars();
      setState(() {});
    });
  }

  _setIsOld() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // ignore: use_build_context_synchronously
    context.read<IsOldNotifier>().changeIsOld(
          isOld: prefs.getBool(Constants.isOldKey) ?? false,
        );
  }

  @override
  void dispose() {
    internetConnectionListener.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _connectionStatusSnackbar();

    return Scaffold(
      extendBody: true,
      appBar: CustomAppbar(drawerController: _drawerController),
      body: ZoomDrawer(
        isRtl: false,
        androidCloseOnBackTap: true,
        mainScreenTapClose: true,
        controller: _drawerController,
        menuScreen: ZoomDrawerMenuScreen(
          setIndex: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          currentIndex: currentIndex,
        ),
        mainScreen: Provider.of<IsOldNotifier>(context).isOld
            ? oldStorePage()
            : storePage(),
        menuBackgroundColor: Theme.of(context).primaryColor.withOpacity(0.9),
        borderRadius: Constants.defaultBorderRadius,
        showShadow: true,
        angle: 0.0,
        duration: const Duration(milliseconds: 300),
      ),
    );
  }

  Widget storePage() {
    return StorePage(stores: [
      StoreModel(
        Constants.a101LogoPath,
        "A101",
        StoreCode.a101,
        KataloglarClient().getBannerData(Constants.a101BannerPageUrl),
        Constants.a101Color,
      ),
      StoreModel(
        Constants.bimLogoPath,
        "Bim",
        StoreCode.bim,
        KataloglarClient().getBannerData(Constants.bimBannerPageUrl),
        Constants.bimColor,
      ),
      StoreModel(
        Constants.sokLogoPath,
        "Şok",
        StoreCode.sok,
        KataloglarClient().getBannerData(Constants.sokBannerPageUrl),
        Constants.sokColor,
      ),
      StoreModel(
        Constants.bizimLogoPath,
        "Bizim",
        StoreCode.bizim,
        KataloglarClient().getBannerData(Constants.bizimBannerPageUrl),
        Constants.bizimColor,
      ),
      StoreModel(
        Constants.migrosLogoPath,
        "Migros",
        StoreCode.migros,
        KataloglarClient().getBannerData(Constants.migrosBannerPageUrl),
        Constants.migrosColor,
      ),
    ]);
  }

  Widget oldStorePage() {
    switch (currentIndex) {
      default:
        return const StoreLoadingPage(
          stores: [
            StoreCode.a101,
            StoreCode.bim,
            StoreCode.sok,
            StoreCode.bizim,
            StoreCode.migros,
          ],
        );
    }
  }

  void _connectionStatusSnackbar() async {
    await (InternetConnectionChecker().hasConnection).then(
      (value) {
        if (!value) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: const Duration(seconds: 100),
              backgroundColor: Colors.white,
              content: const Text(
                "İnternet Bağlantısı Bulunamadı",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              action: SnackBarAction(
                label: 'Yenile',
                onPressed: () {
                  setState(() {});
                },
              ),
            ),
          );
        }
      },
    );
  }
}
