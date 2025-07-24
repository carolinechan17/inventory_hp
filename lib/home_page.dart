import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_hp/bloc/fetch_color/fetch_color_bloc.dart';
import 'package:inventory_hp/bloc/fetch_color/fetch_color_event.dart';
import 'package:inventory_hp/bloc/fetch_phone_item/fetch_phone_bloc.dart';
import 'package:inventory_hp/bloc/fetch_phone_item/fetch_phone_event.dart';
import 'package:inventory_hp/bloc/fetch_phone_item/fetch_phone_state.dart';
import 'package:inventory_hp/component/custom_textformfield.dart';
import 'package:inventory_hp/component/stock_cell.dart';
import 'package:inventory_hp/form_pembelian_page.dart';
import 'package:inventory_hp/form_penjualan_page.dart';
import 'package:inventory_hp/phone_detail_page.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Timer? _debounce;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchColor();
    fetchPhoneItem();
  }

  void fetchColor() {
    context.read<FetchColorBloc>().add(GetColors());
  }

  void fetchPhoneItem() {
    context.read<FetchPhoneBloc>().add(GetPhones());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(context),
      body: BlocConsumer<FetchPhoneBloc, FetchPhoneState>(
          listener: (context, state) {
        if (!state.isUpdating) {
          setState(() {});
        }
        if (state.isSuccess) {
          setState(() {});
        }
      }, builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          child: Column(
            children: [
              CustomTextFormField(
                controller: searchController,
                borderRadius: 8,
                hintText: 'Cari disini...',
                title: '',
                borderColor: Colors.indigo,
                prefixIcon: Icon(CupertinoIcons.search),
                onChanged: (value) {
                  if (_debounce?.isActive ?? false) _debounce!.cancel();

                  _debounce = Timer(const Duration(milliseconds: 500), () {
                    context
                        .read<FetchPhoneBloc>()
                        .add(SearchPhones(query: searchController.text));
                  });
                },
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      searchController.text = '';
                    });
                  },
                  icon: Icon(CupertinoIcons.xmark_circle_fill),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Expanded(
                child: state.searchResults.isNotEmpty
                    ? ListView.builder(
                        itemCount: state.searchResults.length,
                        itemBuilder: (context, i) {
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => PhoneDetailPage(
                                        item: state.searchResults[i],
                                      )));
                            },
                            child: StockCell(
                              item: state.searchResults[i],
                            ),
                          );
                        },
                      )
                    : state.items.isNotEmpty
                        ? ListView.builder(
                            itemCount: state.items.length,
                            itemBuilder: (context, i) {
                              return InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => PhoneDetailPage(
                                            item: state.items[i],
                                          )));
                                },
                                child: StockCell(
                                  item: state.items[i],
                                ),
                              );
                            },
                          )
                        : Center(
                            child: Column(
                              children: [
                                const Spacer(),
                                Icon(
                                  CupertinoIcons.cube_box,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                                Text(
                                  'Belum ada stock',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const Spacer(),
                              ],
                            ),
                          ),
              )
            ],
          ),
        );
      }),
    );
  }

  PreferredSizeWidget appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.indigo,
      foregroundColor: Colors.white,
      title: Text(
        'Inventory Handphone',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      actions: [
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
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => FormPembelianPage()));
                    },
                    child: Text(
                      'Pembelian',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  PopupMenuItem(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => FormPenjualanPage()));
                    },
                    child: Text(
                      'Penjualan',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ]);
          },
          icon: Icon(CupertinoIcons.add_circled_solid),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              fetchPhoneItem();
            });
          },
          icon: Icon(
            CupertinoIcons.arrow_clockwise,
            color: Colors.white,
          ),
        )
      ],
    );
  }
}
