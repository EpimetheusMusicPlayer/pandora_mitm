import 'package:iapetus/iapetus.dart';
import 'package:iapetus/iapetus_data.dart';
import 'package:meta/meta.dart';
import 'package:pandora_mitm/plugin_dev.dart';

/// A [PandoraMitm] plugin that unlocks as many client-side features as
/// possible.
///
/// This enables client-side Pandora Premium features, disables ads, removes
/// skip limits, etc.
class FeatureUnlockPlugin extends ResponseModificationBasePlugin {
  const FeatureUnlockPlugin();

  @override
  Set<String> get hookedEndpoints => const {'auth.userLogin'};

  @protected
  @override
  ResponseModifier getResponseModifierForEndpoint(String endpoint) {
    switch (endpoint) {
      case 'auth.userLogin':
        return _modifyUserLogin;
      default:
        throw FallThroughError();
    }
  }

  static PandoraApiResponse _modifyUserLogin(
    PandoraApiRequest apiRequest,
    SuccessfulPandoraApiResponse apiResponse,
  ) =>
      apiResponse.copyWithModifiedResult(
        AuthenticatedUser.fromJson(apiResponse.resultJson)
            .copyWith(
              isMonthlyPayer: true,
              dailySkipLimitSubscriber: 1000000,
              dailySkipLimitNonSubscriber: 1000000,
              dailySkipLimit: 1000000,
              stationHourlySkipLimit: 1000000,
              listeningTimeout:
                  const Duration(hours: Duration.hoursPerDay * 365),
              minimumAdRefreshInterval: Duration.secondsPerDay * 365,
              canListen: true,
              hasUsedTrial: false,
              isSubscriber: true,
              isCapped: false,
              subscriptionHasExpired: false,
              skipDelayAfterTrackStart: Duration.zero,
              monthlyCapHours: 0,
              hasAudioAds: false,
              skipLimitBehavior: SkipLimitBehavior.unlimited,
              enableOnDemand: true,
              // isEligibleForOffline: true,
              // isEligibleForManualDownload: true,
              pandoraBrandingType: PandoraBrandingType.premium,
              canSellUserData: false,
            )
            .toJson(),
      );
}
