import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color primaryYellow = Color(0xFFFFC107);
    
    return Scaffold(
      body: Stack(
        children: [
          // Background Image with Purple Overlay
          Positioned.fill(
            child: Image.network(
              'https://images.unsplash.com/photo-1585647347483-22b66260dfff?q=80&w=1000&auto=format&fit=crop',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(color: const Color(0xFF4A148C)),
            ),
          ),
          Positioned.fill(
            child: Container(
              color: const Color(0xFF6B1B9A).withOpacity(0.85), // purple overlay
            ),
          ),
          
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                const SizedBox(height: 20),
                
                // Icon
                const Icon(
                  Icons.movie_rounded,
                  color: primaryYellow,
                  size: 48,
                ),
                
                const SizedBox(height: 8),
                
                // CineBook Text
                const Text(
                  'CineBook',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Tagline
                const Text(
                  'Book tickets together, pay separately',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Feature Cards
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    children: const [
                      _FeatureCard(
                        icon: Icons.people_outline,
                        title: 'Group Split-Payment',
                        description: 'Invite friends and let everyone pay their share instantly',
                      ),
                      SizedBox(height: 16),
                      _FeatureCard(
                        icon: Icons.confirmation_num_outlined,
                        title: 'AR Seat Preview',
                        description: 'See the exact view from your seat before booking',
                      ),
                      SizedBox(height: 16),
                      _FeatureCard(
                        icon: Icons.movie_filter_outlined,
                        title: 'Real-time Booking',
                        description: 'Live seat availability and instant confirmation',
                      ),
                    ],
                  ),
                ),
                
                // Buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () => context.push('/login'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryYellow,
                          foregroundColor: const Color(0xFF311B52),
                          minimumSize: const Size(double.infinity, 56),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Get Started',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 12),
                      
                      OutlinedButton(
                        onPressed: () => context.go('/home'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: BorderSide(color: Colors.white.withOpacity(0.5), width: 1),
                          minimumSize: const Size(double.infinity, 56),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Browse as Guest',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Bottom Footer
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.bottom + 16,
                    top: 16,
                  ),
                  color: const Color(0xFF322865), // Bottom dark block
                  child: const Text(
                    'PUSL2023 - Mobile Application Development',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: const Color(0xFFFFC107), size: 28),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
