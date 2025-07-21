import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:inventory_hp/bloc/add_color/add_color_bloc.dart';
import 'package:inventory_hp/bloc/add_phone_item/add_phone_bloc.dart';
import 'package:inventory_hp/bloc/delete_phone_item/delete_phone_bloc.dart';
import 'package:inventory_hp/bloc/fetch_color/fetch_color_bloc.dart';
import 'package:inventory_hp/bloc/fetch_phone_item/fetch_phone_bloc.dart';
import 'package:inventory_hp/bloc/update_phone_item/update_phone_bloc.dart';
import 'package:inventory_hp/home_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
  );

  runApp(const MyApp());

  FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AddPhoneBloc()),
          BlocProvider(create: (context) => FetchColorBloc()),
          BlocProvider(create: (context) => FetchPhoneBloc()),
          BlocProvider(create: (context) => UpdatePhoneBloc()),
          BlocProvider(create: (context) => AddColorBloc()),
          BlocProvider(create: (context) => DeletePhoneBloc()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Inventory',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: HomePage(),
        ));
  }
}
