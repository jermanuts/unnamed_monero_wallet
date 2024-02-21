import 'dart:convert';
import 'dart:io';

import 'package:xmruw/pages/config/themes.dart';

late Config config;

class Config {
  static Config load(String confPath) {
    final config = Config(confPath);
    if (config.file.existsSync()) {
      try {
        return Config.fromJson(
            confPath, json.decode(config.file.readAsStringSync()));
      } catch (e) {
        print("Config.load: $e");
      }
    }
    return config;
  }

  Config(
    this.confPath, {
    this.disableProxy = false,
    this.theme = AppThemeEnum.orange,
    this.enableOpenAlias = true,
    this.enableAutoLock = false,
    this.enableBackgroundSync = false,
    this.enableBuiltInTor = true,
    this.routeClearnetThruTor = false,
    this.printStarts = false,
    this.showPerformanceOverlay = false,
    this.experimentalAccounts = false,
    this.fiatCurrency = "USD",
    this.enableExperiments = false,
    this.lastChangelogVersion = -1,
  });

  final String confPath;
  File get file => File(confPath);

  bool disableProxy;
  AppThemeEnum theme;
  bool enableOpenAlias;
  bool enableAutoLock;
  bool enableBackgroundSync;
  bool enableBuiltInTor;
  bool routeClearnetThruTor;
  bool printStarts;
  bool showPerformanceOverlay;
  bool experimentalAccounts;
  String fiatCurrency;
  bool enableExperiments;
  int lastChangelogVersion;
  void save() {
    file.writeAsString(json.encode(toJson()));
  }

  static Config fromJson(String confPath, Map<String, dynamic> json) {
    final c = Config(confPath);
    if (json['disableProxy'] is bool) {
      c.disableProxy = json['disableProxy'];
    }
    if (json['enableOpenAlias'] is bool) {
      c.enableOpenAlias = json["enableOpenAlias"];
    }
    if (json['enableAutoLock'] is bool) {
      c.enableAutoLock = json["enableAutoLock"];
    }
    if (json['enableBackgroundSync'] is bool) {
      c.enableBackgroundSync = json["enableBackgroundSync"];
    }
    if (json['enableBuiltInTor'] is bool) {
      c.enableBuiltInTor = json["enableBuiltInTor"];
    }
    if (json['routeClearnetThruTor'] is bool) {
      c.routeClearnetThruTor = json["routeClearnetThruTor"];
    }
    if (json['printStarts'] is bool) {
      c.printStarts = json["printStarts"];
    }
    if (json['showPerformanceOverlay'] is bool) {
      c.showPerformanceOverlay = json["showPerformanceOverlay"];
    }
    if (json['experimentalAccounts'] is bool) {
      c.experimentalAccounts = json["experimentalAccounts"];
    }
    if (json['fiatCurrency'] is bool) {
      c.fiatCurrency = json["fiatCurrency"];
    }
    if (json['enableExperiments'] is bool) {
      c.enableExperiments = json["enableExperiments"];
    }
    if (json['theme'] is bool) {
      c.theme = AppThemeEnum.values[(json["theme"] as int)];
    }
    if (json['lastChangelogVersion'] is bool) {
      c.lastChangelogVersion = json["lastChangelogVersion"];
    }
    return c;
  }

  Map<String, dynamic> toJson() {
    return {
      "disableProxy": disableProxy,
      "enableOpenAlias": enableOpenAlias,
      "enableAutoLock": enableAutoLock,
      "enableBackgroundSync": enableBackgroundSync,
      "enableBuiltInTor": enableBuiltInTor,
      "routeClearnetThruTor": routeClearnetThruTor,
      "printStarts": printStarts,
      "showPerformanceOverlay": showPerformanceOverlay,
      "experimentalAccounts": experimentalAccounts,
      "fiatCurrency": fiatCurrency,
      "enableExperiments": enableExperiments,
      "theme": theme.index,
      "lastChangelogVersion": lastChangelogVersion,
    };
  }
}
