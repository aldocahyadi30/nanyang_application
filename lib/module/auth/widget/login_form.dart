import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/provider/toast_provider.dart';
import 'package:nanyang_application/size.dart';
import 'package:nanyang_application/viewmodel/auth_viewmodel.dart';
import 'package:nanyang_application/module/global/form/form_button.dart';
import 'package:provider/provider.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late AuthViewModel _authViewModel;
  late ToastProvider _toastProvider;
  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    _toastProvider = Provider.of<ToastProvider>(context, listen: false);
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
      await _authViewModel.login(email, password);
    } else {
      _toastProvider.showToast('Cek kembali inputan anda!', 'error');
    }

    setState(() {
      _isLoading = false;
    });
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
            decoration: InputDecoration(
              contentPadding: dynamicPaddingSymmetric(20, 32, context),
              prefixIcon: const Icon(
                Icons.email,
                color: ColorTemplate.violetBlue,
              ),
              labelText: 'Email',
              labelStyle: const TextStyle(
                color: Color(0x803143A4),
              ),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              fillColor: Colors.white,
              filled: true,
              enabledBorder: _outlineInputBorder(context),
              focusedBorder: _outlineInputBorder(context),
              errorBorder: _errorOutlineInputBorder(context), // Customize error border
              focusedErrorBorder: _errorOutlineInputBorder(context), // Customize focused error border
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
            obscureText: _isObscure,
            decoration: InputDecoration(
              contentPadding: dynamicPaddingSymmetric(20, 32, context),
              prefixIcon: const Icon(
                Icons.lock,
                color: ColorTemplate.violetBlue,
              ),
              suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  },
                  icon: _isObscure
                      ? const Icon(
                          Icons.visibility,
                          color: ColorTemplate.violetBlue,
                        )
                      : const Icon(Icons.visibility_off, color: ColorTemplate.violetBlue)),
              labelText: 'Password',
              labelStyle: const TextStyle(
                color: Color(0x803143A4),
              ),
              fillColor: Colors.white,
              floatingLabelBehavior: FloatingLabelBehavior.never,
              filled: true,
              enabledBorder: _outlineInputBorder(context),
              focusedBorder: _outlineInputBorder(context),
              errorBorder: _errorOutlineInputBorder(context), // Customize error border
              focusedErrorBorder: _errorOutlineInputBorder(context), // Customize focused error border
            ),
          ),
          SizedBox(
            height: dynamicHeight(32, context),
          ),
          FormButton(
            backgroundColor: ColorTemplate.violetBlue,
            foregroundColor: ColorTemplate.argentinianBlue,
            textColor: Colors.white,
            text: 'Login',
            isLoading: _isLoading,
            onPressed: () {
              FocusManager.instance.primaryFocus?.unfocus();
              login(_emailController.text, _passwordController.text);
            },
          ),
          SizedBox(
            height: dynamicHeight(16, context),
          ),
          RichText(
            text: TextSpan(
              text: 'Lupa Password?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: dynamicFontSize(14, context),
                color: Colors.black,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  //TODO Add navigation to forgot password screen
                },
            ),
          ),
        ],
      ),
    );
  }

  OutlineInputBorder _outlineInputBorder(BuildContext context) {
    return OutlineInputBorder(
      borderSide: const BorderSide(
        width: 3.0, // Adjust the width as needed
        color: ColorTemplate.violetBlue,
      ),
      borderRadius: BorderRadius.circular(64.0), // Set a consistent border radius
    );
  }

  OutlineInputBorder _errorOutlineInputBorder(BuildContext context) {
    return OutlineInputBorder(
      borderSide: const BorderSide(
        width: 3.0, // Adjust the width as needed
        color: Colors.red, // Customize error border color as needed
      ),
      borderRadius: BorderRadius.circular(64.0), // Set a consistent border radius
    );
  }
}