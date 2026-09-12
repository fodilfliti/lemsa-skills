import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lemsa_lab/stubs/core/disposables.dart';
import 'package:lemsa_lab/stubs/core/extensions.dart';
import 'package:lemsa_lab/stubs/page_kit.dart';

void main() {
  test('Disposables.dispose walks reverse registration order', () {
    final registry = Disposables();
    final order = <String>[];
    registry.keep(_Probe('a', order));
    registry.keep(_Probe('b', order));
    registry.keep(_Probe('c', order));
    expect(registry.debugLength, 3);
    registry.dispose();
    expect(registry.debugLength, 0);
    expect(order, ['c', 'b', 'a']);
    registry.dispose();
    expect(order, ['c', 'b', 'a']);
  });

  testWidgets('PageData keep() disposes on unmount in reverse order',
      (tester) async {
    final order = <String>[];
    await tester.pumpWidget(
      MaterialApp(home: _DisposeHost(order: order)),
    );
    await tester.pumpWidget(const SizedBox.shrink());
    expect(order, ['second', 'first']);
  });

  testWidgets('field factories + flag() checkbox + validateForm',
      (tester) async {
    final key = GlobalKey<_FactoryHostState>();
    final harness = await PageHarness.mount(
      pumpWidget: tester.pumpWidget,
      host: _FactoryHost(key: key),
      key: key,
    );
    final data = harness.controller;

    expect(data.name.value, 'Hi');
    expect(data.on.value, isTrue);
    expect(data.amount.value, 12.5);
    expect(data.due.value, DateTime(2026, 9, 12, 15, 30));
    expect(data.tags.value, ['a', 'b']);
    expect(data.extra.hasFocus, isFalse);
    expect(await data.validateForm(), isTrue);

    data.name.controller.text = '  ';
    expect(await data.validateForm(), isFalse);

    data.amount.controller.text = '3,14';
    expect(data.amount.value, 3.14);

    data.due.value = DateTime(2026, 1, 2, 8).toDate;
    expect(data.due.value, DateTime(2026, 1, 2));

    data.tags.value = ['x'];
    expect(data.tags.value, ['x']);

    await tester.tap(find.byType(Checkbox));
    await tester.pump();
    expect(data.on.value, isFalse);
  });

  testWidgets('busy.of keys are independent', (tester) async {
    final key = GlobalKey<_FactoryHostState>();
    final harness = await PageHarness.mount(
      pumpWidget: tester.pumpWidget,
      host: _FactoryHost(key: key),
      key: key,
    );
    final data = harness.controller;

    final save = data.run(
      key: 'save',
      action: () => Future<void>.delayed(const Duration(milliseconds: 50)),
    );
    await tester.pump();
    expect(data.busy.of('save'), isTrue);
    expect(data.busy.of('delete'), isFalse);
    expect(data.busy.any, isTrue);

    await tester.pump(const Duration(milliseconds: 50));
    await tester.pump();
    expect(data.busy.of('save'), isFalse);
    expect(data.busy.any, isFalse);
    await save;
  });
}

class _Probe extends ChangeNotifier {
  _Probe(this.id, this.order);

  final String id;
  final List<String> order;

  @override
  void dispose() {
    order.add(id);
    super.dispose();
  }
}

class _DisposeHost extends StatefulWidget {
  const _DisposeHost({required this.order});

  final List<String> order;

  @override
  State<_DisposeHost> createState() => _DisposeHostState();
}

class _DisposeHostState extends State<_DisposeHost>
    with PageData<_DisposeHost> {
  @override
  void initState() {
    super.initState();
    keep(_Probe('first', widget.order));
    keep(_Probe('second', widget.order));
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

class _FactoryHost extends StatefulWidget {
  const _FactoryHost({super.key});

  @override
  State<_FactoryHost> createState() => _FactoryHostState();
}

class _FactoryHostState extends State<_FactoryHost>
    with PageData<_FactoryHost> {
  late final name = text(initial: 'Hi');
  late final on = flag(true);
  late final amount = money(12.5);
  late final due = date(DateTime(2026, 9, 12, 15, 30));
  late final tags = items(['a', 'b']);
  late final extra = keep(FocusNode());

  @override
  List<Validatable> get validated => [name];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(controller: name.controller),
          Checkbox(
            value: on.value,
            onChanged: (value) => setState(() => on.value = value ?? false),
          ),
        ],
      ),
    );
  }
}
