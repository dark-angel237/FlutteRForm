import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_validation/Components/input_field.dart';
import 'package:flutter_form_validation/Provider/setting_provider.dart';
import 'package:flutter_form_validation/View/success_validation.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart'; // Import for image_picker
import 'dart:io'; // Import for File

class FormValidation extends StatefulWidget {
  const FormValidation({super.key});

  @override
  State<FormValidation> createState() => _FormValidationState();
}

class _FormValidationState extends State<FormValidation> {
  final fullName = TextEditingController();
  final phone = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  final email = TextEditingController();

  File? _profileImage; // Variable to store the selected image file
  final ImagePicker _picker = ImagePicker(); // Instance of ImagePicker

  // Initialize provider here or through context if it's provided higher up the tree
  final provider = SettingsProvider();
  final formKey = GlobalKey<FormState>();

  // Function to pick an image from the gallery
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    fullName.dispose();
    phone.dispose();
    password.dispose();
    confirmPassword.dispose();
    email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Set the background color of the Scaffold to light grey
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        // Center the title
        centerTitle: true,
        // Bold and style the title text
        title: const Text(
          "User Registration",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white, // Text color for the app bar title
          ),
        ),
        // Set the background color of the AppBar to blue
        backgroundColor: const Color(0xFF2196F3),
        // Set the foreground color for icons and text in the app bar
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0), // Add padding around the form
          child: Column(
            children: [
              // Profile Picture Section
              GestureDetector(
                onTap: _pickImage, // Call _pickImage when tapped
                child: CircleAvatar(
                  radius: 60, // Size of the circle avatar
                  backgroundColor: Colors.grey.shade300, // Light grey background for placeholder
                  backgroundImage: _profileImage != null
                      ? FileImage(_profileImage!) // Display selected image
                      : null,
                  child: _profileImage == null
                      ? Icon(
                    Icons.camera_alt,
                    size: 50,
                    color: Colors.grey.shade600, // Icon color
                  )
                      : null,
                ),
              ),
              const SizedBox(height: 24.0), // Space below the profile picture

              //Full name
              InputField(
                icon: Icons.account_circle_rounded,
                label: "Full name",
                controller: fullName,
                validator: (value) =>
                    provider.validator(value, "Full name is required"),
              ),
              // Add some spacing between fields
              const SizedBox(height: 16.0),

              //Email validator
              InputField(
                icon: Icons.email,
                label: "Email",
                controller: email,
                inputType: TextInputType.emailAddress,
                validator: (value) => provider.emailValidator(value),
              ),
              const SizedBox(height: 16.0),

              //Phone number
              InputField(
                icon: Icons.phone,
                label: "Phone",
                controller: phone,
                inputType: TextInputType.phone,
                inputFormat: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (value) => provider.phoneValidator(value),
              ),
              const SizedBox(height: 16.0),

              //Password
              Consumer<SettingsProvider>(
                builder: (context, notifier, child) {
                  return InputField(
                    icon: Icons.lock,
                    label: "Password",
                    controller: password,
                    isVisible: !notifier.isVisible,
                    trailing: IconButton(
                      onPressed: () => notifier.showHidePassword(),
                      icon: Icon(!notifier.isVisible
                          ? Icons.visibility_off
                          : Icons.visibility),
                    ),
                    validator: (value) => provider.passwordValidator(value),
                  );
                },
              ),
              const SizedBox(height: 16.0),

              //Confirm password
              Consumer<SettingsProvider>(
                builder: (context, notifier, child) {
                  return InputField(
                    icon: Icons.lock,
                    label: "Confirm password",
                    controller: confirmPassword,
                    isVisible: !notifier.isVisible,
                    trailing: IconButton(
                      onPressed: () => notifier.showHidePassword(),
                      icon: Icon(!notifier.isVisible
                          ? Icons.visibility_off
                          : Icons.visibility),
                    ),
                    validator: (value) =>
                        provider.confirmPass(value, password.text),
                  );
                },
              ),
              const SizedBox(height: 32.0), // More space before the button

              // Submit Button
              SizedBox(
                width: double.infinity, // Make the button take full width
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      // If form is validated, navigate to UserDetailsPage with the form data
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserDetailsPage(
                            fullName: fullName.text,
                            email: email.text,
                            phone: phone.text,
                            password: password.text,
                            profileImagePath: _profileImage?.path, // Pass the image path
                          ),
                        ),
                      );
                    } else {
                      // Otherwise show a message
                      provider.showSnackBar("Fix the error", context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2196F3), // Blue button background
                    foregroundColor: Colors.white, // White text color for the button
                    padding: const EdgeInsets.symmetric(vertical: 15), // Add padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Rounded corners for the button
                    ),
                  ),
                  child: const Text(
                    "Submit",
                    style: TextStyle(fontSize: 18),
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

// Assuming UserDetailsPage exists and can accept a profileImagePath
// If not, you might need to adjust this or provide its code.
// Example placeholder for UserDetailsPage:
/*
class UserDetailsPage extends StatelessWidget {
  final String fullName;
  final String email;
  final String phone;
  final String password;
  final String? profileImagePath; // Added for profile image

  const UserDetailsPage({
    super.key,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.password,
    this.profileImagePath, // Make it optional
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Details"),
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (profileImagePath != null)
              Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: FileImage(File(profileImagePath!)),
                ),
              ),
            if (profileImagePath != null) const SizedBox(height: 20),
            Text("Full Name: $fullName", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text("Email: $email", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text("Phone: $phone", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text("Password (hashed/hidden): ${password.replaceAll(RegExp(r'.'), '*')}", style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
*/
