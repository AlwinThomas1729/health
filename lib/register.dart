// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'login.dart';
// // import 'model.dart';

// class Register extends StatefulWidget {
//   const Register({super.key});

//   @override
//   _RegisterState createState() => _RegisterState();
// }

// class _RegisterState extends State<Register> {
//   _RegisterState();

//   bool showProgress = false;
//   bool visible = false;

//   final _formkey = GlobalKey<FormState>();
//   final _auth = FirebaseAuth.instance;

//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController confirmpassController = TextEditingController();
//   final TextEditingController name = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController mobile = TextEditingController();
//   bool _isObscure = true;
//   bool _isObscure2 = true;
//   File? file;
//   var options = [
//     'Student',
//     'Teacher',
//   ];
//   var _currentItemSelected = "Student";
//   var rool = "Student";

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.orange[900],
//       body: SingleChildScrollView(
//         child: Column(
//           children: <Widget>[
//             Container(
//               color: Colors.orangeAccent[700],
//               width: MediaQuery.of(context).size.width,
//               height: MediaQuery.of(context).size.height,
//               child: SingleChildScrollView(
//                 child: Container(
//                   margin: const EdgeInsets.all(12),
//                   child: Form(
//                     key: _formkey,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         const SizedBox(
//                           height: 80,
//                         ),
//                         const Text(
//                           "Register Now",
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                             fontSize: 40,
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                         const SizedBox(
//                           height: 50,
//                         ),
//                         TextFormField(
//                           controller: emailController,
//                           decoration: InputDecoration(
//                             filled: true,
//                             fillColor: Colors.white,
//                             hintText: 'Email',
//                             enabled: true,
//                             contentPadding: const EdgeInsets.only(
//                                 left: 14.0, bottom: 8.0, top: 8.0),
//                             focusedBorder: OutlineInputBorder(
//                               borderSide: const BorderSide(color: Colors.white),
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             enabledBorder: UnderlineInputBorder(
//                               borderSide: const BorderSide(color: Colors.white),
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                           ),
//                           validator: (value) {
//                             if (value!.isEmpty) {
//                               return "Email cannot be empty";
//                             }
//                             if (!RegExp(
//                                     "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
//                                 .hasMatch(value)) {
//                               return ("Please enter a valid email");
//                             } else {
//                               return null;
//                             }
//                           },
//                           onChanged: (value) {},
//                           keyboardType: TextInputType.emailAddress,
//                         ),
//                         const SizedBox(
//                           height: 20,
//                         ),
//                         TextFormField(
//                           obscureText: _isObscure,
//                           controller: passwordController,
//                           decoration: InputDecoration(
//                             suffixIcon: IconButton(
//                                 icon: Icon(_isObscure
//                                     ? Icons.visibility_off
//                                     : Icons.visibility),
//                                 onPressed: () {
//                                   setState(() {
//                                     _isObscure = !_isObscure;
//                                   });
//                                 }),
//                             filled: true,
//                             fillColor: Colors.white,
//                             hintText: 'Password',
//                             enabled: true,
//                             contentPadding: const EdgeInsets.only(
//                                 left: 14.0, bottom: 8.0, top: 15.0),
//                             focusedBorder: OutlineInputBorder(
//                               borderSide: const BorderSide(color: Colors.white),
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             enabledBorder: UnderlineInputBorder(
//                               borderSide: const BorderSide(color: Colors.white),
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                           ),
//                           validator: (value) {
//                             RegExp regex = RegExp(r'^.{6,}$');
//                             if (value!.isEmpty) {
//                               return "Password cannot be empty";
//                             }
//                             if (!regex.hasMatch(value)) {
//                               return ("please enter valid password min. 6 character");
//                             } else {
//                               return null;
//                             }
//                           },
//                           onChanged: (value) {},
//                         ),
//                         const SizedBox(
//                           height: 20,
//                         ),
//                         TextFormField(
//                           obscureText: _isObscure2,
//                           controller: confirmpassController,
//                           decoration: InputDecoration(
//                             suffixIcon: IconButton(
//                                 icon: Icon(_isObscure2
//                                     ? Icons.visibility_off
//                                     : Icons.visibility),
//                                 onPressed: () {
//                                   setState(() {
//                                     _isObscure2 = !_isObscure2;
//                                   });
//                                 }),
//                             filled: true,
//                             fillColor: Colors.white,
//                             hintText: 'Confirm Password',
//                             enabled: true,
//                             contentPadding: const EdgeInsets.only(
//                                 left: 14.0, bottom: 8.0, top: 15.0),
//                             focusedBorder: OutlineInputBorder(
//                               borderSide: const BorderSide(color: Colors.white),
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             enabledBorder: UnderlineInputBorder(
//                               borderSide: const BorderSide(color: Colors.white),
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                           ),
//                           validator: (value) {
//                             if (confirmpassController.text !=
//                                 passwordController.text) {
//                               return "Password did not match";
//                             } else {
//                               return null;
//                             }
//                           },
//                           onChanged: (value) {},
//                         ),
//                         const SizedBox(
//                           height: 20,
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             const Text(
//                               "Rool : ",
//                               style: TextStyle(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white,
//                               ),
//                             ),
//                             DropdownButton<String>(
//                               dropdownColor: Colors.blue[900],
//                               isDense: true,
//                               isExpanded: false,
//                               iconEnabledColor: Colors.white,
//                               focusColor: Colors.white,
//                               items: options.map((String dropDownStringItem) {
//                                 return DropdownMenuItem<String>(
//                                   value: dropDownStringItem,
//                                   child: Text(
//                                     dropDownStringItem,
//                                     style: const TextStyle(
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 20,
//                                     ),
//                                   ),
//                                 );
//                               }).toList(),
//                               onChanged: (newValueSelected) {
//                                 setState(() {
//                                   _currentItemSelected = newValueSelected!;
//                                   rool = newValueSelected;
//                                 });
//                               },
//                               value: _currentItemSelected,
//                             ),
//                           ],
//                         ),
//                         const SizedBox(
//                           height: 20,
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children: [
//                             MaterialButton(
//                               shape: const RoundedRectangleBorder(
//                                   borderRadius:
//                                       BorderRadius.all(Radius.circular(20.0))),
//                               elevation: 5.0,
//                               height: 40,
//                               onPressed: () {
//                                 const CircularProgressIndicator();
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => const LoginPage(),
//                                   ),
//                                 );
//                               },
//                               color: Colors.white,
//                               child: const Text(
//                                 "Login",
//                                 style: TextStyle(
//                                   fontSize: 20,
//                                 ),
//                               ),
//                             ),
//                             MaterialButton(
//                               shape: const RoundedRectangleBorder(
//                                   borderRadius:
//                                       BorderRadius.all(Radius.circular(20.0))),
//                               elevation: 5.0,
//                               height: 40,
//                               onPressed: () {
//                                 setState(() {
//                                   showProgress = true;
//                                 });
//                                 signUp(emailController.text,
//                                     passwordController.text, rool);
//                               },
//                               color: Colors.white,
//                               child: const Text(
//                                 "Register",
//                                 style: TextStyle(
//                                   fontSize: 20,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(
//                           height: 20,
//                         ),
//                         Text(
//                           "WEBFUN",
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 30,
//                             color: Colors.yellowAccent[400],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void signUp(String email, String password, String rool) async {
//     const CircularProgressIndicator();
//     if (_formkey.currentState!.validate()) {
//       await _auth
//           .createUserWithEmailAndPassword(email: email, password: password)
//           .then((value) => {postDetailsToFirestore(email, rool)})
//           .catchError((e) {});
//     }
//   }

//   postDetailsToFirestore(String email, String rool) async {
//     FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
//     var user = _auth.currentUser;
//     CollectionReference ref = FirebaseFirestore.instance.collection('users');
//     ref.doc(user!.uid).set({'email': emailController.text, 'rool': rool});
//     Navigator.pushReplacement(
//         context, MaterialPageRoute(builder: (context) => const LoginPage()));
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  bool _showProgress = false;
  bool _isPasswordObscure = true;
  bool _isConfirmPasswordObscure = true;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  List<String> roles = ['Patient', 'Doctor'];
  String selectedRole = 'Patient';

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 15, 172, 196),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: const Color.fromARGB(255, 15, 172, 196),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 80),
                      const Text(
                        "Register Now",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 30),
                      _buildTextField(
                        controller: emailController,
                        hintText: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        validator: _validateEmail,
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller: passwordController,
                        hintText: 'Password',
                        obscureText: _isPasswordObscure,
                        suffixIcon: _togglePasswordVisibility(isConfirmPassword: false),
                        validator: _validatePassword,
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller: confirmPasswordController,
                        hintText: 'Confirm Password',
                        obscureText: _isConfirmPasswordObscure,
                        suffixIcon: _togglePasswordVisibility(isConfirmPassword: true),
                        validator: _validateConfirmPassword,
                      ),
                      const SizedBox(height: 20),
                      _buildDropdownField(
                        label: "Role",
                        value: selectedRole,
                        items: roles,
                        onChanged: (newValue) {
                          setState(() {
                            selectedRole = newValue!;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      _buildActionButtons(),
                      const SizedBox(height: 20),
                      if (_showProgress)
                        const CircularProgressIndicator(color: Colors.white),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hintText,
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(20),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      validator: validator,
    );
  }

  Widget _togglePasswordVisibility({required bool isConfirmPassword}) {
    return IconButton(
      icon: Icon(isConfirmPassword
          ? _isConfirmPasswordObscure
              ? Icons.visibility_off
              : Icons.visibility
          : _isPasswordObscure
              ? Icons.visibility_off
              : Icons.visibility),
      onPressed: () {
        setState(() {
          if (isConfirmPassword) {
            _isConfirmPasswordObscure = !_isConfirmPasswordObscure;
          } else {
            _isPasswordObscure = !_isPasswordObscure;
          }
        });
      },
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                "$label: $value",
                style: const TextStyle(
                  color: Color.fromARGB(255, 47, 40, 40),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_drop_down),
            onPressed: () async {
              final String? newValue = await showDialog<String>(
                context: context,
                builder: (BuildContext context) {
                  return SimpleDialog(
                    title: Text('Select $label'),
                    children: items.map((String item) {
                      return SimpleDialogOption(
                        onPressed: () {
                          Navigator.pop(context, item);
                        },
                        child: Text(item),
                      );
                    }).toList(),
                  );
                },
              );
              if (newValue != null) {
                onChanged(newValue);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: const Text("Login", style: TextStyle(fontSize: 20)),
        ),
        ElevatedButton(
          onPressed: _register,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: const Text("Register", style: TextStyle(fontSize: 20)),
        ),
      ],
    );
  }

  String? _validateEmail(String? value) {
    if (value!.isEmpty) {
      return "Email cannot be empty";
    }
    if (!RegExp(r'^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+\.[a-z]+$')
        .hasMatch(value)) {
      return "Please enter a valid email";
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value!.isEmpty) {
      return "Password cannot be empty";
    }
    if (value.length < 6) {
      return "Password must be at least 6 characters long";
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value != passwordController.text) {
      return "Passwords do not match";
    }
    return null;
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _showProgress = true;
      });
      try {
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        await _postDetailsToFirestore(userCredential.user!.uid);
        _showRegistrationSuccessDialog();
      } catch (e) {
        print(e);
      } finally {
        setState(() {
          _showProgress = false;
        });
      }
    }
  }

  Future<void> _postDetailsToFirestore(String uid) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    CollectionReference users = firebaseFirestore.collection('users');

    await users.doc(uid).set({
      'email': emailController.text,
      'role': selectedRole,
    });
  }

  void _showRegistrationSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('Registration completed successfully!'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
