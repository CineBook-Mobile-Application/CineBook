import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../viewmodels/auth_viewmodel.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    const Color bgPurple = Color(0xFF5B0A95); // Deep purple from the image
    const Color btnPurple = Color(0xFFA020F0); // Vibrant purple button
    const Color logoYellow = Color(0xFFFFC107); // Yellow for the logo
    const Color formBg = Color(0xFFF3F4F6); // Very light grey for fields
    const Color textGrey = Color(0xFF6B7280); // Default grey text

    // Show errors if they exist
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
<<<<<<< HEAD:lib/views/login_screen.dart
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
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),
              
              // Custom Login / Sign Up Tab Mock
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Login', style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.onSurface, fontSize: 18)),
                  const SizedBox(width: 32),
                  GestureDetector(
                    onTap: () => context.pushReplacement('/signup'),
                    child: Text('Sign Up', style: TextStyle(fontWeight: FontWeight.normal, color: colorScheme.onSurfaceVariant, fontSize: 18)),
                  ),
                ],
              ),
              const SizedBox(height: 48),
=======
      backgroundColor: bgPurple,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 48), // Top spacing
>>>>>>> pr/5:CineBook/lib/views/login_screen.dart

                // Top Header (Logo + CineBook)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.movie_rounded, // Similar generic icon for movie
                      color: logoYellow, 
                      size: 32
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'CineBook',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 48),

                // White Card
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
                        decoration: BoxDecoration(
                          color: formBg,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.04),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    )
                                  ]
                                ),
                                child: const Center(
                                  child: Text(
                                    'Login',
                                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => context.pushReplacement('/signup'),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  color: Colors.transparent,
                                  child: const Center(
                                    child: Text(
                                      'Sign Up',
                                      style: TextStyle(fontWeight: FontWeight.w600, color: textGrey),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 32),

                      // Email Field
                      const Text(
                        'Email',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(fontWeight: FontWeight.w500, color: textGrey),
                        decoration: InputDecoration(
                          hintText: 'you@example.com',
                          hintStyle: const TextStyle(color: Colors.black38),
                          prefixIcon: const Icon(Icons.email_outlined, color: Colors.black38),
                          filled: true,
                          fillColor: formBg,
                          contentPadding: const EdgeInsets.symmetric(vertical: 16),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Password Field
                      const Text(
                        'Password',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        style: const TextStyle(fontWeight: FontWeight.w500, color: textGrey),
                        decoration: InputDecoration(
                          hintText: '••••••••',
                          hintStyle: const TextStyle(color: Colors.black38, letterSpacing: 2),
                          prefixIcon: const Icon(Icons.lock_outline, color: Colors.black38),
                          filled: true,
                          fillColor: formBg,
                          contentPadding: const EdgeInsets.symmetric(vertical: 16),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Remember me / Forgot password
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: Checkbox(
                                  value: _rememberMe,
                                  onChanged: (v) {
                                    setState(() { _rememberMe = v ?? false; });
                                  },
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                  side: const BorderSide(color: Colors.black38, width: 1.5),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text('Remember me', style: TextStyle(color: textGrey, fontSize: 14, fontWeight: FontWeight.w500)),
                            ],
                          ),
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text('Forgot password?', style: TextStyle(color: btnPurple, fontSize: 14, fontWeight: FontWeight.w500)),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Login Button
                      ElevatedButton(
                        onPressed: authViewModel.isLoading
                            ? null
                            : () async {
                                if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
                                  return;
                                }
                                final success = await authViewModel.login(
                                  _emailController.text.trim(),
                                  _passwordController.text.trim(),
                                );
                                if (success && mounted) {
                                  context.go('/home');
                                }
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
                            : const Text('Login', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),

                      const SizedBox(height: 32),

                      // Or Continue With Divider
                      Row(
                        children: const [
                          Expanded(child: Divider(color: Colors.black12, thickness: 1)),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text('Or continue with', style: TextStyle(color: textGrey, fontSize: 13, fontWeight: FontWeight.w500)),
                          ),
                          Expanded(child: Divider(color: Colors.black12, thickness: 1)),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Social Buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => context.go('/home'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.black87,
                                side: BorderSide(color: Colors.black.withOpacity(0.1)),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              icon: const Icon(Icons.g_mobiledata, color: Colors.black, size: 28),
                              label: const Text('Google', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => context.go('/home'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.black87,
                                side: BorderSide(color: Colors.black.withOpacity(0.1)),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              icon: const Icon(Icons.facebook, color: Colors.black, size: 22),
                              label: const Text('Facebook', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                            ),
                          ),
                        ],
                      ),
                      
                    ],
                  ),
<<<<<<< HEAD:lib/views/login_screen.dart
                  TextButton(onPressed: (){}, child: const Text('Forgot password?')),
                ],
              ),
              const SizedBox(height: 24),
              
              FilledButton(
                onPressed: authViewModel.isLoading 
                  ? null 
                  : () async {
                      if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
                         PopupUtils.showCenterPopup(
                           context: context,
                           title: 'Validation Error',
                           message: 'Please fill all fields',
                           icon: Icons.warning_amber_rounded,
                           color: AppColors.secondary,
                         );
                         return;
                      }
                      final success = await authViewModel.login(
                        _emailController.text.trim(), 
                        _passwordController.text.trim()
                      );
                      if (success && mounted) {
                        await PopupUtils.showCenterPopup(
                          context: context,
                          title: 'Success',
                          message: 'Login successful!',
                          icon: Icons.check_circle_outline,
                          color: AppColors.success,
                        );
                        if (mounted) context.go('/home');
                      } else if (!success && mounted) {
                        PopupUtils.showCenterPopup(
                          context: context,
                          title: 'Login Failed',
                          message: authViewModel.errorMessage ?? "Invalid credentials.",
                          icon: Icons.error_outline,
                          color: AppColors.error,
                        );
                      }
                  },
                child: authViewModel.isLoading 
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('Login'),
              ),
              const SizedBox(height: 32),
              
              // Social Mock
              const Center(child: Text('Or continue with', style: TextStyle(color: Colors.grey))),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => context.go('/home'), // Mock bypass
                      icon: const Icon(Icons.g_mobiledata, color: Colors.red),
                      label: Text('Google', style: TextStyle(color: colorScheme.onSurface)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => context.go('/home'), // Mock bypass
                      icon: const Icon(Icons.facebook, color: Colors.blue),
                      label: Text('Facebook', style: TextStyle(color: colorScheme.onSurface)),
                    ),
                  ),
                ],
              ),
            ],
=======
                ),
                
                const SizedBox(height: 24),
              ],
            ),
>>>>>>> pr/5:CineBook/lib/views/login_screen.dart
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
