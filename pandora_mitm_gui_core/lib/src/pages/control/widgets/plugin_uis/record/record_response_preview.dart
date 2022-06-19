import 'package:flutter/material.dart';
import 'package:iapetus/iapetus.dart';
import 'package:pandora_mitm/pandora_mitm.dart';
import 'package:pandora_mitm_gui_core/src/pages/control/widgets/api/previews/error.dart';
import 'package:pandora_mitm_gui_core/src/plugins/record.dart';

Widget Function()? getResponsePreviewFactory(
  RecordPlugin plugin,
  PandoraMitmRecord record,
) {
  final apiResponse = record.response!.apiResponse;

  if (apiResponse is PandoraApiException) {
    return () => ErrorPreview(error: apiResponse);
  }

  switch (record.apiRequest.method) {
    default:
      return null;
  }
}
