import 'package:firebase_auth_bloc_weather/widgets/usermodel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
    on<AuthSignUpRequested>(_onAuthSignUpRequested);
    on<Splash>(_onSplash);
  }

  void _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final password = event.password;
      // Email validation using Regex

      if (password.length < 6) {
        return emit(
          AuthFailure('Password cannot be less than 6 characters!'),
        );
      }
      print("One");
      User? currentUser;
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: event.email, password: event.password)
          .then((auth) {
        currentUser = auth.user;
        print("Two");
      }).catchError((errorMessage) {
        emit(AuthFailure(errorMessage.toString()));
      });
      if (currentUser != null) {
        print("Three");

        await FirebaseFirestore.instance
            .collection("users")
            .doc(currentUser?.uid)
            .get()
            .then((record) async {
          if (record.exists) {
            UserModel user =
                UserModel.fromJson(record.data() as Map<String, dynamic>);
            emit(AuthSuccess(uid: user));
          } else {
            FirebaseAuth.instance.signOut();
            emit(AuthFailure("No Record Found"));
          }
        });
      }
    } catch (e) {
      return emit(AuthFailure(e.toString()));
    }
  }

  void _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await FirebaseAuth.instance.signOut();
      await Future.delayed(const Duration(seconds: 1), () {
        return emit(AuthInitial());
      });
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  void _onAuthSignUpRequested(
    AuthSignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final password = event.password;
      if (password.length < 6) {
        return emit(
          AuthFailure('Password cannot be less than 6 characters!'),
        );
      }
      User? currentUser;
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      )
          .then((auth) async {
        currentUser = auth.user;

        await FirebaseFirestore.instance
            .collection("users")
            .doc(currentUser?.uid)
            .set({
          "uid": currentUser?.uid,
          "email": currentUser?.email,
        }).then((value) {
          UserModel user =
              UserModel(email: currentUser?.email, uid: currentUser?.uid);
          emit(AuthSuccess(uid: user));
        });
      }).catchError((errorMessage) {
        emit(AuthFailure(errorMessage.toString()));
      });
      if (currentUser != null) {}
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  void _onSplash(
    Splash event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await Future.delayed(const Duration(seconds: 5), () {
        final val = FirebaseAuth.instance.currentUser;
        if (FirebaseAuth.instance.currentUser != null) {
          UserModel user = UserModel(email: val?.email, uid: val?.uid);
          return emit(AuthSuccess(uid: user));
        } else {
          return emit(AuthFailure("Please Login In"));
        }
      });
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
