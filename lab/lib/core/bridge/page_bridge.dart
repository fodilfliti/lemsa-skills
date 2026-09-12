import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app_providers.dart';
import '../../stubs/notices.dart';
import '../../stubs/page_navigator.dart';

/// Default `nav` + `notices` wiring for controller-backed pages.
///
/// Mix on [ConsumerState] before feature `*FormData` mixins — satisfies
/// [PageNavigator] / [Notices] without repeating provider lines.
mixin PageBridge<W extends ConsumerStatefulWidget> on ConsumerState<W> {
  PageNavigator get nav => ref.read(navigatorProvider);

  Notices get notices => ref.read(noticesProvider);
}
