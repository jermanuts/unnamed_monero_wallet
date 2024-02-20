import 'package:xmruw/pages/wallet/spend_confirm.dart';
import 'package:xmruw/pages/wallet/spend_screen.dart';
import 'package:xmruw/tools/format_monero.dart';
import 'package:xmruw/tools/monero/account_index.dart';
import 'package:xmruw/tools/show_alert.dart';
import 'package:xmruw/tools/wallet_ptr.dart';
import 'package:flutter/material.dart';
import 'package:monero/monero.dart';

class Output {
  Output({
    required this.amount,
    required this.hash,
    required this.keyImage,
    required this.value,
  });
  final int amount;
  final String hash;
  final String keyImage;
  final bool value;
}

class OutputsPage extends StatefulWidget {
  const OutputsPage({super.key});

  @override
  State<OutputsPage> createState() => _OutputsPageState();

  static void push(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) {
        return const OutputsPage();
      },
    ));
  }
}

class _OutputsPageState extends State<OutputsPage> {
  final coins = MONERO_Wallet_coins(walletPtr!);
  int count = 0;
  void _refresh() {
    MONERO_Coins_refresh(coins);
    setState(() {
      count = MONERO_Coins_count(coins);
    });
  }

  @override
  void initState() {
    _refresh();
    super.initState();
  }

  List<String> selectedKeyImages = [];
  List<OutputItem> _buildOutputs() {
    List<OutputItem> list = [];
    list.clear();
    for (var i = 0; i < count; i++) {
      final coin = MONERO_Coins_coin(coins, i);
      if (MONERO_CoinsInfo_spent(coin)) {
        continue;
      }
      if (MONERO_CoinsInfo_subaddrAccount(coin) != globalAccountIndex) {
        continue;
      }
      final keyImage = MONERO_CoinsInfo_keyImage(coin);
      list.add(
        OutputItem(
          output: Output(
            amount: MONERO_CoinsInfo_amount(coin),
            hash: MONERO_CoinsInfo_keyImage(coin),
            keyImage: keyImage,
            value: selectedKeyImages.contains(keyImage),
          ),
          id: i,
          triggerChange: (!MONERO_CoinsInfo_unlocked(coin) ||
                  MONERO_CoinsInfo_frozen(coin))
              ? null
              : () {
                  if (selectedKeyImages.contains(keyImage)) {
                    setState(() {
                      selectedKeyImages.removeWhere((elm) => elm == keyImage);
                    });
                  } else {
                    setState(() {
                      selectedKeyImages.add(keyImage);
                    });
                  }
                },
        ),
      );
    }
    return list;
  }

  int _amount() {
    int amount = 0;
    for (var i = 0; i < count; i++) {
      final coin = MONERO_Coins_coin(coins, i);
      final keyImage = MONERO_CoinsInfo_keyImage(coin);
      if (selectedKeyImages.contains(keyImage)) {
        amount += MONERO_CoinsInfo_amount(coin);
      }
    }
    return amount;
  }

  void _send() {
    SpendScreen.push(context, outputs: selectedKeyImages);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Coin control"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: _buildOutputs(),
        ),
      ),
      floatingActionButton: selectedKeyImages.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: _send,
              label: Text("${formatMonero(_amount())} XMR"),
              icon: const Icon(Icons.send),
            )
          : FloatingActionButton.extended(
              onPressed: _churn,
              label: const Text("Churn outputs"),
              icon: const Icon(Icons.merge),
            ),
    );
  }

  void _churn() {
    Alert(
      title: "Churning causes all your outputs to be merged into one "
          "most people do not want to churn unless some issues with spending "
          "occur. If you want to churn click next, otherwise cancel.",
      cancelable: true,
      callbackText: "Churn",
      callback: _doChurn,
    ).show(context);
  }

  void _doChurn() async {
    await SpendConfirm.push(
      context,
      TxRequest(
        address: MONERO_Wallet_address(
          walletPtr!,
          accountIndex: globalAccountIndex,
          addressIndex: MONERO_Wallet_numSubaddresses(walletPtr!,
              accountIndex: globalAccountIndex),
        ),
        amount: 0,
        notes: "Chruning self-spend transaction",
        isSweep: true,
        outputs: [],
      ),
    );
    if (!mounted) return;
    Navigator.of(context).pop();
  }
}

class OutputItem extends StatelessWidget {
  final int id;
  final Output output;
  final VoidCallback? triggerChange;
  const OutputItem({
    super.key,
    required this.output,
    required this.id,
    required this.triggerChange,
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: output.value,
      onChanged: triggerChange == null
          ? null
          : (bool? value) {
              triggerChange!();
            },
      contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      title: Row(
        children: [
          Expanded(
            child: Text(
              'OUTPUT #$id',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: Theme.of(context).colorScheme.primary),
            ),
          ),
          Text(
            formatMonero(output.amount),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ],
      ),
      subtitle: Text(
        output.hash,
      ),
    );
  }
}
