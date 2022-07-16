import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tic_tac_app/config.dart';
import 'package:tic_tac_app/models/update_info.dart';

Future<String> apkLocalPath() async {
  //final directory = Directory('/storage/emulated/0/Download');
  final directory = await getExternalStorageDirectory();
  log('get directory: $directory');
  return directory!.path;
}

class CheckForUpdatesSheet extends StatefulWidget {
  const CheckForUpdatesSheet({Key? key}) : super(key: key);

  @override
  _CheckForUpdatesSheetState createState() => _CheckForUpdatesSheetState();
}

class _CheckForUpdatesSheetState extends State<CheckForUpdatesSheet> {
  static const apkName = 'tic_tac_app.apk';
  late final String localVersion;
  String? error;
  UpdateInfo? updateInfo;
  bool downloading = false;
  Timer? closeTimer;
  int closeTimerValue = 5;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        localVersion = packageInfo.version;
      });
    });
    checkUpdate(context);
  }

  @override
  void dispose() {
    closeTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sheetHeight = MediaQuery.of(context).size.height * .4;
    return Container(
      padding: const EdgeInsets.all(16.0),
      height: sheetHeight,
      decoration: BoxDecoration(color: Theme.of(context).backgroundColor),
      child: SingleChildScrollView(
        child: Builder(
          builder: (context) {
            if (downloading) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'assets/lottie/downloading.json',
                    width: sheetHeight - 100,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Скачивание...",
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
                  ),
                ],
              );
            }
            if (updateInfo == null && error == null) {
              return Column(
                children: [
                  Lottie.asset(
                    'assets/lottie/request_loading.json',
                    width: sheetHeight - 100,
                  ),
                  const Text(
                    "Проверка наличия обновлений",
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
                  ),
                ],
              );
            } else if (error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      'assets/lottie/robot_error.json',
                      width: sheetHeight - 100,
                    ),
                    Text(
                      error!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Builder(builder: (context) {
                if (localVersion == updateInfo!.version) {
                  return SizedBox(
                    height: sheetHeight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Установлена акутуальная версия приложения",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 25),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .7,
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text("Закрыть $closeTimerValue"),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "Найдено обновление",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 10),
                          FaIcon(FontAwesomeIcons.exclamation),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "Установленная версия: $localVersion",
                        style: const TextStyle(
                          fontSize: 17.0,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "Актуальная версия: ${updateInfo!.version}",
                        style: const TextStyle(
                          fontSize: 17.0,
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (updateInfo!.corrected.isNotEmpty) ...[
                        const Text(
                          "Изменено:",
                          style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ...updateInfo!.corrected
                            .map((correctedPosition) => Text(
                                  '- $correctedPosition',
                                  style: const TextStyle(fontSize: 17.0),
                                ))
                            .toList(),
                        const SizedBox(height: 10),
                      ],
                      if (updateInfo!.added.isNotEmpty) ...[
                        const Text(
                          "Добавлено:",
                          style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ...updateInfo!.added
                            .map((addedPosition) => Text(
                                  '- $addedPosition',
                                  style: const TextStyle(fontSize: 17.0),
                                ))
                            .toList(),
                        const SizedBox(height: 10),
                      ],
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .7,
                        child: ElevatedButton(
                          onPressed: () async {
                            await doUpdate(updateInfo!.downloadUrl);
                          },
                          child: const Text("Обновить"),
                        ),
                      ),
                    ],
                  );
                }
              });
            }
          },
        ),
      ),
    );
  }

  /// Проверяем обновления
  Future<void> checkUpdate(BuildContext context) async {
    if (Platform.isAndroid) {
      try {
        final response = await http.get(Uri.parse(Config.checkUpdatesUrl));
        final jsonResponse = json.decode(response.body);
        if (response.statusCode == 200) {
          setState(() {
            updateInfo = UpdateInfo.fromJson(jsonResponse);
          });
          if (localVersion == updateInfo!.version) {
            closeTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
              setState(() {
                closeTimerValue--;
              });
              if (closeTimerValue == 0) {
                Navigator.pop(context);
              }
            });
          }
        } else {
          log('error on check update request with status code: ${response.statusCode}');
          setState(() {
            error =
                "При запросе обновлений произшла ошибка, код ошибки: ${response.statusCode}";
          });
        }
      } catch (err) {
        log('error on check update request: $err');
        setState(() {
          error = "При проверке обновлений произошла какая-то ошибка";
        });
      }
    }
  }

  /// 3. Выполните операцию обновления
  doUpdate(String url) async {
    var per = await checkPermission();
    if (!per) {
      return null;
    }
    executeDownload(url);
  }

  Future<bool> checkPermission() async {
    PermissionStatus storageStatus = await Permission.storage.status;
    log('storage status: $storageStatus');

    PermissionStatus installStatus =
        await Permission.requestInstallPackages.status;
    log('storage status: $installStatus');

    if (installStatus != PermissionStatus.granted) {
      if (await Permission.requestInstallPackages.request().isDenied) {
        return false;
      }
    }

    if (storageStatus != PermissionStatus.granted) {
      if (await Permission.storage.request().isGranted) {
        return true;
      } else {
        return false;
      }
    }
    return true;
  }

  Future<void> executeDownload(String url) async {
    // путь к хранилищу apk
    final path = await apkLocalPath();
    log(path);
    File file = File(path + '/' + apkName);
    try {
      if (await file.exists()) await file.delete();
    } catch (err) {
      log('error on delete old apk: $err');
    }

    setState(() {
      downloading = true;
    });

    await FlutterDownloader.enqueue(
      url: url,
      savedDir: path,
      fileName: apkName,
      showNotification: true,
      openFileFromNotification: true,
      //saveInPublicStorage: true,
    );
  }
}
