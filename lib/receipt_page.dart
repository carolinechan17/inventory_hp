import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_printer/flutter_bluetooth_printer.dart';
import 'package:intl/intl.dart';
import 'package:inventory_hp/component/custom_textformfield.dart';
import 'package:inventory_hp/extension/string_extension.dart';

class ReceiptPage extends StatefulWidget {
  final List<Map<String, dynamic>> soldItems;

  const ReceiptPage({super.key, required this.soldItems});

  @override
  State<ReceiptPage> createState() => _ReceiptPageState();
}

class _ReceiptPageState extends State<ReceiptPage> {
  Timer? _debounce;
  TextEditingController priceController = TextEditingController();
  ReceiptController? controller;

  @override
  void initState() {
    super.initState();
    priceController.text = '0';
  }

  String getDateNow() {
    final now = DateTime.now();
    final date = DateFormat('dd MMM yyyy, HH:mm').format(now);
    return date;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          child: Column(
            children: [
              CustomTextFormField(
                keyboardType: TextInputType.number,
                controller: priceController,
                title: 'Price',
                borderRadius: 8,
                hintText: 'Input price here',
                enabledBorder: false,
                filled: true,
                filledColor: Colors.black12,
                onChanged: (str) {
                  if (_debounce?.isActive ?? false) _debounce!.cancel();

                  _debounce = Timer(const Duration(milliseconds: 500), () {
                    setState(() {
                      priceController.text = str;
                    });
                  });
                },
                validator: (value) {
                  return value!.isEmpty ? 'Price is required' : null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              Receipt(
                builder: (context) => Column(children: [
                  SizedBox(height: 40),
                  Text('HENS PONSEL',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  Text('Jalan Sudirman No.193'),
                  Text('Air Putih, Batu Bara'),
                  Text('Sumut 21256'),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Divider(
                      thickness: 4,
                      color: Colors.black,
                    ),
                  ),
                  Text('Struk Penjualan', style: TextStyle(fontSize: 20)),
                  Text(getDateNow(), style: TextStyle(fontSize: 20)),
                  SizedBox(height: 24),
                  ...widget.soldItems.map((item) {
                    final List<Map<String, bool>> imeiList =
                        List<Map<String, bool>>.from(item['imei']);

                    final List<String> trueImeis = imeiList
                        .where((map) => map.values.first == true)
                        .map((map) => map.keys.first)
                        .toList();
                    return Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                '${trueImeis.length} ${item['name']} ${item['color']}',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              ...trueImeis.map((imei) => Text(
                                    '- $imei',
                                    style: TextStyle(fontSize: 20, height: 2),
                                  )),
                            ],
                          ),
                        ));
                  }),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Divider(
                      thickness: 4,
                      color: Colors.black,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'TOTAL BAYAR: Rp${formatNumber(int.parse(priceController.text.isEmpty ? '0' : priceController.text))}',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Barang yang sudah dibeli tidak dapat dikembalikan",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Simpan struk ini sebagai bukti pembayaran yang sah",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Facebook: Hens Phonsel',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    '082164267722',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "**Terima kasih**",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 40),
                ]),
                onInitialized: (controller) {
                  this.controller = controller;
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: InkWell(
          onTap: () async {
            final address = await FlutterBluetoothPrinter.selectDevice(context);
            if (address != null) {
              await controller?.print(
                  address: address.address, keepConnected: true, addFeeds: 3);
            } else {
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  margin: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height - 100,
                      left: 10,
                      right: 10),
                  behavior: SnackBarBehavior.floating,
                  content: Text('Unable to find printer')));
            }
          },
          child: Container(
            width: double.infinity,
            height: 48,
            padding: EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
                color: Colors.indigo, borderRadius: BorderRadius.circular(8)),
            alignment: Alignment.center,
            child: Text('Select Printer & Print',
                style: TextStyle(color: Colors.white, fontSize: 18)),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.indigo,
      foregroundColor: Colors.white,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(CupertinoIcons.arrow_left),
      ),
      title: Text(
        'Struk',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      actions: [
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Text(
            'Selesai',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          width: 16,
        )
      ],
    );
  }
}
