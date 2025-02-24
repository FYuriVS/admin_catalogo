import 'package:admin_catalogo/application.dart';
import 'package:admin_catalogo/core/di/injector.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  await Supabase.initialize(
      url: 'https://jdqsvduxqblskboozypp.supabase.co',
      anonKey:
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpkcXN2ZHV4cWJsc2tib296eXBwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDA0MTg1MjgsImV4cCI6MjA1NTk5NDUyOH0.zKnFrEnQ9wYX0M6G-YyrGvqiVDLv6HUj2ziJOp3mtHY");

  injector();

  runApp(const MyApp());
}
