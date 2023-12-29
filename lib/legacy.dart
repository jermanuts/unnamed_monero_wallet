import 'package:anonero/tools/wallet_ptr.dart';
import 'package:flutter/material.dart';
import 'package:monero/monero.dart';
import 'package:anonero/tools/monero/subaddress_label.dart' as sl;

const ColorScheme colorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xffFF6600),
  onPrimary: Color(0xff000000),
  primaryContainer: Color(0xff297ea0),
  onPrimaryContainer: Color(0xffd9edf5),
  secondary: Color(0xffa1e9df),
  onSecondary: Color(0xff030303),
  secondaryContainer: Color(0xff005049),
  onSecondaryContainer: Color(0xffd0e3e1),
  tertiary: Color(0xffa0e5e5),
  onTertiary: Color(0xff181e1e),
  tertiaryContainer: Color(0xff004f50),
  onTertiaryContainer: Color(0xffd0e2e3),
  error: Color(0xffcf6679),
  onError: Color(0xff1e1214),
  errorContainer: Color(0xffb1384e),
  onErrorContainer: Color(0xfff9dde2),
  outline: Color(0xff959999),
  background: Color(0xff000000),
  onBackground: Color(0xffe3e4e4),
  surface: Color(0xff131516),
  onSurface: Color(0xfff1f1f1),
  surfaceVariant: Color(0xff15191b),
  onSurfaceVariant: Color(0xffe3e3e4),
  inverseSurface: Color(0xfffafcfd),
  onInverseSurface: Color(0xff0e0e0e),
  inversePrimary: Color(0xff355967),
  shadow: Color(0xff000000),
);

class Transaction {
  String get displayLabel => MONERO_TransactionInfo_label(_tx);
  String get subaddressLabel => sl.subaddressLabel(addressIndex);
  String get address => MONERO_Wallet_address(
        walletPtr!,
        accountIndex: 0,
        addressIndex: addressIndex,
      );
  String get description => MONERO_TransactionInfo_description(_tx);
  int get fee => MONERO_TransactionInfo_fee(_tx);
  int get confirmations => MONERO_TransactionInfo_confirmations(_tx);
  bool get isPending => MONERO_TransactionInfo_isPending(_tx);
  int get blockheight => MONERO_TransactionInfo_blockHeight(_tx);
  int get accountIndex => MONERO_TransactionInfo_subaddrAccount(_tx);
  String get paymentId => MONERO_TransactionInfo_paymentId(_tx);
  int get amount => MONERO_TransactionInfo_amount(_tx);
  bool get isSpend =>
      MONERO_TransactionInfo_direction(_tx) == TransactionInfo_Direction.Out;
  DateTime get timeStamp => DateTime.fromMillisecondsSinceEpoch(
        MONERO_TransactionInfo_timestamp(_tx) * 1000,
      );
  int get addressIndex => MONERO_TransactionInfo_subaddrAccount(_tx);
  bool get isConfirmed => !isPending;
  String get hash => MONERO_TransactionInfo_hash(_tx);
  // SubAddress? subAddress;
  // List<Transfer> transfers = [];
  final MONERO_TransactionHistory txHistoryPtr;
  final int txIndex;
  late final MONERO_TransactionInfo _tx =
      MONERO_TransactionHistory_transaction(txHistoryPtr, index: txIndex);
  Transaction({
    required this.txHistoryPtr,
    required this.txIndex,
  });
}

class SubAddress {
  int? accountIndex;
  String? address;
  String? squashedAddress;
  int? addressIndex;
  num? totalAmount;
  String? label;
  String? displayLabel;

  SubAddress(
      {this.accountIndex,
      this.address,
      this.squashedAddress,
      this.addressIndex,
      this.label});
}

class Transfer {
  num? amount;
  String? address;
}

const maxConfirms = 10;
