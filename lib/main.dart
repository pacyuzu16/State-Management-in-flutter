// ─────────────────────────────────────────────────────────────────────────────
// STEP 1: Import the provider package after adding it to pubspec.yaml
// ─────────────────────────────────────────────────────────────────────────────
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'provider_demo/counter_model.dart';
import 'provider_demo/home_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// STEP 3: Providing the State
//
// Wrap the root widget with ChangeNotifierProvider so the entire widget tree
// can access CounterModel.
//
// - create: instantiates the model once
// - child:  the rest of the app sits inside it
// ─────────────────────────────────────────────────────────────────────────────
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CounterModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Provider Demo — Assignment 1',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2d2d7a)),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
