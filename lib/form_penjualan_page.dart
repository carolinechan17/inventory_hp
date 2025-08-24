import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_hp/bloc/fetch_phone_item/fetch_phone_bloc.dart';
import 'package:inventory_hp/bloc/fetch_phone_item/fetch_phone_event.dart';
import 'package:inventory_hp/bloc/update_phone_item/update_phone_bloc.dart';
import 'package:inventory_hp/bloc/update_phone_item/update_phone_event.dart';
import 'package:inventory_hp/component/custom_textformfield.dart';
import 'package:inventory_hp/component/phone_sheet.dart';
import 'package:inventory_hp/data/model/phone_item.dart';
import 'package:inventory_hp/receipt_page.dart';

class FormPenjualanPage extends StatefulWidget {
  FormPenjualanPage({super.key});

  @override
  State<FormPenjualanPage> createState() => _FormPenjualanPageState();
}

class _FormPenjualanPageState extends State<FormPenjualanPage> {
  final _formKey = GlobalKey<FormState>();
  int itemCount = 1;
  List<int> colorIds = [0];
  List<int> phoneIds = [0];
  List<List<Map<String, bool>>> imei = [[]];
  List<TextEditingController> nameControllers = [TextEditingController()];
  List<TextEditingController> colorControllers = [TextEditingController()];

  @override
  void initState() {
    super.initState();
    itemCount = 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(context),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                for (int i = 0; i < itemCount; i++) itemForm(i),
                InkWell(
                  onTap: () {
                    setState(() {
                      nameControllers.add(TextEditingController());
                      colorControllers.add(TextEditingController());
                      imei.add([]);
                      colorIds.add(0);
                      phoneIds.add(0);
                      itemCount += 1;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'Click to add more item',
                      style: TextStyle(
                          color: Colors.indigoAccent,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget itemForm(int index) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.black12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextFormField(
                controller: nameControllers[index],
                title: 'Phone Series Name',
                borderRadius: 8,
                hintText: 'Input phone series here',
                enabledBorder: false,
                filled: true,
                filledColor: Colors.black12,
                readOnly: true,
                validator: (value) {
                  return value!.isEmpty ? 'Phone series is required' : null;
                },
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.white,
                      builder: (BuildContext context) {
                        return PhoneSheet();
                      }).then((value) {
                    setState(() {
                      final phone = value as PhoneItem;
                      nameControllers[index].text = phone.name ?? '';
                      colorControllers[index].text = phone.color ?? '';
                      colorIds[index] = phone.colorId ?? 0;
                      phoneIds[index] = phone.id ?? 0;
                      final imeis = phone.imei!.split(',');
                      imei[index] = imeis.map((item) => {item: false}).toList();
                    });
                  });
                },
              ),
              CustomTextFormField(
                controller: colorControllers[index],
                readOnly: true,
                title: 'Color',
                borderRadius: 8,
                hintText: 'Input color here',
                enabledBorder: false,
                filled: true,
                filledColor: Colors.black12,
                validator: (value) {
                  return value!.isEmpty ? 'Color is required' : null;
                },
              ),
              if (imei.length > index &&
                  imei.isNotEmpty &&
                  imei[index].isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'IMEI',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              if (imei.length > index &&
                  imei.isNotEmpty &&
                  imei[index].isNotEmpty)
                ...imei[index].map((mapItem) {
                  final key = mapItem.keys.first;
                  final value = mapItem.values.first;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          mapItem[key] = !value;
                        });
                      },
                      child: Row(
                        children: [
                          Icon(
                            !value
                                ? CupertinoIcons.square
                                : CupertinoIcons.checkmark_square_fill,
                            size: 28,
                            color: !value ? Colors.grey : Colors.indigo,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            key.trim(),
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 16),
                          )
                        ],
                      ),
                    ),
                  );
                }),
            ],
          ),
        ),
        if (index != 0)
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              onPressed: () {
                setState(() {
                  itemCount -= 1;
                  nameControllers.removeAt(index);
                  colorControllers.removeAt(index);
                  imei.removeAt(index);
                  colorIds.removeAt(index);
                  phoneIds.removeAt(index);
                });
              },
              icon: Icon(
                CupertinoIcons.trash_circle,
                color: Colors.red,
                size: 32,
              ),
            ),
          )
      ],
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
        'Form Penjualan',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      actions: [
        InkWell(
          onTap: () {
            if (!_formKey.currentState!.validate()) return;
            List<Map<String, dynamic>> items = [];
            for (int i = 0; i < itemCount; i++) {
              items.add({
                'id': phoneIds[i],
                'color': colorControllers[i].text,
                'color_id': colorIds[i],
                'name': nameControllers[i].text,
                'imei': imei[i],
              });
            }
            // context.read<UpdatePhoneBloc>().add(UpdatePhone(
            //     items: items,
            //     onSuccess: () {
            //       context.read<FetchPhoneBloc>().add(GetPhones());
            //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            //           content: Text('Berhasil menyimpan data penjualan')));
            //       Navigator.of(context).push(MaterialPageRoute(
            //           builder: (context) => ReceiptPage(
            //                 soldItems: items,
            //               )));
            //     },
            //     onFail: (err) {
            //       ScaffoldMessenger.of(context)
            //           .showSnackBar(SnackBar(content: Text(err)));
            //     }));
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ReceiptPage(
                      soldItems: items,
                    )));
          },
          child: Text(
            'Simpan',
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
