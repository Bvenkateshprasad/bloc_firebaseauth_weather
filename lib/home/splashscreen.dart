import 'package:firebase_auth_bloc_weather/auth/login_screen.dart';
import 'package:firebase_auth_bloc_weather/blocs/bloc/auth_bloc.dart';
import 'package:firebase_auth_bloc_weather/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    context.read<AuthBloc>().add(Splash());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
            (route) => false,
          );
        }
        if (state is AuthSuccess) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
            (route) => false,
          );
        }
      },
      builder: (context, state) {
        if (state is AuthLoading) {
          return Center(
            child: Lottie.asset(
              'assets/splash.json',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.fill,
            ),
          );
        }
        return const Scaffold(
          body: Column(
            children: [],
          ),
        );
      },
    );
  }
}
