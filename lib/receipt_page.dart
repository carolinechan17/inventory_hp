import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inventory_hp/component/custom_textformfield.dart';
import 'package:inventory_hp/extension/pdf_generator.dart';
import 'package:printing/printing.dart';

class ReceiptPage extends StatefulWidget {
  List<Map<String, dynamic>> soldItems;

  ReceiptPage({required this.soldItems});

  @override
  State<ReceiptPage> createState() => _ReceiptPageState();
}

class _ReceiptPageState extends State<ReceiptPage> {
  Timer? _debounce;
  TextEditingController priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    priceController.text = '0';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(context),
      body: Padding(
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
            Expanded(
                child: PdfPreview(
              canChangeOrientation: false,
              canDebug: false,
              build: (format) async =>
                  buildReceiptPdf(widget.soldItems, priceController.text),
            )),
          ],
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
