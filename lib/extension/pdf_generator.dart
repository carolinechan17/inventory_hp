import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';

String formatNumber(int number) {
  final str = number.toString();
  final buffer = StringBuffer();

  int count = 0;
  for (int i = str.length - 1; i >= 0; i--) {
    buffer.write(str[i]);
    count++;
    if (count % 3 == 0 && i != 0) {
      buffer.write('.');
    }
  }

  return buffer.toString().split('').reversed.join();
}

Future<Uint8List> buildReceiptPdf(
    List<Map<String, dynamic>> items, String price) async {
  final now = DateTime.now();
  final date = DateFormat('dd MMM yyyy, HH:mm').format(now);
  final formattedPrice = formatNumber(int.parse(price.isEmpty ? '0' : price));

  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.roll57,
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Center(
                child:
                    pw.Text("HENS PONSEL", style: pw.TextStyle(fontSize: 12))),
            pw.Center(child: pw.Text("Jalan Sudirman No. 193")),
            pw.Center(child: pw.Text("Air Putih, Batu Bara")),
            pw.Center(child: pw.Text("Sumut 21256")),
            pw.Divider(),
            pw.Center(
              child: pw.Text("Struk Penjualan",
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, fontSize: 12)),
            ),
            pw.Center(
              child: pw.Text(date,
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.normal, fontSize: 10)),
            ),
            pw.Text('\n'),
            ...items.map((item) => pw.Text('${item['name']} ${item['color']}',
                style: pw.TextStyle(
                    fontWeight: pw.FontWeight.normal,
                    fontSize: 10,
                    height: 12))),
            pw.Divider(),
            pw.Center(
                child: pw.Text("TOTAL BAYAR : Rp $formattedPrice",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
            pw.SizedBox(height: 10),
            pw.Center(
                child: pw.Text(
                    "Simpan struk ini sebagai bukti pembayaran yang sah",
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.normal,
                        fontSize: 10,
                        height: 12))),
          ],
        );
      },
    ),
  );

  return pdf.save();
}
