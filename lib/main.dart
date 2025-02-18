import 'package:admin_catalogo/application.dart';
import 'package:admin_catalogo/core/di/injector.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  await Supabase.initialize(
      url: 'https://lcqoazdeokbijrxfvsvg.supabase.co',
      anonKey:
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxjcW9hemRlb2tiaWpyeGZ2c3ZnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzgzNjM1NDksImV4cCI6MjA1MzkzOTU0OX0.6Avypvkae5tvSMLaOPsZ4PMmNXjzPvguuS7OVbt1pBo");

  injector();

  runApp(const MyApp());
}
