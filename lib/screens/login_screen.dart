import 'package:dosemate/core/constant/app_style.dart';
import 'package:dosemate/core/constant/constant_colors.dart';
import 'package:dosemate/core/utils/app_regex.dart'; // import لملف AppRegex
import 'package:dosemate/db/user.dart';
import 'package:dosemate/models/user.dart';
import 'package:dosemate/screens/bottom_nav_screen.dart';
import 'package:dosemate/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool hasAccount = true;
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(25),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    width: 130,
                    height: 130,
                  ),

                  const SizedBox(height: 30),

                  Text(
                    hasAccount ? 'تسجيل الدخول' : 'إنشاء حساب',
                    style: AppStyles.pageTitle,
                  ),

                  const SizedBox(height: 35),

                  if (!hasAccount) ...[
                    TextFromFieldClass(
                      hint: 'أدخل اسمك',
                      lable: 'الاسم',
                      preIcon: Icons.person,
                      controller: nameController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'يرجى إدخال الاسم';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 15),
                  ],

                  // Email
                  TextFromFieldClass(
                    hint: 'name@domain.com',
                    lable: 'البريد الإلكتروني',
                    preIcon: Icons.email,
                    controller: emailController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'يرجى إدخال البريد الإلكتروني';
                      }
                     
                      if (!AppRegex.isEmailValid(value)) {
                        return 'يرجى إدخال بريد إلكتروني صحيح';
                      }
                     

                      return null;
                    },
                  ),

                  const SizedBox(height: 15),

                  TextFromFieldClass(
                    hint: '*******',
                    lable: 'كلمة المرور',
                    preIcon: Icons.lock,
                    controller: passwordController,
                    obScure: obscurePassword,
                    sufIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },
                      icon: Icon(
                        obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'يرجى إدخال كلمة المرور';
                      }

                      if (AppRegex.isPasswordValid(value)) {
                        if(hasAccount){
                          bool validation = users.any((user)=>user.email == emailController.text.trim() && user.password == passwordController.text.trim());

                          if(!validation){
                            return 'البريد الإلكتروني أو كلمة المرور غير صحيحة';
                          }
                          
                        }
                        return null;
                      }
                      else {
                        return 'كلمة المرور يجب أن تحتوي على 8 أحرف على الأقل، بما في ذلك حرف كبير وحرف صغير ورقم ورمز خاص';
                      }

                    },
                  ),

                  // Confirm Password
                  if (!hasAccount) ...[
                    const SizedBox(height: 15),

                    TextFromFieldClass(
                      hint: '*******',
                      lable: 'تأكيد كلمة المرور',
                      preIcon: Icons.lock_outline,
                      controller: confirmPasswordController,
                      obScure: obscureConfirmPassword,
                      sufIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            obscureConfirmPassword =
                                !obscureConfirmPassword;
                          });
                        },
                        icon: Icon(
                          obscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى تأكيد كلمة المرور';
                        }

                        if (value != passwordController.text) {
                          return 'كلمتا المرور غير متطابقتين';
                        }

                        return null;
                      },
                    ),
                  ],

                  const SizedBox(height: 25),

                  // Login / Register Button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ConstantColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (hasAccount) {
                            currentUser = users.where((user)=>user.email == emailController.text.trim() && user.password == passwordController.text.trim()).firstOrNull;
                            Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => BottomNavScreen()));
                            
                          } else {
                            // Register logic
                            User newUser = User(
                              createdAt: DateTime.now(),
                              name: nameController.text.trim(),
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                              // phone: '', 
                              dateOfBirth: DateTime.now()); 
                              // gender: '', 
                              users.add(newUser);
                              setState(() {
                                hasAccount = true; 
                                nameController.clear();
                                emailController.clear();
                                passwordController.clear();
                                confirmPasswordController.clear();
                              });
                          }
                        }
                      },
                      child: Text(
                        hasAccount ? 'تسجيل الدخول' : 'إنشاء حساب',
                        style: AppStyles.button.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            hasAccount = !hasAccount;
                          });
                        },
                        child: Text(
                          hasAccount
                              ? 'إنشاء حساب'
                              : 'تسجيل الدخول',
                          style: AppStyles.link,
                        ),
                      ),
                      Text(
                        hasAccount
                            ? 'ليس لديك حساب؟'
                            : 'لديك حساب بالفعل؟',
                        style: AppStyles.body,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}