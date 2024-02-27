import 'package:firebase_auth_bloc_weather/auth/login_screen.dart';
import 'package:firebase_auth_bloc_weather/blocs/app_bloc_observer.dart';
import 'package:firebase_auth_bloc_weather/home/splashscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/bloc/auth_bloc.dart';

void main() async {
  Bloc.observer = AppBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyBYc4rIphanNOvM-cbGjU5TNK38ELot0C8",
            authDomain: "bloc-login-455df.firebaseapp.com",
            projectId: "bloc-login-455df",
            storageBucket: "bloc-login-455df.appspot.com",
            messagingSenderId: "317730542210",
            appId: "1:317730542210:web:8624069d2755b22403da9b"));
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc()),
      ],
      child: MaterialApp(
          title: 'Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData.dark(
            // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const SplashScreen()),
    );
  }
}
