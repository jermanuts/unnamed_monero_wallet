import 'dart:convert';
import 'dart:io';

import 'package:anonero/tools/dirs.dart';
import 'package:anonero/tools/node.dart';
import 'package:mutex/mutex.dart';

final _proxyStoreMutex = Mutex();

class ProxyStore {
  ProxyStore({
    required this.address,
    required this.torPort,
    required this.i2pPort,
  });

  String address;
  int torPort;
  int i2pPort;

  Map<String, dynamic> toJson() {
    return {
      "_v": 0,
      "address": address,
      "torPort": torPort,
      "i2pPort": i2pPort,
    };
  }

  ProxyStore.fromJson(Map<String, dynamic> json)
      : address = json['address'] as String,
        torPort = json['torPort'] as int,
        i2pPort = json['i2pPort'] as int;

  static Future<ProxyStore> getProxy() async {
    await _proxyStoreMutex.acquire();
    final path = await getProxyStore();
    final file = File(path);
    if (!file.existsSync()) {
      file.writeAsStringSync(
        json.encode(
          ProxyStore(address: '127.0.0.1', torPort: 9050, i2pPort: 4447),
        ),
      );
    }
    final body = file.readAsStringSync();
    _proxyStoreMutex.release();
    return ProxyStore.fromJson(json.decode(body));
  }

  static Future<void> setProxy(ProxyStore proxy) async {
    await _proxyStoreMutex.acquire();
    final path = await getProxyStore();
    final file = File(path);
    file.writeAsStringSync(
      json.encode(proxy),
    );
    _proxyStoreMutex.release();
    return;
  }

  String getAddress(NodeNetwork nnet) {
    return switch (nnet) {
      NodeNetwork.clearnet => "",
      NodeNetwork.onion => "socks5://$address:$torPort",
      NodeNetwork.i2p => "socks5://$address:$i2pPort",
    };
  }
}