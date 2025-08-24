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
    bytes += generator.text("\n\n\n");
    bytes += generator.text("HENS PONSEL",
        styles: PosStyles(
          align: PosAlign.center,
          bold: true,
          height: PosTextSize.size3,
          width: PosTextSize.size3,
        ));
    bytes += generator.text("Jalan Sudirman No. 193",
        styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ));
    bytes += generator.text("Air Putih, Batu Bara",
        styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ));
    bytes += generator.text("Sumut 21256",
        styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ));
    bytes += generator.text(
      hr58(),
      styles: PosStyles(
        align: PosAlign.left,
        bold: true,
        width: PosTextSize.size1, // make sure it's normal width
        height: PosTextSize.size1,
      ),
    );

    // Title
    bytes += generator.text("Struk Penjualan",
        styles: PosStyles(
          align: PosAlign.center,
          bold: true,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ));
    bytes += generator.text(date, styles: PosStyles(align: PosAlign.center));
    bytes += generator.text('\n');

    // Items
    for (var item in items) {
      final List<Map<String, bool>> imeiList =
          List<Map<String, bool>>.from(item['imei']);

      final List<String> trueImeis = imeiList
          .where((map) => map.values.first == true)
          .map((map) => map.keys.first)
          .toList();
      bytes += generator.text(
        '${trueImeis.length} ${item['name']} ${item['color']} \n- ${trueImeis.join('\n- ')}',
        styles: PosStyles(align: PosAlign.left),
      );
      bytes += generator.text('\n');
    }

    bytes += generator.text(
      hr58(),
      styles: PosStyles(
        align: PosAlign.left,
        bold: true,
        width: PosTextSize.size1, // make sure it's normal width
        height: PosTextSize.size1,
      ),
    );

    // Total
    bytes += generator.text("TOTAL BAYAR: Rp $formattedPrice",
        styles: PosStyles(
          align: PosAlign.center, bold: true,
          width: PosTextSize.size2, // make sure it's normal width
          height: PosTextSize.size2,
        ));

    bytes += generator.text('\n');

    // Footer
    bytes += generator.text(
      "Simpan struk ini sebagai bukti pembayaran yang sah",
      styles: PosStyles(align: PosAlign.center),
    );

    bytes += generator.text("\n\n\n");
    bytes += generator.text('');

    await PrintBluetoothThermal.writeBytes(bytes);
  } else {
    throw ('Not permitted, please check settings');
  }
}
