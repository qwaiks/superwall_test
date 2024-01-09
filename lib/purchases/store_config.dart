enum DistributionStore { appleStore, googlePlay, amazonAppstore }

class StoreConfig {
  factory StoreConfig(
      {required DistributionStore store, required String apiKey}) {
    return _instance = StoreConfig._internal(store, apiKey);
  }

  StoreConfig._internal(this.store, this.apiKey);

  final DistributionStore store;
  final String apiKey;
  static late StoreConfig _instance;

  static StoreConfig get instance {
    return _instance;
  }

  static bool isForAppleStore() =>
      _instance.store == DistributionStore.appleStore;

  static bool isForGooglePlay() =>
      _instance.store == DistributionStore.googlePlay;
}
