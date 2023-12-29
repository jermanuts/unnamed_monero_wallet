import 'package:anonero/pages/wallet/subaddress_details.dart';
import 'package:anonero/tools/format_monero.dart';
import 'package:anonero/tools/monero/subaddress_label.dart';
import 'package:anonero/tools/wallet_ptr.dart';
import 'package:flutter/material.dart';
import 'package:monero/monero.dart';

class SubAddressPage extends StatefulWidget {
  const SubAddressPage({super.key});

  @override
  State<SubAddressPage> createState() => _SubAddressPageState();

  static void push(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) {
        return const SubAddressPage();
      },
    ));
  }
}

class _SubAddressPageState extends State<SubAddressPage> {
  int addrCount = MONERO_Wallet_numSubaddresses(walletPtr!, accountIndex: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Subaddresses"),
        actions: [
          IconButton(onPressed: _addSubaddress, icon: const Icon(Icons.add))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
            children: List.generate(
          addrCount,
          (index) => SubaddressItem(
            subaddressId: index,
            label: subaddressLabel(index),
            received: -1,
            squashedAddress: MONERO_Wallet_address(
              walletPtr!,
              accountIndex: 0,
              addressIndex: index,
            ),
          ),
        ).reversed.toList()),
      ),
    );
  }

  void _addSubaddress() {
    setState(() {
      addrCount++;
    });
  }
}

class SubaddressItem extends StatelessWidget {
  final int subaddressId;
  final String label;
  final int received;
  final String squashedAddress;
  final bool shouldSquash;
  const SubaddressItem({
    super.key,
    required this.subaddressId,
    required this.label,
    required this.received,
    required this.squashedAddress,
    this.shouldSquash = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: !shouldSquash
          ? null
          : () =>
              SubaddressDetailsPage.push(context, subaddressId: subaddressId),
      contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      title: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: Theme.of(context).colorScheme.primary),
            ),
          ),
          Text(
            formatMonero(received),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ],
      ),
      subtitle: Text(
        squash(squashedAddress),
      ),
    );
  }

  String squash(String s) {
    if (s.length < 10 || !shouldSquash) return s;
    return "${s.substring(0, 5)}...${s.substring(s.length - 5)}";
  }
}
