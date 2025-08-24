import 'package:intl/intl.dart';
import 'package:inventory_hp/extension/string_extension.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';

Future<void> printToBluetooth(
    List<Map<String, dynamic>> items, String price) async {
  var bluetoothStatus = await Permission.bluetooth.request();

  if (bluetoothStatus.isGranted) {
    // Find printer
    final List<BluetoothInfo> devices =
        await PrintBluetoothThermal.pairedBluetooths;
    if (devices.isEmpty) {
      throw ("⚠️ No printer found");
    }

    final String mac = devices.first.macAdress;
    final bool connected =
        await PrintBluetoothThermal.connect(macPrinterAddress: mac);
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);
    List<int> bytes = [];

    final now = DateTime.now();
    final date = DateFormat('dd MMM yyyy, HH:mm').format(now);
    final formattedPrice = formatNumber(int.parse(price.isEmpty ? '0' : price));

    // Header
    bytes += generator.text("HENS PONSEL",
        styles: PosStyles(align: PosAlign.center, bold: true));
    bytes += generator.text("Jalan Sudirman No. 193",
        styles: PosStyles(align: PosAlign.center));
    bytes += generator.text("Air Putih, Batu Bara",
        styles: PosStyles(align: PosAlign.center));
    bytes += generator.text("Sumut 21256",
        styles: PosStyles(align: PosAlign.center));
    bytes += generator.hr();

    // Title
    bytes += generator.text("Struk Penjualan",
        styles: PosStyles(align: PosAlign.center, bold: true));
    bytes += generator.text(date, styles: PosStyles(align: PosAlign.center));

    bytes += generator.feed(1);

    // Items
    for (var item in items) {
      bytes += generator.text(
        "${item['name']} ${item['color']}",
        styles: PosStyles(align: PosAlign.left),
      );
    }

    bytes += generator.hr();

    // Total
    bytes += generator.text("TOTAL BAYAR : Rp $formattedPrice",
        styles: PosStyles(align: PosAlign.center, bold: true));

    bytes += generator.feed(1);

    // Footer
    bytes += generator.text(
      "Simpan struk ini sebagai bukti pembayaran yang sah",
      styles: PosStyles(align: PosAlign.center),
    );

    bytes += generator.feed(3);

    await PrintBluetoothThermal.writeBytes(bytes);
  } else {
    throw ('Not permitted, please check settings');
  }
}
