import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:pandora_mitm/pandora_mitm.dart';

class PandoraMitmBloc extends Cubit<PandoraMitmState> {
  PandoraMitmBloc() : super(const PandoraMitmDisconnected());

  Future<void> connect({
    String host = 'localhost',
    int port = 8082,
  }) async {
    emit(const PandoraMitmConnecting());
    final pandoraMitm = BackgroundMitmproxyRiPandoraMitm()
      ..done.then((_) => emit(const PandoraMitmDisconnected()));
    try {
      await pandoraMitm.connect(host: host, port: port);
      emit(PandoraMitmConnected(pandoraMitm));
    } on IOException {
      emit(const PandoraMitmDisconnected(connectionFailed: true));
    }
  }

  Future<void> disconnect() async {
    assert(
      state is PandoraMitmConnected,
      'Cannot disconnect when not connected!',
    );
    final pandoraMitm = (state as PandoraMitmConnected).pandoraMitm;
    emit(PandoraMitmDisconnecting(pandoraMitm));
    await pandoraMitm.disconnect();
  }
}

abstract class PandoraMitmState {}

class PandoraMitmDisconnected implements PandoraMitmState {
  final bool connectionFailed;

  const PandoraMitmDisconnected({this.connectionFailed = false});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PandoraMitmDisconnected &&
          runtimeType == other.runtimeType &&
          connectionFailed == other.connectionFailed;

  @override
  int get hashCode => connectionFailed.hashCode;
}

class PandoraMitmConnecting implements PandoraMitmState {
  const PandoraMitmConnecting();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PandoraMitmConnecting && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

class PandoraMitmConnected implements PandoraMitmState {
  final PluginCapablePandoraMitm pandoraMitm;

  const PandoraMitmConnected(this.pandoraMitm);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PandoraMitmConnected &&
          runtimeType == other.runtimeType &&
          pandoraMitm == other.pandoraMitm;

  @override
  int get hashCode => pandoraMitm.hashCode;
}

class PandoraMitmDisconnecting implements PandoraMitmState {
  final PluginCapablePandoraMitm pandoraMitm;

  const PandoraMitmDisconnecting(this.pandoraMitm);
}
