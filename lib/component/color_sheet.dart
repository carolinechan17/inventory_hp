import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_hp/bloc/add_color/add_color_bloc.dart';
import 'package:inventory_hp/bloc/add_color/add_color_event.dart';
import 'package:inventory_hp/bloc/delete_color/delete_color_bloc.dart';
import 'package:inventory_hp/bloc/delete_color/delete_color_event.dart';
import 'package:inventory_hp/bloc/fetch_color/fetch_color_bloc.dart';
import 'package:inventory_hp/bloc/fetch_color/fetch_color_event.dart';
import 'package:inventory_hp/bloc/fetch_color/fetch_color_state.dart';
import 'package:inventory_hp/component/custom_textformfield.dart';
import 'package:inventory_hp/extension/string_extension.dart';

class ColorSheet extends StatefulWidget {
  ColorSheet({super.key});

  @override
  State<ColorSheet> createState() => _ColorSheetState();
}

class _ColorSheetState extends State<ColorSheet> {
  TextEditingController colorController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<FetchColorBloc, FetchColorState>(
      listener: (context, state) {
        if (!state.isUpdating) {
          setState(() {});
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Phone Colors',
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
                        validator: (p0) {
                          return p0!.isEmpty ? 'Color is required' : null;
                        },
                        controller: colorController,
                        borderRadius: 8,
                        hintText: 'Input new color here',
                        title: '',
                        borderColor: Colors.grey,
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    IconButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<AddColorBloc>().add(AddColor(
                              color: colorController.text,
                              onSuccess: (data) {
                                colorController.text = '';
                                context
                                    .read<FetchColorBloc>()
                                    .add(HandleAddColor(data: data));
                              },
                              onFail: (err) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(content: Text(err)));
                              }));
                        }
                      },
                      icon: Icon(
                        CupertinoIcons.add_circled,
                        size: 32,
                        color: Colors.indigoAccent,
                      ),
                    )
                  ],
                ),
              ),
              BlocBuilder<FetchColorBloc, FetchColorState>(
                  builder: (context, state) {
                return state.colors.isNotEmpty
                    ? Expanded(
                        child: ListView.builder(
                          itemCount: state.colors.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 4),
                              title: Text(
                                  capitalize(state.colors[index].color ?? '')),
                              trailing: IconButton(
                                  onPressed: () {
                                    context
                                        .read<DeleteColorBloc>()
                                        .add(DeleteColor(
                                            id: state.colors[index].id ?? 0,
                                            onFail: (err) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(err)));
                                            },
                                            onSuccess: () {
                                              setState(() {
                                                context
                                                    .read<FetchColorBloc>()
                                                    .add(GetColors());
                                              });
                                            }));
                                  },
                                  icon: Icon(
                                    CupertinoIcons.trash,
                                    color: Colors.red,
                                  )),
                              onTap: () {
                                Navigator.pop(context, state.colors[index]);
                              },
                            );
                          },
                        ),
                      )
                    : Expanded(
                        child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              CupertinoIcons.cube_box,
                              size: 40,
                              color: Colors.grey,
                            ),
                            Text(
                              'Belum ada warna',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ));
              })
            ],
          ),
        ),
      ),
    );
  }
}
