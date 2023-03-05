import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/resources/auth_method.dart';
import 'package:instagram/responsive/mobile_screen_layout.dart';
import 'package:instagram/responsive/responsive_layout.dart';
import 'package:instagram/responsive/web_screen_layout.dart';
import 'package:instagram/screens/login_screen.dart';
import 'package:instagram/utils.dart/colors.dart';
import 'package:instagram/utils.dart/utils.dart';
import 'package:instagram/widget/text_field_input.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController bio = TextEditingController();
  TextEditingController username = TextEditingController();
  Uint8List? _file;
  bool isloading = false;
  @override
  void dispose() {
    super.dispose();
    email.dispose();
    pass.dispose();
    bio.dispose();
    username.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);

    setState(() {
      _file = im;
    });
  }

  void SignUpUser() async {
    setState(() {
      isloading = true;
    });

    final res = await AuthMethods().signupUser(
        email: email.text,
        password: pass.text,
        username: username.text,
        bio: bio.text,
        file: _file!);
    setState(() {
      isloading = false;
    });
    if (res != 'success') {
      // ignore: use_build_context_synchronously
      showSnackBar(res, context);
    }
    if (res == 'success') {
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) {
          return const ResponsiveLayout(
            mobileScreenlayout: MobileScreenLayout(),
            webScreenlayout: WebScreenLayout(),
          );
        },
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        width: double.infinity,
        child: Column(
          children: [
            Flexible(
              flex: 2,
              child: Container(),
            ),
            SvgPicture.asset(
              'assets/ic_instagram.svg',
              color: primaryColor,
              height: 64,
            ),
            const SizedBox(
              height: 64,
            ),
            Stack(
              children: [
                _file != null
                    ? CircleAvatar(
                        radius: 54,
                        backgroundImage: MemoryImage(_file!),
                      )
                    : const CircleAvatar(
                        radius: 54,
                        backgroundImage: NetworkImage(
                            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRTHp7HDUzfrraXrobnp_eKUtNeFiq9E8NklA&usqp=CAU"),
                      ),
                Positioned(
                    bottom: 0,
                    right: 0,
                    child: IconButton(
                      onPressed: selectImage,
                      icon: const Icon(Icons.add_a_photo),
                    ))
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            TextFieldInput(
                hintxt: 'Username',
                textEdit: username,
                type: TextInputType.text),
            const SizedBox(
              height: 24,
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
            TextFieldInput(
                hintxt: 'Bio', textEdit: bio, type: TextInputType.text),
            const SizedBox(
              height: 24,
            ),
            InkWell(
              onTap: SignUpUser,
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: ShapeDecoration(
                    color: blueColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4))),
                child: isloading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: primaryColor,
                        ),
                      )
                    : const Text('Sign Up'),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Flexible(
              flex: 2,
              child: Container(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: const Text('Already have an account? '),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) {
                        return const LoginScreen();
                      },
                    ));
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text(
                      'Sign in',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
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
