import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:inventory_hp/bloc/add_phone_item/add_phone_bloc.dart';
import 'package:inventory_hp/bloc/add_phone_item/add_phone_event.dart';
import 'package:inventory_hp/bloc/fetch_phone_item/fetch_phone_bloc.dart';
import 'package:inventory_hp/bloc/fetch_phone_item/fetch_phone_event.dart';
import 'package:inventory_hp/camera_scanner_page.dart';
import 'package:inventory_hp/component/color_sheet.dart';
import 'package:inventory_hp/component/custom_textformfield.dart';
import 'package:inventory_hp/data/model/phone_color.dart';
import 'package:inventory_hp/data/model/phone_item.dart';

class FormPembelianPage extends StatefulWidget {
  const FormPembelianPage({super.key});

  @override
  State<FormPembelianPage> createState() => _FormPembelianPageState();
}

class _FormPembelianPageState extends State<FormPembelianPage> {
  final _formKey = GlobalKey<FormState>();
  int itemCount = 1;
  List<int> colorIds = [0];
  List<int> phoneIds = [0];
  List<TextEditingController> nameControllers = [TextEditingController()];
  List<TextEditingController> colorControllers = [TextEditingController()];
  List<TextEditingController> imeiControllers = [TextEditingController()];
  List<SuggestionsController<PhoneItem>> suggestionsControllers = [
    SuggestionsController(),
  ];

  @override
  void initState() {
    super.initState();
    itemCount = 1;
  }

  List<PhoneItem> searchItem(String searchQuery) {
    if (searchQuery.isEmpty) return [];

    final item = context.read<FetchPhoneBloc>().state.items;
    List<PhoneItem> result = item.where((item) {
      final query = searchQuery.trim().toLowerCase();
      final nameMatches = item.name?.toLowerCase().contains(query) ?? false;
      final colorMatches = item.color?.toLowerCase().contains(query) ?? false;
      return nameMatches || colorMatches;
    }).toList();

    return result;
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
                      imeiControllers.add(TextEditingController());
                      suggestionsControllers.add(SuggestionsController());
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
          margin: const EdgeInsets.only(bottom: 24),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.black12)),
          child: Column(
            children: [
              TypeAheadField<PhoneItem>(
                suggestionsController: suggestionsControllers[index],
                hideOnEmpty: true,
                builder: (context, controller, focusNode) {
                  return CustomTextFormField(
                    controller: controller,
                    title: 'Phone Series Name',
                    borderRadius: 8,
                    hintText: 'Input phone series here',
                    enabledBorder: false,
                    filled: true,
                    filledColor: Colors.black12,
                    focusNode: focusNode,
                    validator: (value) {
                      return value!.isEmpty
                          ? 'Phone series name is required'
                          : null;
                    },
                  );
                },
                itemBuilder: (context, item) {
                  return Padding(
                    padding:
                        const EdgeInsetsDirectional.symmetric(horizontal: 4),
                    child: ListTile(
                      tileColor: Colors.white,
                      title: Text(
                        '${item.name} - ${item.color}',
                      ),
                    ),
                  );
                },
                onSelected: (suggestion) {
                  setState(() {
                    nameControllers[index].text = suggestion.name ?? '';
                    colorControllers[index].text = suggestion.color ?? '';
                    imeiControllers[index].text = suggestion.imei ?? '';
                    colorIds[index] = suggestion.colorId ?? 0;
                    phoneIds[index] = suggestion.id ?? 0;
                  });
                },
                suggestionsCallback: (pattern) async {
                  return searchItem(pattern);
                },
                decorationBuilder: (context, child) {
                  return Material(
                    type: MaterialType.card,
                    elevation: 4,
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    child: child,
                  );
                },
                controller: nameControllers[index],
              ),
              CustomTextFormField(
                controller: colorControllers[index],
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
                    colorControllers[index].text = color.color ?? '';
                    colorIds[index] = color.id ?? 0;
                  });
                },
                validator: (value) {
                  return value!.isEmpty ? 'Color is required' : null;
                },
              ),
              CustomTextFormField(
                controller: imeiControllers[index],
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
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: InkWell(
                  onTap: () async {
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                            builder: (context) => CameraScannerPage()))
                        .then((value) {
                      if (value != null) {
                        setState(() {
                          if (imeiControllers[index].text.isEmpty) {
                            imeiControllers[index].text = value;
                          } else {
                            imeiControllers[index].text =
                                '${imeiControllers[index].text}, $value';
                          }
                        });
                      }
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    height: 48,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                        color: Colors.indigo,
                        borderRadius: BorderRadius.circular(8)),
                    alignment: Alignment.center,
                    child: Text('Scan IMEI',
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                ),
              ),
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
                  imeiControllers.removeAt(index);
                  suggestionsControllers.removeAt(index);
                  phoneIds.removeAt(index);
                  colorIds.removeAt(index);
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
        'Form Pembelian',
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
                'imei': imeiControllers[i].text,
              });
            }
            context.read<AddPhoneBloc>().add(AddPhone(
                items: items,
                onSuccess: () {
                  context.read<FetchPhoneBloc>().add(GetPhones());
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Berhasil melakukan update data')));
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
          width: 16,
        )
      ],
    );
  }
}
