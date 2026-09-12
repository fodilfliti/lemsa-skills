import 'dart:io';

import 'package:lab_cli/generate_core.dart';
import 'package:path/path.dart' as p;

Future<void> main(List<String> args) async {
  if (args.isEmpty) {
    _usage();
    exit(64);
  }

  final labRoot = p.normalize(p.join(Directory.current.path, '..', '..'));
  final cli = LabCliCore(labRoot: labRoot);
  final command = args.first;
  final rest = args.skip(1).toList();

  switch (command) {
    case 'create':
      stdout.writeln('Lab shell exists at $labRoot');
    case 'feature':
      final name = rest.isNotEmpty ? rest.first : 'tasks';
      await cli.scaffoldFeature(name);
      stdout.writeln('Scaffolded feature: $name');
    case 'scenario':
      final id = rest.isNotEmpty ? rest.first : 'S03';
      stdout.writeln('Scenario $id — read ${cli.scenarioSpecPath(id)}');
      stdout.writeln('Use bd to claim Lab $id issue');
    case 'adapter':
      final backend = rest.isNotEmpty ? rest.first : 'supabase';
      const feature = 'tasks';
      await cli.scaffoldAdapter(feature, backend);
      stdout.writeln('Adapter stub: ${cli.adapterFile(feature, backend)}');
    case 'rest':
      final feature = rest.isNotEmpty ? rest.first : 'tasks';
      await cli.scaffoldAdapter(feature, 'rest');
      stdout.writeln(cli.restScaffoldNote(feature));
    case 'link-kit':
      final kit = rest.isNotEmpty ? rest.first : 'lemsa_core_kit';
      stdout.writeln(
        'Add path dependency to ../$kit in lab/pubspec.yaml manually or via melos.',
      );
    default:
      stderr.writeln('Unknown command: $command');
      _usage();
      exit(64);
  }
}

void _usage() {
  stdout.writeln('''
Usage: dart run lab_cli:lab <command>

Commands:
  create              Verify lab shell
  feature <name>      Scaffold feature folders
  scenario <S0X>      Print scenario spec path + bd hint
  adapter <backend>   Scaffold task_source_<backend>.dart
  rest <feature>      Scaffold REST adapter files
  link-kit <package>  Hint for path dep to sibling kit
''');
}
