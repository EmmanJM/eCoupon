import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ecoupon/common_widgets/custom_alert_dialog.dart';
import 'package:ecoupon/services/auth.dart';
import 'package:provider/provider.dart';
import 'email_sign_in_model.dart';

class EmailSignInForm extends StatefulWidget {
  final String userType;
  //EmailSignInForm({Key? key, required this.model}) : super(key: key);
  EmailSignInForm({required this.model, required this.userType});
  final EmailSignInModel model;
  
  
  
  //static Widget create(BuildContext context) {
  static Widget create(BuildContext context, String userType) {
    final AuthBase auth = Provider.of<AuthBase>(context);
    return ChangeNotifierProvider<EmailSignInModel>(
      create: (context) => EmailSignInModel(auth: auth),
      child: Consumer<EmailSignInModel>(
        builder: (context, model, _) => EmailSignInForm(
          model: model,
          userType: userType, // Passer la valeur ici
        ),
      ),
    );
  }

  @override
  State<EmailSignInForm> createState() => _EmailSignInFormState();
}

// Le reste du code reste inchangé

class _EmailSignInFormState extends State<EmailSignInForm> {
  final TextEditingController? _emailController = TextEditingController();
  final TextEditingController? _passwordController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  EmailSignInModel get model => widget.model;

  Future<void> _submit() async {
    try {
      await model.submit();
    } on FirebaseException catch (e) {
      CustomAlertDialog(
        title: "Connexion impossible",
        content: e.message!,
        defaultActionText: "OK",
      ).show(context);
    }
  }

  void _toogleFormType() {
    model.toggleFormType();
    _emailController!.clear();
    _passwordController!.clear();
  }

  void _emailEditingComplete() {
    final newFocus = model.emailValidator.isValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  List<Widget> _buildChildren() {
    return [
      _buildHeader(),
      const SizedBox(
        height: 15.0,
      ),
      _buildEmailTextField(),
      const SizedBox(
        height: 15.0,
      ),
      _buildPasswordTextField(),
      const SizedBox(
        height: 15.0,
      ),
      _buildFormActions(),
    ];
  }

  Widget _buildHeader() {
    return Text(
      model.headerText,
      style: Theme.of(context).textTheme.headline2,
    );
  }

  Widget _buildEmailTextField() {
  return TextField(
    autocorrect: false,
    keyboardType: TextInputType.emailAddress,
    textInputAction: TextInputAction.next,
    controller: _emailController,
    decoration: InputDecoration(
        labelText: "Adresse mail",
        //hintText: "test@test.com", 
        hintText: "${widget.userType}test@test.com", // Utilisation de widget.someValue pour obtenir la valeur
        border: OutlineInputBorder(),
        icon: Icon(Icons.mail),
        errorText: model.emailErrorText,
        enabled: model.isLoading == false),
    focusNode: _emailFocusNode,
    onEditingComplete: () => _emailEditingComplete(),
    onChanged: model.updateEmail,
  );
}

  Widget _buildPasswordTextField() {
    return TextField(
      controller: _passwordController,
      obscureText: true,
      decoration: InputDecoration(
          labelText: "Mot de passe",
          border: OutlineInputBorder(),
          icon: Icon(Icons.lock),
          errorText: model.passwordErrorText,
          enabled: model.isLoading == false),
      textInputAction: TextInputAction.done,
      focusNode: _passwordFocusNode,
      onEditingComplete: _submit,
      onChanged: model.updatePassword,
    );
  }

  Widget _buildFormActions() {
    if (model.isLoading) {
      return const CircularProgressIndicator();
    }
    return Column(
      children: [
        ElevatedButton(
          onPressed: model.canSubmit ? _submit : null,
          child: Text(
            model.primaryButtonText,
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(color: Colors.black),
          ),
          style: ElevatedButton.styleFrom(
              primary: Colors.deepOrange[200],
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)))),
        ),
        TextButton(
            onPressed: !model.isLoading ? _toogleFormType : null,
            child: Text(
              model.secondaryButtonText,
            ))
      ],
    );
  }
    
    
  
@override
Widget build(BuildContext context) {
  return Container(
    decoration: BoxDecoration( // Pour le background bleu ciel
      color: Colors.lightBlue,
    ),
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    child: Center(
      child: SingleChildScrollView(
        child: Container( // Conteneur principal pour le formulaire
          margin: const EdgeInsets.symmetric(vertical: 50.0), // Marge supplémentaire pour le logo
          decoration: BoxDecoration(
            color: Colors.white, // Arrière-plan blanc pour le formulaire
            borderRadius: BorderRadius.circular(15.0), // Bordures arrondies
          ),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              Padding( // Pour le logo centré avec dimensions h100, w100
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Image.asset(
                  'assets/Logo_eCoupon.png',
                  height: 50,
                  width: 50,
                ),
              ),
              ..._buildChildren(), // Utilisation de l'opérateur spread (...) pour inclure les éléments de formulaire existants
            ],
          ),
        ),
      ),
    ),
  );
}

  @override
  void dispose() {
    _emailController!.dispose();
    _passwordController!.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }
}
