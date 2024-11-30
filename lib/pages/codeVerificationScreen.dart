// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:milestone/buttons/custom_button.dart';
import '../theme/app_theme.dart';

class codeVerificationScreen extends StatefulWidget {
  @override
  _codeVerificationScreenState createState() => _codeVerificationScreenState();
}

class _codeVerificationScreenState extends State<codeVerificationScreen> {
  final List<TextEditingController> _controllers = List.generate(
      5, (index) => TextEditingController()); // Controllers for 5 text fields

  @override
  void dispose() {
    // Dispose of controllers when the screen is removed
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget _buildCodeField(int index) {
    return Container(
      width: 50,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: TextField(
        controller: _controllers[index],
        textAlign: TextAlign.center,
        maxLength: 1,
        keyboardType: TextInputType.number,
        style: TextStyle(
            fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        decoration: InputDecoration(
          counterText: '', // Hides character counter
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.greenAccent, width: 2),
          ),
        ),
        onChanged: (value) {
          // Automatically move to next field if a digit is entered
          if (value.isNotEmpty && index < 4) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context)
              .unfocus(); // Tüm TextField'lardan odağı kaldırır
        },
        child: Container(
          decoration: const BoxDecoration(
            gradient: appBackground,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Instruction Text
                Text(
                  'We sent a reset link to contact@dscode...com\nEnter 5 digit code that mentioned in the email',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                SizedBox(height: height * 0.05),

                // Row for 5 Code Fields
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) => _buildCodeField(index)),
                ),
                SizedBox(height: height * 0.05),

                // Submit Button
                CustomButton(
                  button_text: 'Onayla',
                  onPressed: () {
                    // Collect and print code for debugging
                    String code = _controllers.map((c) => c.text).join();
                    print("Entered code: $code");
                    Navigator.pushNamed(context, '/succes');
                    // Handle code submission logic here
                  },
                ),
                SizedBox(height: height * 0.05),

                // Resend Text
                TextButton(
                  onPressed: () {
                    // Handle resend action here
                    print("Resend code clicked");
                  },
                  child: Text(
                    "Haven't got the email yet? Resend email",
                    style: TextStyle(color: Colors.greenAccent),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
