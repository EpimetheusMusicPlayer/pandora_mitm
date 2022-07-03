import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class LogNotifier extends ChangeNotifier {
  late final StreamSubscription<LogRecord> _recordSubscription;
  final _records = <LogRecord>[];

  LogNotifier() {
    _recordSubscription = Logger.root.onRecord.listen((record) {
      _records.add(record);
      notifyListeners();
    });
  }

  List<LogRecord> get records => UnmodifiableListView(_records);

  @override
  void dispose() {
    _recordSubscription.cancel();
    super.dispose();
  }
}
