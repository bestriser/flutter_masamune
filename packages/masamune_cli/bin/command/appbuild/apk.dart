part of masamune_cli;

class AppBuildApkCliCommand extends CliCommand {
  const AppBuildApkCliCommand();

  @override
  String get description => "masamune.yamlで指定したbuildの情報をAndroid用のApkビルドを行います。";

  @override
  Future<void> exec(Map yaml, List<String> args) async {
    final bin = yaml.getAsMap("bin");
    final flutter = bin.get("flutter", "flutter");
    final generateProcess = await Process.start(
      flutter,
      [
        "build",
        "apk",
        "--dart-define=FLAVOR=prod",
        "--release",
      ],
      runInShell: true,
    );
    await generateProcess.print();
  }
}
