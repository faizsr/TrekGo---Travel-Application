import 'package:flutter/material.dart';
import 'package:trekmate_project/assets.dart';
import 'package:trekmate_project/helper/auth_db_function.dart';
import 'package:trekmate_project/screens/user/user_login_screen.dart';
import 'package:trekmate_project/service/auth_service.dart';
import 'package:trekmate_project/widgets/alerts_and_navigators/alerts_and_navigates.dart';
import 'package:trekmate_project/widgets/login_signup_widgets/button.dart';
import 'package:trekmate_project/widgets/login_signup_widgets/text_form_field.dart';
import 'package:trekmate_project/widgets/login_signup_widgets/title.dart';
import 'package:trekmate_project/widgets/reusable_widgets/back_button.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final adminIdController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String adminId = '';
  String email = '';
  String password = '';
  bool isLoading = false;
  bool isButtonEnable = false;

  AuthService authService = AuthService();

  void setLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          // ===== Background image =====

          image: DecorationImage(
            image: AssetImage(backgroundImageWithLogo),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              // ===== Back button =====
              CustomBackButton(
                pageNavigator: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserLoginScreen(),
                  ),
                ),
              ),

              // ===== Background container =====
              Align(
                alignment: Alignment.center,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 1.9,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // ===== Title =====
                        const Padding(
                          padding: EdgeInsets.only(top: 25),
                          child: TitleWidget(
                            mainText: 'Admin Login',
                            mainTextSize: 25,
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),

                        // ===== Admin ID field =====
                        TextFieldWidget(
                          controller: adminIdController,
                          fieldTitle: 'Admin ID',
                          fieldHintText: 'Enter Admin ID...',
                          onChanged: (val) {
                            adminId = val;
                            debugPrint(adminId);
                            setState(() {
                              isButtonEnable = adminId.isNotEmpty &&
                                  email.isNotEmpty &&
                                  password.isNotEmpty;
                            });
                          },
                          validator: (val) {
                            if (val!.isEmpty) {
                              customSnackbar(context, 'Please enter a valid id',
                                  140, 55, 55);
                              return;
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),

                        // ===== Email address field =====
                        TextFieldWidget(
                          controller: emailController,
                          fieldTitle: 'Email Address',
                          fieldHintText: 'Enter your email address...',
                          onChanged: (val) {
                            email = val;
                            debugPrint(email);
                            setState(() {
                              isButtonEnable = adminId.isNotEmpty &&
                                  email.isNotEmpty &&
                                  password.isNotEmpty;
                            });
                          },
                          validator: (val) {
                            if ((RegExp(
                                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                                .hasMatch(val!))) {
                              return null;
                            } else {
                              customSnackbar(context,
                                  'Please enter a valid email', 140, 55, 55);
                              return;
                            }
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),

                        // ===== Password field =====
                        TextFieldWidget(
                          controller: passwordController,
                          obscureText: true,
                          fieldTitle: 'Password',
                          fieldHintText: 'Enter your password...',
                          onChanged: (val) {
                            password = val;
                            debugPrint(password);
                            setState(() {
                              isButtonEnable = adminId.isNotEmpty &&
                                  email.isNotEmpty &&
                                  password.isNotEmpty;
                            });
                          },
                          validator: (val) {
                            if (val!.length < 6) {
                              customSnackbar(
                                  context,
                                  'Password must be at least 6 characters',
                                  140,
                                  55,
                                  55);
                              return;
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(
                          height: 30,
                        ),
 
                        // ===== Login Button =====
                        ButtonsWidget(
                          buttonText: isLoading ? '' : 'LOGIN',
                          buttonOnPressed: isButtonEnable
                              ? () => adminLogin(
                                    formKey: _formKey,
                                    authService: authService,
                                    email: email,
                                    password: password,
                                    setLoadingCallback: setLoading,
                                    context: context,
                                  )
                              : null,
                          loadingWidget: isLoading
                              ? const SizedBox(
                                  width: 15,
                                  height: 15,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                )
                              : null,
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
