import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_hp/bloc/fetch_phone_item/fetch_phone_bloc.dart';
import 'package:inventory_hp/bloc/fetch_phone_item/fetch_phone_event.dart';
import 'package:inventory_hp/bloc/fetch_phone_item/fetch_phone_state.dart';
import 'package:inventory_hp/component/custom_textformfield.dart';

class PhoneSheet extends StatefulWidget {
  PhoneSheet({super.key});

  @override
  State<PhoneSheet> createState() => _PhoneSheetState();
}

class _PhoneSheetState extends State<PhoneSheet> {
  Timer? _debounce;
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Phone Series',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: CustomTextFormField(
                    controller: searchController,
                    borderRadius: 8,
                    hintText: 'Search here...',
                    title: '',
                    borderColor: Colors.grey,
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
                        icon: Icon(CupertinoIcons.xmark_circle_fill)),
                  ),
                ),
              ],
            ),
          ),
          BlocBuilder<FetchPhoneBloc, FetchPhoneState>(
              builder: (context, state) {
            return searchController.text.isEmpty
                ? Expanded(
                    child: ListView.builder(
                      itemCount: state.items.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                              '${state.items[index].name} - ${state.items[index].color}'),
                          onTap: () {
                            Navigator.pop(context, state.items[index]);
                          },
                        );
                      },
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: state.searchResults.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                              '${state.searchResults[index].name} - ${state.searchResults[index].color}'),
                          onTap: () {
                            Navigator.pop(context, state.searchResults[index]);
                          },
                        );
                      },
                    ),
                  );
          })
        ],
      ),
    );
  }
}
