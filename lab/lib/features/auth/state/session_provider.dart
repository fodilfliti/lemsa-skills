import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/lab_session.dart';

class SessionNotifier extends Notifier<LabSession?> {
  @override
  LabSession? build() => null;

  void signIn(String email) {
    state = LabSession(email: email.trim());
  }

  void signOut() {
    state = null;
  }
}

final sessionProvider =
    NotifierProvider<SessionNotifier, LabSession?>(SessionNotifier.new);
