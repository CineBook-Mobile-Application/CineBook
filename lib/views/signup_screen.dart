import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../viewmodels/auth_viewmodel.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _agreeToTerms = false;

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    const Color bgPurple = Color(0xFF5B0A95);
    const Color btnPurple = Color(0xFFA020F0);
    const Color logoYellow = Color(0xFFFFC107);
    const Color formBg = Color(0xFFF3F4F6);
    const Color textGrey = Color(0xFF6B7280);

    if (authViewModel.errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(authViewModel.errorMessage!), backgroundColor: Colors.red),
        );
        authViewModel.clearError();
      });
    }

    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
<<<<<<< HEAD:lib/views/signup_screen.dart
      backgroundColor: colorScheme.primary,
      appBar: AppBar(
        title: const Text('CineBook', style: TextStyle(color: Colors.white)),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 24),
        decoration: BoxDecoration(
          color: colorScheme.background,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              
              // Custom Login / Sign Up Tab Mock
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => context.pushReplacement('/login'),
                    child: Text('Login', style: TextStyle(fontWeight: FontWeight.normal, color: colorScheme.onSurfaceVariant, fontSize: 18)),
                  ),
                  const SizedBox(width: 32),
                  Text('Sign Up', style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.onSurface, fontSize: 18)),
                ],
              ),
              const SizedBox(height: 48),

              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  hintText: 'John Doe',
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'you@example.com',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  hintText: '+94 77 123 4567',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Checkbox(value: false, onChanged: (v){}),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 12),
                        children: [
                          const TextSpan(text: 'I agree to the '),
                          TextSpan(text: 'Terms of Service', style: TextStyle(color: colorScheme.primary)),
                          const TextSpan(text: ' and '),
                          TextSpan(text: 'Privacy Policy', style: TextStyle(color: colorScheme.primary)),
=======
      backgroundColor: bgPurple,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 48),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.movie_rounded, color: logoYellow, size: 32),
                    const SizedBox(width: 12),
                    const Text(
                      'CineBook',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 48),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Toggle
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(color: formBg, borderRadius: BorderRadius.circular(24)),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => context.pushReplacement('/login'),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  color: Colors.transparent,
                                  child: const Center(
                                    child: Text('Login', style: TextStyle(fontWeight: FontWeight.w600, color: textGrey)),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4, offset: const Offset(0, 2))]
                                ),
                                child: const Center(
                                  child: Text('Sign Up', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      _buildField('Full Name', _nameController, Icons.person_outline, 'John Doe', formBg, textGrey),
                      const SizedBox(height: 16),
                      _buildField('Email', _emailController, Icons.email_outlined, 'you@example.com', formBg, textGrey, keyboardType: TextInputType.emailAddress),
                      const SizedBox(height: 16),
                      _buildField('Phone Number', _phoneController, Icons.phone_outlined, '+94 77 123 4567', formBg, textGrey, keyboardType: TextInputType.phone),
                      const SizedBox(height: 16),
                      _buildField('Password', _passwordController, Icons.lock_outline, '••••••••', formBg, textGrey, obscureText: true),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          SizedBox(
                            width: 24, height: 24,
                            child: Checkbox(
                              value: _agreeToTerms,
                              onChanged: (v) => setState(() => _agreeToTerms = v ?? false),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                              side: const BorderSide(color: Colors.black38, width: 1.5),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: RichText(
                              text: const TextSpan(
                                style: TextStyle(color: textGrey, fontSize: 13, fontWeight: FontWeight.w500),
                                children: [
                                  TextSpan(text: 'I agree to the '),
                                  TextSpan(text: 'Terms of Service', style: TextStyle(color: btnPurple)),
                                  TextSpan(text: ' and '),
                                  TextSpan(text: 'Privacy Policy', style: TextStyle(color: btnPurple)),
                                ],
                              ),
                            ),
                          ),
>>>>>>> pr/5:CineBook/lib/views/signup_screen.dart
                        ],
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: authViewModel.isLoading ? null : () async {
                          if (_emailController.text.isEmpty || _passwordController.text.isEmpty || _nameController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
                            return;
                          }
                          final success = await authViewModel.signUp(_nameController.text.trim(), _emailController.text.trim(), _passwordController.text.trim(), _phoneController.text.trim());
                          if (success && mounted) context.go('/home');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: btnPurple,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: btnPurple.withOpacity(0.5),
                          elevation: 0,
                          minimumSize: const Size(double.infinity, 52),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: authViewModel.isLoading
                          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Text('Create Account', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
<<<<<<< HEAD:lib/views/signup_screen.dart
                ],
              ),
              const SizedBox(height: 24),
              
              FilledButton(
                onPressed: authViewModel.isLoading 
                  ? null 
                  : () async {
                      if (_emailController.text.isEmpty || _passwordController.text.isEmpty || _nameController.text.isEmpty) {
                         PopupUtils.showCenterPopup(
                           context: context,
                           title: 'Validation Error',
                           message: 'Please fill all required fields',
                           icon: Icons.warning_amber_rounded,
                           color: AppColors.secondary,
                         );
                         return;
                      }
                      final success = await authViewModel.signUp(
                        _nameController.text.trim(),
                        _emailController.text.trim(), 
                        _passwordController.text.trim(),
                        _phoneController.text.trim()
                      );
                      if (success && mounted) {
                        await PopupUtils.showCenterPopup(
                          context: context,
                          title: 'Success',
                          message: 'Account created successfully!',
                          icon: Icons.check_circle_outline,
                          color: AppColors.success,
                        );
                        if (mounted) context.go('/home');
                      } else if (!success && mounted) {
                        PopupUtils.showCenterPopup(
                          context: context,
                          title: 'Sign Up Failed',
                          message: authViewModel.errorMessage ?? "Error occurred.",
                          icon: Icons.error_outline,
                          color: AppColors.error,
                        );
                      }
                  },
                child: authViewModel.isLoading 
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('Create Account'),
              ),
            ],
=======
                ),
                const SizedBox(height: 24),
              ],
            ),
>>>>>>> pr/5:CineBook/lib/views/signup_screen.dart
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, IconData icon, String hint, Color bg, Color textGrey, {bool obscureText = false, TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black87),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.black38, letterSpacing: obscureText ? 2 : 0),
            prefixIcon: Icon(icon, color: Colors.black38),
            filled: true,
            fillColor: bg,
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
