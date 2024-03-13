import 'package:flutter/material.dart';
import 'package:ecoupon/services/auth.dart';
import 'package:ecoupon/utils/validators.dart';

enum EmailSignInFormType { signIn, register }

class EmailSignInModel with EmailAndPasswordValidators, ChangeNotifier {
  EmailSignInModel(
      {this.email = "",
      this.password = "",
      this.formType = EmailSignInFormType.signIn,
      this.isLoading = false,
      this.submitted = false,
      required this.auth});

  String email;
  String password;
  EmailSignInFormType formType;
  bool isLoading;
  bool submitted;
  final AuthBase auth;

  void updateWith(
      {String? email,
      String? password,
      EmailSignInFormType? formType,
      bool? isLoading,
      bool? submitted}) {
    this.email = email ?? this.email;
    this.password = password ?? this.password;
    this.formType = formType ?? this.formType;
    this.isLoading = isLoading ?? this.isLoading;
    this.submitted = submitted ?? this.submitted;
    notifyListeners();
  }

  Future<void> submit() async {
    updateWith(submitted: true, isLoading: true);
    try {
      if (formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(email, password);
      } else {
        await auth.createUserWithEmailAndPassword(email, password);
      }
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  String get headerText {
    return formType == EmailSignInFormType.signIn ? "Connexion" : "Inscription";
  }

  String get primaryButtonText {
    return formType == EmailSignInFormType.signIn
        ? "Se connecter"
        : "Créer un compte";
  }

  String get secondaryButtonText {
    return formType == EmailSignInFormType.signIn
        ? "Avez-vous besoin d'un compte ? Inscrivez-vous"
        : "Avez-vous un compte ? Connectez-vous";
  }

  bool get canSubmit {
    return emailValidator.isValid(email) &&
        passwordValidator.isValid(password) &&
        !isLoading;
  }

  String? get passwordErrorText {
    bool showErrorText = submitted && !passwordValidator.isValid(password);
    return showErrorText ? invalidPasswordErrorText : null;
  }

  String? get emailErrorText {
    bool showErrorText = submitted && !emailValidator.isValid(email);
    return showErrorText ? invalidEmailErrorText : null;
  }

  void updateEmail(String email) => updateWith(email: email);
  void updatePassword(String password) => updateWith(password: password);

  void toggleFormType() {
    final formType = this.formType == EmailSignInFormType.signIn
        ? EmailSignInFormType.register
        : EmailSignInFormType.signIn;

    updateWith(
      email: "",
      password: "",
      formType: formType,
      submitted: false,
      isLoading: false,
    );
  }
}
