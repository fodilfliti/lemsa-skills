import 'package:test/test.dart';

import 'package:lab_cli/generate_core.dart';

void main() {
  test('adapter class names', () {
    const cli = LabCliCore(labRoot: '/tmp/lab');
    expect(cli.adapterFile('tasks', 'supabase'), contains('task_source_supabase'));
  });
}
