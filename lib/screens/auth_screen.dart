import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/animated_widgets.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController =
      TextEditingController(text: 'abcd1234@gmail.com');
  final TextEditingController _passwordController =
      TextEditingController(text: 'ABCDabcd@1234');

  bool isSignUp = false;
  bool isLoading = false;
  String errorMessage = '';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      if (isSignUp) {
        // Explicit Sign Up
        await _auth.signUpWithEmail(email, password);
      } else {
        // Strict Sign In only (no auto-registration)
        await _auth.signInWithEmail(email, password);
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString().contains('user-not-found')
            ? 'No account found for this email. Please switch to Sign Up.'
            : e.toString().contains('wrong-password') || e.toString().contains('invalid-credential')
                ? 'Incorrect password.'
                : e.toString().split('] ').last;
      });
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _googleSignIn() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });
    try {
      await _auth.signInWithGoogle();
    } catch (e) {
      setState(() {
        errorMessage = 'Google Sign-In failed: ${e.toString().split('] ').last}';
      });
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 248, 250),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.restaurant,
                    size: 64,
                    color: Color.fromARGB(255, 199, 36, 14),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isSignUp ? 'Create Account' : 'Welcome Back',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),

                  if (errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        errorMessage,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red, fontSize: 13),
                      ),
                    ),

                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (v) =>
                        v != null && v.contains('@') ? null : 'Enter a valid email',
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (v) =>
                        v != null && v.length >= 6 ? null : 'Minimum 6 characters',
                  ),
                  const SizedBox(height: 20),

                  if (isLoading)
                    const PulseLoadingIndicator()
                  else ...[
                    AnimatedScalePress(
                      onTap: _submit,
                      child: Container(
                        width: double.infinity,
                        height: 48,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 199, 36, 14),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          isSignUp ? 'Sign Up' : 'Sign In',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    OutlinedButton.icon(
                      onPressed: _googleSignIn,
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(
                        Icons.g_mobiledata,
                        size: 28,
                        color: Colors.blue,
                      ),
                      label: const Text('Continue with Google'),
                    ),

                    TextButton(
                      onPressed: () => setState(() {
                        isSignUp = !isSignUp;
                        errorMessage = '';
                      }),
                      child: Text(
                        isSignUp
                            ? 'Already have an account? Sign In'
                            : 'Need an account? Sign Up',
                        style: const TextStyle(
                          color: Color.fromARGB(255, 199, 36, 14),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}