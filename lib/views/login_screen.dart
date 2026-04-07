import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../core/app_colors.dart';
import '../core/popup_utils.dart';

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
    final colorScheme = Theme.of(context).colorScheme;
    
    const Color logoYellow = Color(0xFFFFC107);
    const Color textGrey = Color(0xFF6B7280);

    // Show errors if they exist
    if (authViewModel.errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        PopupUtils.showCenterPopup(
          context: context,
          title: 'Login Error',
          message: authViewModel.errorMessage!,
          icon: Icons.error_outline,
          color: colorScheme.error,
        );
        authViewModel.clearError();
      });
    }

    return Scaffold(
      backgroundColor: colorScheme.primary,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),
                  // Top Header (Logo + CineBook)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.movie_rounded,
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
                      color: colorScheme.surface,
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
                            color: colorScheme.surfaceVariant.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    color: colorScheme.surface,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.04),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      )
                                    ]
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Login',
                                      style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.onSurface),
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
                                    child: Center(
                                      child: Text(
                                        'Sign Up',
                                        style: TextStyle(fontWeight: FontWeight.w600, color: colorScheme.onSurfaceVariant),
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
                        Text(
                          'Email',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(fontWeight: FontWeight.w500, color: colorScheme.onSurface),
                          decoration: InputDecoration(
                            hintText: 'you@example.com',
                            hintStyle: TextStyle(color: colorScheme.onSurfaceVariant.withOpacity(0.5)),
                            prefixIcon: Icon(Icons.email_outlined, color: colorScheme.onSurfaceVariant.withOpacity(0.5)),
                            filled: true,
                            fillColor: colorScheme.surfaceVariant.withOpacity(0.3),
                            contentPadding: const EdgeInsets.symmetric(vertical: 16),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Password Field
                        Text(
                          'Password',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          style: TextStyle(fontWeight: FontWeight.w500, color: colorScheme.onSurface),
                          decoration: InputDecoration(
                            hintText: '••••••••',
                            hintStyle: TextStyle(color: colorScheme.onSurfaceVariant.withOpacity(0.5), letterSpacing: 2),
                            prefixIcon: Icon(Icons.lock_outline, color: colorScheme.onSurfaceVariant.withOpacity(0.5)),
                            filled: true,
                            fillColor: colorScheme.surfaceVariant.withOpacity(0.3),
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
                                    side: BorderSide(color: colorScheme.onSurfaceVariant, width: 1.5),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text('Remember me', style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 13, fontWeight: FontWeight.w500)),
                              ],
                            ),
                            TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text('Forgot password?', style: TextStyle(color: colorScheme.primary, fontSize: 13, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Login Button
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
                                       color: logoYellow,
                                     );
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
                          style: FilledButton.styleFrom(
                            elevation: 0,
                            minimumSize: const Size(double.infinity, 52),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: authViewModel.isLoading
                              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                              : const Text('Login', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),

                        const SizedBox(height: 32),

                        // Or Continue With Divider
                        Row(
                          children: [
                            Expanded(child: Divider(color: colorScheme.outlineVariant, thickness: 1)),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text('Or continue with', style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 13, fontWeight: FontWeight.w500)),
                            ),
                            Expanded(child: Divider(color: colorScheme.outlineVariant, thickness: 1)),
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
                                  foregroundColor: colorScheme.onSurface,
                                  side: BorderSide(color: colorScheme.outlineVariant),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                icon: const Icon(Icons.g_mobiledata, color: Colors.red, size: 28),
                                label: const Text('Google', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => context.go('/home'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: colorScheme.onSurface,
                                  side: BorderSide(color: colorScheme.outlineVariant),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                icon: const Icon(Icons.facebook, color: Colors.blue, size: 22),
                                label: const Text('Facebook', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                              ),
                            ),
                          ],
                        ),
                        
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
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
