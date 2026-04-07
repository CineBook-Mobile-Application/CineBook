import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import '../core/app_colors.dart';
import '../models/core_models.dart';
import '../services/database_service.dart';
import '../services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = true;
  UserProfile? _userProfile;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final profile = await DatabaseService().getUserProfile(user.uid);
      if (mounted) {
        setState(() {
          _userProfile = profile;
          _isLoading = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: colorScheme.surface,
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator()) 
        : _userProfile == null 
          ? const Center(child: Text("No Profile Found. Please sign in.")) 
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 32),
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: colorScheme.primaryContainer,
                      child: Text(
                        _userProfile!.fullName.isNotEmpty ? _userProfile!.fullName[0].toUpperCase() : 'U',
                        style: TextStyle(fontSize: 40, color: colorScheme.onPrimaryContainer, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      _userProfile!.fullName,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: colorScheme.onBackground),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _userProfile!.email,
                      style: TextStyle(fontSize: 16, color: colorScheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: 48),
                    _buildProfileItem(Icons.phone, 'Phone Number', _userProfile!.phone.isNotEmpty ? _userProfile!.phone : 'Not provided'),
                    const SizedBox(height: 16),
                    _buildProfileItem(Icons.calendar_today, 'Member Since', '${_userProfile!.createdAt.year}-${_userProfile!.createdAt.month.toString().padLeft(2, '0')}-${_userProfile!.createdAt.day.toString().padLeft(2, '0')}'),
                    const SizedBox(height: 48),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          await AuthService().signOut();
                          if (context.mounted) {
                            context.go('/login');
                          }
                        },
                        icon: const Icon(Icons.logout, color: Colors.red),
                        label: const Text('Sign Out', style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold)),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.red),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildProfileItem(IconData icon, String title, String subtitle) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: colorScheme.primaryContainer, shape: BoxShape.circle),
        child: Icon(icon, color: colorScheme.onPrimaryContainer),
      ),
      title: Text(title, style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 14)),
      subtitle: Text(subtitle, style: TextStyle(color: colorScheme.onSurface, fontSize: 16, fontWeight: FontWeight.w600)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      tileColor: colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }
}
