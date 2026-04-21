import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import './src/app.dart';

void main() async {
  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env['supabase_Url']!,
    anonKey: dotenv.env['supabase_Key']!);

  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

