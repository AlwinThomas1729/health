import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Patient.dart';
import 'doctor.dart';
import 'register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isPasswordVisible = true;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _buildLoginForm(context),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 15, 172, 196),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.70,
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(12),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                const Text(
                  "Login",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 40,
                  ),
                ),
                const SizedBox(height: 20),
                _buildEmailField(),
                const SizedBox(height: 20),
                _buildPasswordField(),
                const SizedBox(height: 20),
                _buildLoginButton(),
                const SizedBox(height: 10),
                if (isLoading)
                  const CircularProgressIndicator(
                    color: Colors.white,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: emailController,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: 'Email',
        contentPadding:
            const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return "Email cannot be empty";
        }
        if (!RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+\.[a-z]+$")
            .hasMatch(value)) {
          return "Please enter a valid email";
        }
        return null;
      },
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: passwordController,
      obscureText: _isPasswordVisible,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
        filled: true,
        fillColor: Colors.white,
        hintText: 'Password',
        contentPadding:
            const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 15.0),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return "Password cannot be empty";
        }
        if (value.length < 6) {
          return "Password must be at least 6 characters long";
        }
        return null;
      },
    );
  }

  Widget _buildLoginButton() {
    return MaterialButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      elevation: 5.0,
      height: 40,
      onPressed: () {
        setState(() {
          isLoading = true;
        });
        signIn(emailController.text, passwordController.text);
      },
      color: Colors.white,
      child: const Text(
        "Login",
        style: TextStyle(fontSize: 20),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              elevation: 5.0,
              height: 40,
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Register()),
                );
              },
              color: Colors.blue[900],
              child: const Text(
                "Register Now",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  Future<void> signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        routeUser();
      } on FirebaseAuthException catch (e) {
        setState(() {
          isLoading = false;
        });
        _showError(e);
      }
    }
  }

  void routeUser() async {
    User? user = _auth.currentUser;
    if (user != null) {
      var documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (documentSnapshot.exists) {
        String role = documentSnapshot.get('role');
        if (role == "Doctor") {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const Doctor()));
        } else {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const Patient()));
        }
      }
    }
  }

  void _showError(FirebaseAuthException e) {
    String errorMessage = 'An error occurred';
    if (e.code == 'user-not-found') {
      errorMessage = 'No user found for that email.';
    } else if (e.code == 'wrong-password') {
      errorMessage = 'Wrong password provided.';
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMessage)),
    );
  }
}
