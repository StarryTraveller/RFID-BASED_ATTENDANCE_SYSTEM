import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconly/iconly.dart';
import 'package:nlrc_rfid_scanner/assets/themeData.dart';
import 'package:nlrc_rfid_scanner/main.dart';
import 'package:nlrc_rfid_scanner/screens/admin_page.dart';

class LoginWidget extends StatefulWidget {
  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  bool _isPasswordVisible = false;
  // Hash the input password using SHA-256
  String _hashPassword(String inputPassword) {
    return sha256.convert(utf8.encode(inputPassword)).toString();
  }

  // Validate the login credentials
  Future<void> _validateLogin(BuildContext context) async {
    String inputUsername = username.text.trim();
    String inputPassword = password.text.trim();

    if (inputUsername.isEmpty || inputPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        snackBarFailed('Username and password cannot be empty', context),
      );
      return;
    }

    try {
      if (adminData != null) {
        String storedUsername = adminData?['username'];
        String storedHashedPassword = adminData?['password'];

        // Hash the input password and compare
        if (inputUsername == storedUsername &&
            _hashPassword(inputPassword) == storedHashedPassword) {
          // Login successful
          ScaffoldMessenger.of(context).showSnackBar(
            snackBarSuccess('Login successful', context),
          );
          Navigator.pop(context);
          Navigator.pop(context);
          // Navigate to the AdminPage
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AdminPage()),
          );
        } else {
          // Invalid credentials
          ScaffoldMessenger.of(context).showSnackBar(
            snackBarFailed('Invalid username or password', context),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          snackBarFailed('Admin data not loaded', context),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        snackBarFailed('$e', context),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      content: Card(
        /* margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.sizeOf(context).width * 0.36,
          vertical: MediaQuery.sizeOf(context).height * 0.3,
        ), */
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Admin Log in',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              _buildTextField('Username', username),
              SizedBox(height: 10),
              _buildTextField('Password', password),
              SizedBox(height: 30),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    width: 100,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent,
                      foregroundColor: Color.fromARGB(255, 60, 45, 194),
                    ),
                    onPressed: () {
                      _validateLogin(context);
                    },
                    child: Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.unlock,
                          color: Color.fromARGB(255, 60, 45, 194),
                          size: 15,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Log in',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        obscureText:
            label == 'Password' && !_isPasswordVisible, // Toggle visibility
        decoration: InputDecoration(
          prefixIcon: label == 'Password'
              ? Icon(
                  IconlyLight.password,
                )
              : Icon(
                  IconlyLight.profile,
                ),
          suffixIcon: label == 'Password'
              ? IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                )
              : null,
          labelStyle: TextStyle(fontWeight: FontWeight.bold, height: 0.5),
          labelText: label,
          hintText: 'Enter $label',
          border: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20,
          ),
        ),
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
