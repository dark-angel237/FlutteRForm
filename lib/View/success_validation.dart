import 'package:flutter/material.dart';
import 'dart:io'; // Required for FileImage

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
      // Set the background color of the Scaffold to light grey
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        // Center the title
        centerTitle: true,
        // Bold and style the title text
        title: const Text(
          "User Details",
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display profile picture if available
            if (profileImagePath != null)
              Center(
                child: CircleAvatar(
                  radius: 70, // Slightly larger for better visibility
                  backgroundImage: FileImage(File(profileImagePath!)),
                  backgroundColor: Colors.grey.shade300, // Fallback background
                ),
              ),
            if (profileImagePath != null) const SizedBox(height: 24), // Space after image

            // User details
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow("Full Name:", fullName),
                    _buildDetailRow("Email:", email),
                    _buildDetailRow("Phone:", phone),
                    _buildDetailRow("Password:", "********"), // Mask password for security
                  ],
                ),
              ),
            ),

            const Spacer(), // Pushes buttons to the bottom

            // Buttons at the bottom
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Distribute buttons evenly
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate back to the registration form for editing
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade400, // Grey button for edit
                      foregroundColor: Colors.black, // Black text for edit button
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Edit Info",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(width: 16), // Space between buttons
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle final submission logic here
                      // For example, show a success message or navigate to a home screen
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Registration Finalized!")),
                      );
                      // You might want to navigate to a different screen or pop all routes
                      // Navigator.of(context).pushAndRemoveUntil(
                      //   MaterialPageRoute(builder: (context) => HomeScreen()),
                      //   (Route<dynamic> route) => false,
                      // );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2196F3), // Blue button for submit
                      foregroundColor: Colors.white, // White text for submit button
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Submit Final",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build consistent detail rows
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
