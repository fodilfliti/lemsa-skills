import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/state/session_provider.dart';

/// Notifies auto_route to re-run guards when [sessionProvider] changes.
class SessionReevaluate extends ChangeNotifier {
  void tick() => notifyListeners();
}

final sessionReevaluateProvider = Provider<SessionReevaluate>((ref) {
  final listenable = SessionReevaluate();
  ref.listen(sessionProvider, (_, __) => listenable.tick());
  ref.onDispose(listenable.dispose);
  return listenable;
});
