import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hoodhappen_creator/features/authentication/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String userType = 'CREATOR';

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // 🔵 Deep black with subtle purple
          Container(decoration: const BoxDecoration(color: Color(0xFF090D11))),

          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white.withOpacity(0.18)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Text(
                            "🎉 Create an Account",
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Join HoodHappen and start hosting events!",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white70,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 28),
                          _buildInputField(
                            context,
                            keyboard: TextInputType.name,
                            textCapitalization: TextCapitalization.words,
                            icon: Icons.person,
                            controller: nameController,
                            hint: "Full Name",
                            validator: (val) =>
                                val!.isEmpty ? 'Name is required' : null,
                          ),
                          const SizedBox(height: 16),
                          _buildInputField(
                            context,
                            icon: Icons.email,
                            keyboard: TextInputType.emailAddress,
                            controller: emailController,
                            hint: "Email Address",
                            validator: (val) =>
                                val!.isEmpty ? 'Email is required' : null,
                          ),
                          const SizedBox(height: 16),
                          _buildInputField(
                            context,
                            icon: Icons.lock,
                            controller: passwordController,
                            hint: "Password",
                            obscure: true,
                            validator: (val) =>
                                val!.length < 6 ? 'Minimum 6 characters' : null,
                          ),
                          const SizedBox(height: 16),
                          _buildInputField(
                            context,
                            icon: Icons.lock_outline,
                            controller: confirmPasswordController,
                            hint: "Confirm Password",
                            obscure: true,
                            validator: (val) => val != passwordController.text
                                ? 'Passwords do not match'
                                : null,
                          ),
                          const SizedBox(height: 26),
                          _buildGradientButton(context, authProvider),
                          const SizedBox(height: 16),
                          Divider(color: Colors.white12, thickness: 1),
                          const SizedBox(height: 12),
                          RichText(
                            text: TextSpan(
                              text: 'Already have an account? ',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.white,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Login',
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    color: Colors.white, // Royal Purple
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => context.push('/login'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(
    BuildContext context, {
    TextInputType? keyboard,
    required IconData icon,
    TextCapitalization textCapitalization = TextCapitalization.none,
    required TextEditingController controller,
    required String hint,
    String? Function(String?)? validator,
    bool obscure = false,
  }) {
    return TextFormField(
      keyboardType: keyboard,
      controller: controller,
      obscureText: obscure,
      textCapitalization: textCapitalization,
      validator: validator,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.white70), // Royal Purple icon
        filled: true,
        fillColor: Colors.white.withOpacity(0.07),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildGradientButton(BuildContext context, AuthProvider authProvider) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        borderRadius: BorderRadius.circular(14),
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.deepPurple,
            borderRadius: BorderRadius.circular(14),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: authProvider.isLoading
                ? null
                : () async {
                    if (_formKey.currentState!.validate()) {
                      await authProvider.registerUser(
                        name: nameController.text,
                        email: emailController.text,
                        password: passwordController.text,
                      );
                      if (authProvider.error == null && mounted) {
                        context.go('/home');
                      } else if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Registration failed"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
            child: Container(
              height: 52,
              alignment: Alignment.center,
              child: authProvider.isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      "Create Account",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 1.1,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
