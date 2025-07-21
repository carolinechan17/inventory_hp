import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_hp/bloc/delete_phone_item/delete_phone_bloc.dart';
import 'package:inventory_hp/bloc/delete_phone_item/delete_phone_event.dart';
import 'package:inventory_hp/bloc/fetch_phone_item/fetch_phone_bloc.dart';
import 'package:inventory_hp/bloc/fetch_phone_item/fetch_phone_event.dart';
import 'package:inventory_hp/bloc/update_phone_item/update_phone_bloc.dart';
import 'package:inventory_hp/bloc/update_phone_item/update_phone_event.dart';
import 'package:inventory_hp/component/color_sheet.dart';
import 'package:inventory_hp/component/custom_textformfield.dart';
import 'package:inventory_hp/data/model/phone_color.dart';
import 'package:inventory_hp/data/model/phone_item.dart';

class PhoneDetailPage extends StatefulWidget {
  PhoneDetailPage({
    super.key,
    required this.item,
  });

  PhoneItem item;

  @override
  State<PhoneDetailPage> createState() => _PhoneDetailPageState();
}

class _PhoneDetailPageState extends State<PhoneDetailPage> {
  final _formKey = GlobalKey<FormState>();
  int colorId = 0;
  TextEditingController imeiController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController colorController = TextEditingController();

  @override
  void initState() {
    super.initState();
    imeiController.text = widget.item.imei ?? '';
    nameController.text = widget.item.name ?? '';
    colorController.text = widget.item.color ?? '';
    colorId = widget.item.colorId ?? 0;
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
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.black12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextFormField(
                        controller: nameController,
                        title: 'Phone Series Name',
                        borderRadius: 8,
                        hintText: 'Input phone series here',
                        enabledBorder: false,
                        filled: true,
                        filledColor: Colors.black12,
                        validator: (value) {
                          return value!.isEmpty
                              ? 'Phone series name is required'
                              : null;
                        },
                      ),
                      CustomTextFormField(
                        controller: colorController,
                        readOnly: true,
                        title: 'Color',
                        borderRadius: 8,
                        hintText: 'Choose color',
                        enabledBorder: false,
                        filled: true,
                        filledColor: Colors.black12,
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.white,
                              builder: (BuildContext context) {
                                return ColorSheet();
                              }).then((value) {
                            final color = value as PhoneColor;
                            colorController.text = color.color ?? '';
                            colorId = color.id ?? 0;
                          });
                        },
                        validator: (value) {
                          return value!.isEmpty ? 'Color is required' : null;
                        },
                      ),
                      CustomTextFormField(
                        controller: imeiController,
                        title: 'IMEI',
                        borderRadius: 8,
                        hintText: 'Input IMEI here',
                        enabledBorder: false,
                        filled: true,
                        filledColor: Colors.black12,
                        maxLines: 10,
                        validator: (value) {
                          return value!.isEmpty ? 'IMEI is required' : null;
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
        'Detail',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      actions: [
        InkWell(
          onTap: () {
            if (!_formKey.currentState!.validate()) return;
            context.read<UpdatePhoneBloc>().add(UpdateOnePhone(
                    item: {
                      'id': widget.item.id,
                      'color': colorController.text,
                      'color_id': colorId,
                      'name': nameController.text,
                      'imei': imeiController.text,
                    },
                    onSuccess: () {
                      context.read<FetchPhoneBloc>().add(GetPhones());
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Berhasil mengedit data')));
                      Navigator.pop(context);
                    },
                    onFail: (err) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(err)));
                    }));
          },
          child: Text(
            'Simpan',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          width: 8,
        ),
        IconButton(
          onPressed: () {
            showMenu(
              color: Colors.white,
              context: context,
              position: RelativeRect.fromLTRB(
                  MediaQuery.of(context).size.width - 20,
                  12,
                  20,
                  MediaQuery.of(context).size.height - 12),
              items: [
                PopupMenuItem(
                  onTap: () {
                    context.read<DeletePhoneBloc>().add(DeletePhone(
                        id: widget.item.id ?? 0,
                        onSuccess: () {
                          context.read<FetchPhoneBloc>().add(GetPhones());
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Berhasil menghapus data')));
                          Navigator.pop(context);
                        },
                        onFail: (err) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text(err)));
                        }));
                  },
                  child: Text(
                    'Hapus',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            );
          },
          icon: Icon(CupertinoIcons.ellipsis_vertical),
        ),
        SizedBox(
          width: 16,
        )
      ],
    );
  }
}
