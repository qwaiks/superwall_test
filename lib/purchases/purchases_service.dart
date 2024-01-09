import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:superwallkit_flutter/superwallkit_flutter.dart';
import 'package:test_superwall_app/env.dart';
import 'package:test_superwall_app/purchases/rc_purchases_controller.dart';
import 'package:test_superwall_app/purchases/store_config.dart';

class PurchasesService {
  //singleton
  static final PurchasesService _instance = PurchasesService._internal();

  factory PurchasesService() {
    return _instance;
  }

  PurchasesService._internal();

  void _initStore() {
    if (Platform.isIOS || Platform.isMacOS) {
      StoreConfig(
        store: DistributionStore.appleStore,
        apiKey: Env.revenueCatApiKeyApple,
      );
    } else if (Platform.isAndroid) {
      StoreConfig(
        store: DistributionStore.appleStore,
        apiKey: Env.revenueCatApiKeyGoogle,
      );
    }
  }

  Future<void> initialize() async {
    if (!kIsWeb) {
      _initStore();
      final purchaseController = RCPurchaseController();
      final apiKey =
          Platform.isIOS ? Env.superwallApiKeyIOS : Env.superwallApiKeyAndroid;
      Superwall.configure(apiKey, purchaseController: purchaseController);
      await purchaseController.configureAndSyncSubscriptionStatus();

      //await Purchases.setLogLevel(LogLevel.error);
      final configuration = PurchasesConfiguration(StoreConfig.instance.apiKey)
        ..observerMode = false;
      await Purchases.configure(configuration);
    }
  }

  Future<void> setupUser() async {
    if (!kIsWeb) {
      //if not web, setup revenue cat
      await setupUserMobile(email: 'test@example.com', userId: "testuserId");
    }
  }

  Future<void> setupUserWeb(
      {required String userId,
      required String currentTeamId,
      required String email}) async {
    // final user = ref.read(authRepositoryProvider).userToken;
    // if (user != null) {
    //   //TODO SETUP WEB PURCHASES
    //   final restClient = ref.read(revenueCatClientProvider);
    //   //get or create customer on revcat https://api.revenuecat.com/v1/subscribers/{app_user_id}
    //   final response = await restClient.getOrCreateCustomer(userId);
    //   if (response.data != null) {
    //     final data = response.data as Map<String, dynamic>?;
    //     final subscriber = data?.containsKey('subscriber') ?? false
    //         ? data!['subscriber'] as Map<String, dynamic>
    //         : null;
    //     final entitlements = data?.containsKey('entitlements') ?? false
    //         ? subscriber!['entitlements'] as Map<String, dynamic>
    //         : null;
    //     final premiumEntitlementData =
    //         entitlements?.containsKey('entitlements') ?? false
    //             ? subscriber![Env.revenueCatEntitlementId]
    //                 as Map<String, dynamic>
    //             : null;
    //     final expiryDate =
    //         premiumEntitlementData?.containsKey('entitlements') ?? false
    //             ? premiumEntitlementData!['expires_date'] as String?
    //             : null;

    //     // convert 2023-07-06T00:59:17Z to data time and compare to now
    //     final expiryDateTime = expiryDate != null
    //         ? DateTime.parse(expiryDate).toLocal().toUtc()
    //         : null;
    //     final now = DateTime.now().toUtc();
    //     final _hasPremium =
    //         expiryDateTime != null && expiryDateTime.isAfter(now);
    //     ref.read(premiumSubscriptionStatusProvider.notifier).state =
    //         _hasPremium;
    //   }
    //update customer attributes https://api.revenuecat.com/v1/subscribers/{app_user_id}/attribution
    // final response2 = await restClient.updateCustomerAttributes(
    //   userId,
    //   'mybestpic',
    //   'mybestpic',
    //   'mybestpic',
    //   'mybestpic',
    // );
    //get customer entitlements infomation
    // final customer = await restClient.getCustomerEntitlements(userId);
    //Logger().d(customer);
    //update ref.read(premiumSubscriptionStatusProvider.notifier).state = _hasPremium
  }

  Future<void> setupUserMobile(
      {required String userId, required String email}) async {
    //final user = ref.read(authRepositoryProvider).userToken;

    await Purchases.logIn(userId);
    await Purchases.setAttributes({
      'email': email,
    });
    Purchases.addCustomerInfoUpdateListener((customerInfo) async {
      final customerInfo = await Purchases.getCustomerInfo();
      final hasPremium = await hasPremiumSubscription(customerInfo);
    });
  }

  Future<void> viewPaywall({String? paywall}) async {
    //SUPERWALL IMPLEMENTATION
    PaywallPresentationHandler()
      ..onPresent((paywallInfo) {
        Logger().d('Handler (onPresent): ${paywallInfo.name}');
      })
      ..onDismiss((paywallInfo) {
        Logger().d('Handler (onDismiss): ${paywallInfo.name}');
      })
      ..onError((error) {
        Logger().d('Handler (onError): $error');
      })
      ..onSkip((skipReason) {
        Logger().d('Handler (onSkip): $skipReason');
      });
    if (paywall != null) {
      await Superwall.shared.registerEvent(paywall);
    }

    //REVENUE CAT IMPLEMENTATION
    // if (paywall != null) {
    //   await RevenueCatUI.presentPaywallIfNeeded(paywall);
    // } else {
    //   await RevenueCatUI.presentPaywall();
    // }
  }

  Future<void> logoutUser() async {
    await Purchases.logOut();
  }

  void viewPackages() {}

  Future<bool> hasPremiumSubscription(CustomerInfo customerInfo) async {
    return customerInfo.entitlements.all[Env.revenueCatEntitlementId] != null &&
        customerInfo.entitlements.all[Env.revenueCatEntitlementId]!.isActive;
  }
}
