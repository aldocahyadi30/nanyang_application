import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nanyang_application/provider/toast_provider.dart';
import 'package:nanyang_application/provider/user_provider.dart';
import 'package:nanyang_application/viewmodel/login_viewmodel.dart';
import 'package:nanyang_application/widget/form_button.dart';
import 'package:provider/provider.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> login(email, password) async {
    setState(() {
      _isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      final password = _passwordController.text;
      final loginViewModel = Provider.of<LoginViewModel>(context, listen: false);
      final user = await loginViewModel.login(email, password);

      if (user?.id != null || user?.id != '') {
        if (context.mounted) {
          Provider.of<ToastProvider>(context, listen: false).showToast('Login berhasil!', 'success');
          Provider.of<UserProvider>(context, listen: false).setUser(user!);
          Navigator.of(context).pushReplacementNamed('/home');
        }
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      Provider.of<ToastProvider>(context, listen: false).showToast('Cek kembali inputan anda!', 'error');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
          ),
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Masukan email anda';
              }

              if (!value.contains('@')) {
                return 'Masukan email yang valid';
              }
              return null;
            },
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 6.0),
          ),
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Masukan password anda';
              }

              if (value.length < 8) {
                return 'Password minimal 8 karakter';
              }
              return null;
            },
            controller: _passwordController,
            decoration: const InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
          ),
          FormButton(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            textColor: Colors.white,
            text: 'Login',
            isLoading: _isLoading,
            onPressed: () {
              login(_emailController.text, _passwordController.text);
            },
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
          ),
          RichText(
            text: TextSpan(
              text: 'Lupa Password?',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                color: Colors.black,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.pushNamed(
                    context,
                    '/register',
                  );
                },
            ),
          ),
        ],
      ),
    );
  }
}
