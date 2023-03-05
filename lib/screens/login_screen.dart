import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/resources/auth_method.dart';
import 'package:instagram/responsive/mobile_screen_layout.dart';
import 'package:instagram/responsive/responsive_layout.dart';
import 'package:instagram/responsive/web_screen_layout.dart';
import 'package:instagram/screens/signup_screen.dart';
import 'package:instagram/utils.dart/colors.dart';
import 'package:instagram/utils.dart/gloal_var.dart';
import 'package:instagram/utils.dart/utils.dart';
import 'package:instagram/widget/text_field_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  bool isloading = false;
  @override
  void dispose() {
    super.dispose();
    email.dispose();
    pass.dispose();
  }

  void logInUser() async {
    setState(() {
      isloading = true;
    });

    final res = await AuthMethods().loginUser(
      email: email.text,
      password: pass.text,
    );
    setState(() {
      isloading = false;
    });
    if (res == 'success') {
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (_) {
          return const ResponsiveLayout(
            mobileScreenlayout: MobileScreenLayout(),
            webScreenlayout: WebScreenLayout(),
          );
        },
      ));
    }
    if (res != 'success') {
      // ignore: use_build_context_synchronously
      showSnackBar(res, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: MediaQuery.of(context).size.width > webScreenSize
            ? EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 3)
            : const EdgeInsets.symmetric(horizontal: 32),
        width: double.infinity,
        child: Column(
          children: [
            Flexible(
              child: Container(),
              flex: 2,
            ),
            SvgPicture.asset(
              'assets/ic_instagram.svg',
              color: primaryColor,
              height: 64,
            ),
            const SizedBox(
              height: 64,
            ),
            TextFieldInput(
                hintxt: 'Email',
                textEdit: email,
                type: TextInputType.emailAddress),
            const SizedBox(
              height: 24,
            ),
            TextFieldInput(
              hintxt: 'password',
              textEdit: pass,
              type: TextInputType.text,
              ispass: false,
            ),
            const SizedBox(
              height: 24,
            ),
            InkWell(
              onTap: logInUser,
              child: Container(
                child: isloading
                    ? const Center(
                        child: CircularProgressIndicator(color: primaryColor),
                      )
                    : const Text('Log In'),
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: ShapeDecoration(
                    color: blueColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4))),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Flexible(
              child: Container(),
              flex: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: const Text('Don\'t have account? '),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) {
                        return const SignUpScreen();
                      },
                    ));
                  },
                  child: Container(
                    child: const Text(
                      'Sign up',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                )
              ],
            )
          ],
        ),
      )),
    );
  }
}
