import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class ChatSessionState extends Equatable {
  final bool loading;
  final bool init;
  final String error;
  final String docId;

  const ChatSessionState(
      {required this.error,
      required this.loading,
      required this.docId,
      required this.init});

  factory ChatSessionState.initial() {
    return const ChatSessionState(
        loading: false, error: "", docId: '', init: true);
  }

  ChatSessionState update({
    bool? loading,
    String? error,
    docId,
    init,
  }) {
    return ChatSessionState(
      loading: loading ?? this.loading,
      error: error ?? this.error,
      docId: docId ?? this.docId,
      init: init ?? this.init,
    );
  }

  @override
  String toString() => 'BloodRequestState { error: $error, loading: $loading }';

  @override
  List<Object> get props => [
        loading,
        error,
        docId,
        init,
      ];
}
