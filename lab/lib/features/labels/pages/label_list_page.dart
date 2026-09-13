import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_page_kit/flutter_page_kit.dart';
import 'package:flutter_page_kit/flutter_page_kit_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_scale_kit/flutter_scale_kit.dart';

import '../../../core/app_providers.dart';
import '../../../core/failures/failure_text.dart';
import '../../../core/failures/field_error_text.dart';
import '../../../i18n/strings.g.dart';
import '../domain/label_model.dart';
import '../state/label_providers.dart';

@RoutePage()
class LabelListPage extends ConsumerStatefulWidget {
  const LabelListPage({super.key});

  @override
  ConsumerState<LabelListPage> createState() => _LabelListPageState();
}

class _LabelListPageState extends ConsumerState<LabelListPage>
    with PageBridge, PageData<LabelListPage> {
  @override
  get pageNavigatorProvider => navigatorProvider;

  @override
  get pageNoticesProvider => noticesProvider;

  late final name = text(validators: [Validators.required]);

  @override
  List<Validatable> get validated => [name];

  Future<void> _add() async {
    if (!await validateForm()) {
      notices.warn(t.validation.form);
      return;
    }
    await run(
      key: 'save',
      action: () async {
        final label = await ref.read(labelRepositoryProvider).create(
              LabelDraft(name: name.value.trim()),
            );
        ref.read(labelListProvider.notifier).upsert(label);
        name.controller.clear();
        showFieldErrors = false;
        notices.success(t.labels.saved);
      },
    );
    if (failure != null) {
      notices.showFailure(failure);
    }
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(labelListProvider);
    final saving = busy.of('save');

    return Scaffold(
      appBar: AppBar(title: Text(t.labels.title)),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: name.controller,
                    enabled: !saving,
                    decoration: InputDecoration(
                      labelText: t.labels.nameLabel,
                      errorText: showFieldErrors
                          ? fieldErrorText(name.errorCode)
                          : null,
                    ),
                    onSubmitted: saving ? null : (_) => _add(),
                  ),
                ),
                SizedBox(width: 12.w),
                FilledButton(
                  onPressed: saving ? null : _add,
                  child: saving
                      ? const LemsaLoader(size: 18)
                      : Text(t.labels.add),
                ),
              ],
            ),
          ),
          Expanded(
            child: AsyncView(
              value: async,
              error: (f) => Center(child: Text(failureText(f))),
              data: (state) {
                if (state.items.isEmpty) {
                  return Center(child: Text(t.labels.empty));
                }
                return ListView.builder(
                  itemCount: state.items.length,
                  itemBuilder: (context, index) {
                    final label = state.items[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: _parseColor(label.colorHex),
                        radius: 8,
                      ),
                      title: Text(label.name),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _parseColor(String hex) {
    final cleaned = hex.replaceFirst('#', '');
    final value = int.tryParse(cleaned, radix: 16) ?? 0x4A90A4;
    return Color(0xFF000000 | value);
  }
}
