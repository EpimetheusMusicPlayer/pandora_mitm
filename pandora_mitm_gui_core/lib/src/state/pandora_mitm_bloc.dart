import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pandora_mitm/pandora_mitm.dart';

part 'pandora_mitm_bloc.freezed.dart';

class PandoraMitmBloc extends Cubit<PandoraMitmState> {
  PandoraMitmBloc() : super(const PandoraMitmState.disconnected());

  Future<void> connect({
    String host = 'localhost',
    int port = 8082,
  }) async {
    emit(const PandoraMitmState.connecting());
    final pandoraMitm = BackgroundMitmproxyRiPandoraMitm()
      ..done.then((_) => emit(const PandoraMitmState.disconnected()));
    try {
      await pandoraMitm.connect(host: host, port: port);
      emit(PandoraMitmState.connected(pandoraMitm));
    } on IOException {
      emit(const PandoraMitmState.connectionFailed());
    }
  }

  Future<void> disconnect() async {
    assert(
      state is ConnectedPandoraMitmState,
      'Cannot disconnect when not connected!',
    );
    final pandoraMitm = (state as ConnectedPandoraMitmState).pandoraMitm;
    emit(const PandoraMitmState.disconnecting());
    await pandoraMitm.disconnect();
  }
}

@freezed
class PandoraMitmState with _$PandoraMitmState {
  const factory PandoraMitmState.disconnected() = DisconnectedPandoraMitmState;

  const factory PandoraMitmState.connecting() = ConnectingPandoraMitmState;

  const factory PandoraMitmState.connected(
    PandoraMitm pandoraMitm,
  ) = ConnectedPandoraMitmState;

  const factory PandoraMitmState.disconnecting() =
      DisconnectingPandoraMitmState;

  const factory PandoraMitmState.connectionFailed() =
      ConnectionFailedPandoraMitmState;
}
