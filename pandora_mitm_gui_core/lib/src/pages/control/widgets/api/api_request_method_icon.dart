import 'package:flutter/material.dart';

class ApiRequestMethodIcon extends StatelessWidget {
  final String method;

  const ApiRequestMethodIcon({Key? key, required this.method})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      const {
        'auth.userLogin': Icons.login,
        'auth.partnerLogin': Icons.login,
        'profile.v1.getFullProfile': Icons.person,
        'user.getSettings': Icons.settings,
        'device.appForeground': Icons.speaker_phone,
        'lcx.v2.isAccountLinked': Icons.link,
        'track.playbackPaused': Icons.pause,
        'track.playbackResumed': Icons.play_arrow,
        'track.trackStarted': Icons.play_arrow,
        'user.associateDevice': Icons.phonelink_lock,
        'device.disassociateDevice': Icons.device_unknown,
        'charon.v1.getParentFamilyPlanInfo': Icons.family_restroom,
        'abexperiment.v1.getExperimentsForListener': Icons.adb,
        'user.updateRemoteNotificationToken': Icons.edit_notifications,
        'browse.getMusicRecommendation': Icons.recommend,
        'collections.v7.getItems': Icons.video_collection,
        'downloads.v5.getItems': Icons.cloud_download,
        'feed.v1.getDirectory': Icons.explore,
        'catalog.v4.annotateObjects': Icons.music_video,
        'catalog.v4.getDetails': Icons.music_note,
        'contentservice.getcontent': Icons.playlist_play,
        'purchase.getInAppPurchaseProductsV2': Icons.attach_money,
        'station.createStation': Icons.radio_outlined,
        'station.getStation': Icons.radio,
        'interactiveradio.v1.getAvailableModesSimple': Icons.radio,
        'music.getSearchRecommendations': Icons.recommend_outlined,
        'ad.registerAd': Icons.ad_units,
        'sod.v3.search': Icons.search,
        'onDemand.getAudioPlaybackInfo': Icons.play_arrow_outlined,
        'playerstate.playlater.v1.get': Icons.watch_later,
        'user.getStationListChecksum': Icons.check_circle_outline,
        'playlists.v7.annotatePlaylists': Icons.featured_play_list_outlined,
        'playlists.v7.getTracks': Icons.featured_play_list,
        'aesop.v1.annotateObjects': Icons.book_outlined,
        'aesop.v1.getDetails': Icons.book,
        'collections.v7.removeItem': Icons.playlist_remove,
        'downloads.v5.removeItem': Icons.delete,
      }[method],
    );
  }
}
