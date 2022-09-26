part of masamune_cli;

class AppBuildAabCliCommand extends CliCommand {
  const AppBuildAabCliCommand();

  @override
  String get description => "masamune.yamlで指定したbuildの情報をAndroid用のAABビルドを行います。";

  @override
  Future<void> exec(Map yaml, List<String> args) async {
    final bin = yaml.getAsMap("bin");
    final flutter = bin.get("flutter", "flutter");
    final generateProcess = await Process.start(
      flutter,
      [
        "build",
        "aab",
        "--dart-define=FLAVOR=prod",
        "--release",
      ],
      runInShell: true,
    );
    await generateProcess.print();
  }
}
