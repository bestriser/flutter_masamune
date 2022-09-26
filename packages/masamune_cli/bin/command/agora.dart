part of masamune_cli;

class AgoraCliCommand extends CliCommand {
  const AgoraCliCommand();

  @override
  String get description =>
      "masamune.yamlを元にAgora.ioの初期設定を行います。予めAgoraのプロジェクトを作成（AppID+Token）を作成`AppID`と`AppCertificate`を作成しておくのと`firebase`のコマンドを実行しておくこと、firebaseを`Blazeプラン`にしておくことが必要です。";

  @override
  Future<void> exec(Map yaml, List<String> args) async {
    final bin = yaml.getAsMap("bin");
    final agora = yaml.getAsMap("agora");
    final appId = agora.get("app_id", "");
    final appCertificate = agora.get("app_certificate", "");
    final expiration = agora["expiration"] as int? ?? 3600;
    final command = bin.get("firebase", "firebase");
    if (appId.isEmpty) {
      print("Api id is invalid.");
      return;
    }
    if (appCertificate.isEmpty) {
      print("Api certificate is invalid.");
      return;
    }
    currentFiles.forEach((file) {
      var text = File(file.path).readAsStringSync();
      text = text.replaceAll(
        "<!-- TODO_REPLACE_PERMISSION_READ_PHONE_STATE -->",
        "<uses-permission android:name=\"android.permission.READ_PHONE_STATE\" />",
      );
      text = text.replaceAll(
        "<!-- TODO_REPLACE_PERMISSION_RECORD_AUDIO -->",
        "<uses-permission android:name=\"android.permission.RECORD_AUDIO\" />",
      );
      text = text.replaceAll(
        "<!-- TODO_REPLACE_PERMISSION_CAMERA -->",
        "<uses-permission android:name=\"android.permission.CAMERA\" />",
      );
      text = text.replaceAll(
        "<!-- TODO_REPLACE_PERMISSION_MODIFY_AUDIO_SETTINGS -->",
        "<uses-permission android:name=\"android.permission.MODIFY_AUDIO_SETTINGS\" />",
      );
      text = text.replaceAll(
        "<!-- TODO_REPLACE_PERMISSION_ACCESS_NETWORK_STATE -->",
        "<uses-permission android:name=\"android.permission.ACCESS_NETWORK_STATE\" />",
      );
      text = text.replaceAll(
        "<!-- TODO_REPLACE_PERMISSION_BLUETOOTH -->",
        "<uses-permission android:name=\"android.permission.BLUETOOTH\" />",
      );
      text = text.replaceAll(
        "<!-- TODO_REPLACE_PERMISSION_ACCESS_WIFI_STATE -->",
        "<uses-permission android:name=\"android.permission.ACCESS_WIFI_STATE\" />",
      );
      text = text.replaceAll(
        "<!-- TODO_REPLACE_PERMISSION_READ_EXTERNAL_STORAGE -->",
        "<uses-permission android:name=\"android.permission.READ_EXTERNAL_STORAGE\" />",
      );
      text = text.replaceAll(
        "<!-- TODO_REPLACE_PERMISSION_WAKE_LOCK -->",
        "<uses-permission android:name=\"android.permission.WAKE_LOCK\" />",
      );
      text = text.replaceAll(
        "<!-- TODO_REPLACE_PERMISSION_READ_PRIVILEGED_PHONE_STATE -->",
        "<uses-permission android:name=\"android.permission.READ_PRIVILEGED_PHONE_STATE\" tools:ignore=\"ProtectedPermissions\" />",
      );
      text = text.replaceAll(
        "// TODO_AGORA_SERVER",
        "// [agora]\r\n    agora_token: \"./functions/agora/agora_token\",\r\n    agora_cloud_recording: \"./functions/agora/agora_cloud_recording\",\r\n",
      );
      File(file.path).writeAsStringSync(text);
    });
    final resultHooks = await Process.start(
      command,
      [
        "functions:config:set",
        "agora.app_id=$appId",
        "agora.app_certificate=$appCertificate",
        "agora.expiration=$expiration",
      ],
      runInShell: true,
      workingDirectory: "${Directory.current.path}/firebase",
    );
    await resultHooks.print();
    applyFunctionsTemplate();
    final resultHooksDeploy = await Process.start(
      command,
      [
        "deploy",
        "--only",
        "functions",
      ],
      runInShell: true,
      workingDirectory: "${Directory.current.path}/firebase",
    );
    await resultHooksDeploy.print();
  }
}
