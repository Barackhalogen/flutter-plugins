// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:file/file.dart';
import 'package:platform/platform.dart';

import 'common/core.dart';
import 'common/package_looping_command.dart';
import 'common/plugin_utils.dart';
import 'common/process_runner.dart';
import 'common/repository_package.dart';

/// Key for APK.
const String _platformFlagApk = 'apk';

const int _exitNoPlatformFlags = 3;

// Flutter build types. These are the values passed to `flutter build <foo>`.
const String _flutterBuildTypeAndroid = 'apk';
const String _flutterBuildTypeIos = 'ios';
const String _flutterBuildTypeLinux = 'linux';
const String _flutterBuildTypeMacOS = 'macos';
const String _flutterBuildTypeWeb = 'web';
const String _flutterBuildTypeWin32 = 'windows';
const String _flutterBuildTypeWinUwp = 'winuwp';

/// A command to build the example applications for packages.
class BuildExamplesCommand extends PackageLoopingCommand {
  /// Creates an instance of the build command.
  BuildExamplesCommand(
    Directory packagesDir, {
    ProcessRunner processRunner = const ProcessRunner(),
    Platform platform = const LocalPlatform(),
  }) : super(packagesDir, processRunner: processRunner, platform: platform) {
    argParser.addFlag(kPlatformLinux);
    argParser.addFlag(kPlatformMacos);
    argParser.addFlag(kPlatformWeb);
    argParser.addFlag(kPlatformWindows);
    argParser.addFlag(kPlatformWinUwp);
    argParser.addFlag(kPlatformIos);
    argParser.addFlag(_platformFlagApk);
    argParser.addOption(
      kEnableExperiment,
      defaultsTo: '',
      help: 'Enables the given Dart SDK experiments.',
    );
  }

  // Maps the switch this command uses to identify a platform to information
  // about it.
  static final Map<String, _PlatformDetails> _platforms =
      <String, _PlatformDetails>{
    _platformFlagApk: const _PlatformDetails(
      'Android',
      pluginPlatform: kPlatformAndroid,
      flutterBuildType: _flutterBuildTypeAndroid,
    ),
    kPlatformIos: const _PlatformDetails(
      'iOS',
      pluginPlatform: kPlatformIos,
      flutterBuildType: _flutterBuildTypeIos,
      extraBuildFlags: <String>['--no-codesign'],
    ),
    kPlatformLinux: const _PlatformDetails(
      'Linux',
      pluginPlatform: kPlatformLinux,
      flutterBuildType: _flutterBuildTypeLinux,
    ),
    kPlatformMacos: const _PlatformDetails(
      'macOS',
      pluginPlatform: kPlatformMacos,
      flutterBuildType: _flutterBuildTypeMacOS,
    ),
    kPlatformWeb: const _PlatformDetails(
      'web',
      pluginPlatform: kPlatformWeb,
      flutterBuildType: _flutterBuildTypeWeb,
    ),
    kPlatformWindows: const _PlatformDetails(
      'Win32',
      pluginPlatform: kPlatformWindows,
      pluginPlatformVariant: platformVariantWin32,
      flutterBuildType: _flutterBuildTypeWin32,
    ),
    kPlatformWinUwp: const _PlatformDetails(
      'UWP',
      pluginPlatform: kPlatformWindows,
      pluginPlatformVariant: platformVariantWinUwp,
      flutterBuildType: _flutterBuildTypeWinUwp,
    ),
  };

  @override
  final String name = 'build-examples';

  @override
  final String description =
      'Builds all example apps (IPA for iOS and APK for Android).\n\n'
      'This command requires "flutter" to be in your path.';

  @override
  Future<void> initializeRun() async {
    final List<String> platformFlags = _platforms.keys.toList();
    platformFlags.sort();
    if (!platformFlags.any((String platform) => getBoolArg(platform))) {
      printError(
          'None of ${platformFlags.map((String platform) => '--$platform').join(', ')} '
          'were specified. At least one platform must be provided.');
      throw ToolExit(_exitNoPlatformFlags);
    }
  }

  @override
  Future<PackageResult> runForPackage(RepositoryPackage package) async {
    final List<String> errors = <String>[];

    final bool isPlugin = isFlutterPlugin(package);
    final Iterable<_PlatformDetails> requestedPlatforms = _platforms.entries
        .where(
            (MapEntry<String, _PlatformDetails> entry) => getBoolArg(entry.key))
        .map((MapEntry<String, _PlatformDetails> entry) => entry.value);

    // Platform support is checked at the package level for plugins; there is
    // no package-level platform information for non-plugin packages.
    final Set<_PlatformDetails> buildPlatforms = isPlugin
        ? requestedPlatforms
            .where((_PlatformDetails platform) => pluginSupportsPlatform(
                platform.pluginPlatform, package,
                variant: platform.pluginPlatformVariant))
            .toSet()
        : requestedPlatforms.toSet();
    if (buildPlatforms.isEmpty) {
      final String unsupported = requestedPlatforms.length == 1
          ? '${requestedPlatforms.first.label} is not supported'
          : 'None of [${requestedPlatforms.map((_PlatformDetails p) => p.label).join(', ')}] are supported';
      return PackageResult.skip('$unsupported by this plugin');
    }
    print('Building for: '
        '${buildPlatforms.map((_PlatformDetails platform) => platform.label).join(', ')}');

    final Set<_PlatformDetails> unsupportedPlatforms =
        requestedPlatforms.toSet().difference(buildPlatforms);
    if (unsupportedPlatforms.isNotEmpty) {
      final List<String> skippedPlatforms = unsupportedPlatforms
          .map((_PlatformDetails platform) => platform.label)
          .toList();
      skippedPlatforms.sort();
      print('Skipping unsupported platform(s): '
          '${skippedPlatforms.join(', ')}');
    }
    print('');

    bool builtSomething = false;
    for (final RepositoryPackage example in package.getExamples()) {
      final String packageName =
          getRelativePosixPath(example.directory, from: packagesDir);

      for (final _PlatformDetails platform in buildPlatforms) {
        // Repo policy is that a plugin must have examples configured for all
        // supported platforms. For packages, just log and skip any requested
        // platform that a package doesn't have set up.
        if (!isPlugin &&
            !example.directory
                .childDirectory(platform.flutterPlatformDirectory)
                .existsSync()) {
          print('Skipping ${platform.label} for $packageName; not supported.');
          continue;
        }

        builtSomething = true;

        String buildPlatform = platform.label;
        if (platform.label.toLowerCase() != platform.flutterBuildType) {
          buildPlatform += ' (${platform.flutterBuildType})';
        }
        print('\nBUILDING $packageName for $buildPlatform');
        if (!await _buildExample(example, platform.flutterBuildType,
            extraBuildFlags: platform.extraBuildFlags)) {
          errors.add('$packageName (${platform.label})');
        }
      }
    }

    if (!builtSomething) {
      if (isPlugin) {
        errors.add('No examples found');
      } else {
        return PackageResult.skip(
            'No examples found supporting requested platform(s).');
      }
    }

    return errors.isEmpty
        ? PackageResult.success()
        : PackageResult.fail(errors);
  }

  Future<bool> _buildExample(
    RepositoryPackage example,
    String flutterBuildType, {
    List<String> extraBuildFlags = const <String>[],
  }) async {
    final String enableExperiment = getStringArg(kEnableExperiment);

    // The UWP template is not yet stable, so the UWP directory
    // needs to be created on the fly with 'flutter create .'
    Directory? temporaryPlatformDirectory;
    if (flutterBuildType == _flutterBuildTypeWinUwp) {
      final Directory uwpDirectory = example.directory.childDirectory('winuwp');
      if (!uwpDirectory.existsSync()) {
        print('Creating temporary winuwp folder');
        final int exitCode = await processRunner.runAndStream(flutterCommand,
            <String>['create', '--platforms=$kPlatformWinUwp', '.'],
            workingDir: example.directory);
        if (exitCode == 0) {
          temporaryPlatformDirectory = uwpDirectory;
        }
      }
    }

    final int exitCode = await processRunner.runAndStream(
      flutterCommand,
      <String>[
        'build',
        flutterBuildType,
        ...extraBuildFlags,
        if (enableExperiment.isNotEmpty)
          '--enable-experiment=$enableExperiment',
      ],
      workingDir: example.directory,
    );

    if (temporaryPlatformDirectory != null &&
        temporaryPlatformDirectory.existsSync()) {
      print('Cleaning up ${temporaryPlatformDirectory.path}');
      temporaryPlatformDirectory.deleteSync(recursive: true);
    }

    return exitCode == 0;
  }
}

/// A collection of information related to a specific platform.
class _PlatformDetails {
  const _PlatformDetails(
    this.label, {
    required this.pluginPlatform,
    this.pluginPlatformVariant,
    required this.flutterBuildType,
    this.extraBuildFlags = const <String>[],
  });

  /// The name to use in output.
  final String label;

  /// The key in a pubspec's platform: entry.
  final String pluginPlatform;

  /// The supportedVariants key under a plugin's [pluginPlatform] entry, if
  /// applicable.
  final String? pluginPlatformVariant;

  /// The `flutter build` build type.
  final String flutterBuildType;

  /// The Flutter platform directory name.
  // In practice, this is the same as the plugin platform key for all platforms.
  // If that changes, this can be adjusted.
  String get flutterPlatformDirectory => pluginPlatform;

  /// Any extra flags to pass to `flutter build`.
  final List<String> extraBuildFlags;
}
