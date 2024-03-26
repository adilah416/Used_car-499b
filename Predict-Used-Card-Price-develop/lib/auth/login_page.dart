import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:predict_used_car_price/auth/auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final ValueNotifier<bool> isLogin = ValueNotifier<bool>(true);
  final ValueNotifier<String> errorMessage = ValueNotifier<String>('');
  final ValueNotifier<bool> processing = ValueNotifier<bool>(false);
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> signIn() async {
    try {
      await Auth().signIn(email: _emailController.text, password: _passwordController.text);

    } on FirebaseAuthException catch (e) {
      errorMessage.value = e.message!;
    }
  }

  Future<void> createAccount() async {
    if (_emailController.value.text.isEmpty || _passwordController.value.text.isEmpty) {
      errorMessage.value = 'Please enter email and password';
      return;
    } else {
      processing.value = true;
      try {
        await Auth().signUp(email: _emailController.text, password: _passwordController.text);
      } on FirebaseAuthException catch (e) {
        errorMessage.value = e.message!;
      }
      processing.value = false;
    }
  }

  Widget _errorMessage() {
    return ValueListenableBuilder<String>(
      valueListenable: errorMessage,
      builder: (context, value, child) {
        return Text(
          value,
          style: const TextStyle(color: Colors.red),
        );
      },
    );
  }

  final TextStyle submitTextStyle = TextStyle(
    color: Colors.teal[200],
    fontSize: 12,
    // fontWeight: FontWeight.w300,
  );
  final TextStyle inputTextStyle = const TextStyle(
    color: Colors.white,
    fontSize: 15,
    fontWeight: FontWeight.bold,
    // fontWeight: FontWeight.w300,
  );
  final ButtonStyle submitButtonStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey[900]!),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
        side: const BorderSide(color: Colors.white),
      ),
    ),
  );
  final TextStyle textStyle = const TextStyle(
    color: Colors.white,
    fontSize: 12,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Welcome!',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[700],
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.blueGrey[800],
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              style: inputTextStyle,
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email', labelStyle: textStyle),
            ),
            TextField(
              obscureText: true,
              style: inputTextStyle,
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password', labelStyle: textStyle),
            ),
            _errorMessage(),
            ValueListenableBuilder(
              valueListenable: isLogin,
              builder: (BuildContext context, bool value, Widget? child) {
                return ElevatedButton(
                  onPressed: value ? signIn : createAccount,
                  style: submitButtonStyle,
                  child: Text(value ? 'Login' : 'Register', style: submitTextStyle),
                );
              },
            ),
            ValueListenableBuilder(
                valueListenable: isLogin,
                builder: (BuildContext context, bool value, Widget? child) {
                  return TextButton(
                    onPressed: () => isLogin.value = !isLogin.value,
                    child: Text(
                      value ? 'Don\'t Have An Account?' : 'Already Have an Account?',
                      style: TextStyle(
                        color: Colors.teal[200],
                        fontSize: 12,
                      ),
                    ),
                  );
                }),
            ValueListenableBuilder(
                valueListenable: processing,
                builder: (BuildContext context, bool value, Widget? child) {
                  return value? const CircularProgressIndicator() : const SizedBox();
                }),
          ],
        ),
      ),
    );
  }
}
