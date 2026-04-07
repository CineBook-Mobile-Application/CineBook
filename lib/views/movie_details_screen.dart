import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import '../core/app_colors.dart';
import '../viewmodels/home_viewmodel.dart';
import '../models/core_models.dart';

class MovieDetailsScreen extends StatefulWidget {
  final String id;
  const MovieDetailsScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  late YoutubePlayerController _controller;
  bool _isPlayingTrailer = false;

  @override
  void initState() {
    super.initState();
    // Default video ID provided by user
    _controller = YoutubePlayerController.fromVideoId(
      videoId: 'kgv8jf_8dm0',
      autoPlay: true,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HomeViewModel>(context, listen: false);
    final allMovies = viewModel.currentMovies.isNotEmpty 
        ? viewModel.currentMovies 
        : [Movie(id: '1', title: 'Loading...', genre: '', duration: '', rating: 0.0, posterUrl: '', synopsis: '', isNowShowing: true)];
    final movie = allMovies.firstWhere((m) => m.id == widget.id, orElse: () => allMovies.first);

    const Color primaryPurple = Color(0xFFA020F0);
    const Color logoYellow = Color(0xFFFFC107);

    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
<<<<<<< HEAD:lib/views/movie_details_screen.dart
      backgroundColor: colorScheme.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    color: colorScheme.surfaceVariant,
                    child: Image.asset(
                      movie.posterUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Center(
                        child: Icon(Icons.movie, size: 64, color: Colors.white),
                      ),
                    ),
=======
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Hero Image Backdrop or Trailer
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.5,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (!_isPlayingTrailer) ...[
                  Builder(
                    builder: (context) {
                      String? assetPath;
                      final title = movie.title.toLowerCase();
                      
                      if (title.contains('black')) {
                        assetPath = 'assets/images/black.jpg';
                      } else if (title.contains('interstellar') || title.contains('star')) {
                        assetPath = 'assets/images/intes.jpg';
                      } else if (title.contains('oppenheimer') || title.contains('open')) {
                        assetPath = 'assets/images/open.jpg';
                      } else {
                        switch (movie.id) {
                          case '1': assetPath = 'assets/images/img1.jpg'; break;
                          case '2': assetPath = 'assets/images/black.jpg'; break;
                          case '3': assetPath = 'assets/images/intes.jpg'; break;
                          case '4': assetPath = 'assets/images/open.jpg'; break;
                        }
                      }

                      if (assetPath != null) {
                        return Image.asset(
                          assetPath,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Image.network(
                            movie.posterUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(color: Colors.grey.shade300),
                          ),
                        );
                      }
                      
                      return Image.network(
                        movie.posterUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(color: Colors.grey.shade300),
                      );
                    },
>>>>>>> pr/5:CineBook/lib/views/movie_details_screen.dart
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.4),
                          Colors.transparent,
                          Colors.black.withOpacity(0.6),
                        ],
                      ),
                    ),
                  ),
                  // Watch Trailer Button
                  Center(
<<<<<<< HEAD:lib/views/movie_details_screen.dart
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.play_arrow, color: colorScheme.onSecondaryContainer),
                          const SizedBox(width: 8),
                          Text('Watch Trailer', style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.onSecondaryContainer)),
=======
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isPlayingTrailer = true;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: logoYellow,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.play_arrow_rounded, size: 24),
                          SizedBox(width: 8),
                          Text('Watch Trailer', style: TextStyle(fontWeight: FontWeight.bold)),
>>>>>>> pr/5:CineBook/lib/views/movie_details_screen.dart
                        ],
                      ),
                    ),
                  ),
                ] else
                  YoutubePlayer(
                    controller: _controller,
                    aspectRatio: 16 / 9,
                  ),
              ],
            ),
          ),
<<<<<<< HEAD:lib/views/movie_details_screen.dart
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
                boxShadow: [
                  BoxShadow(color: colorScheme.shadow.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))
                ],
              ),
              transform: Matrix4.translationValues(0, -32, 0),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                movie.title,
                                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                movie.genre,
                                style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: colorScheme.secondaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.star, size: 16, color: colorScheme.onSecondaryContainer),
                              const SizedBox(width: 4),
                              Text('${movie.rating}/10', style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.onSecondaryContainer)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 16, color: AppColors.textSecondary),
                        const SizedBox(width: 8),
                        Text(movie.duration, style: const TextStyle(color: AppColors.textSecondary)),
                        const SizedBox(width: 16),
                        const Icon(Icons.calendar_today, size: 16, color: AppColors.textSecondary),
                        const SizedBox(width: 8),
                        const Text('Releasing Today', style: TextStyle(color: AppColors.textSecondary)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: () {
                        context.push('/cinemas/${movie.id}');
                      },
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(double.infinity, 56),
=======

          // Custom App Bar Actions
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.black26,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => context.pop(),
                  ),
                ),
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.black26,
                      child: IconButton(
                        icon: const Icon(Icons.share_outlined, color: Colors.white),
                        onPressed: () {},
>>>>>>> pr/5:CineBook/lib/views/movie_details_screen.dart
                      ),
                    ),
<<<<<<< HEAD:lib/views/movie_details_screen.dart
                    const SizedBox(height: 32),
                    const Text(
                      'Synopsis',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      movie.synopsis,
                      style: const TextStyle(color: AppColors.textSecondary, height: 1.5),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'Cast & Crew',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    // Mock cast
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 4,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: AppColors.primary.withOpacity(0.2),
                                  child: Text('A${index + 1}', style: const TextStyle(color: AppColors.secondary)),
                                ),
                                const SizedBox(height: 8),
                                const Text('Actor Name', style: TextStyle(fontSize: 12)),
                              ],
                            ),
                          );
                        },
=======
                    const SizedBox(width: 12),
                    CircleAvatar(
                      backgroundColor: Colors.black26,
                      child: IconButton(
                        icon: const Icon(Icons.favorite_border, color: Colors.white),
                        onPressed: () {},
>>>>>>> pr/5:CineBook/lib/views/movie_details_screen.dart
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Details Card
          Positioned.fill(
            child: DraggableScrollableSheet(
              initialChildSize: 0.55,
              minChildSize: 0.55,
              maxChildSize: 0.9,
              builder: (context, scrollController) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -5))
                    ],
                  ),
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 100),
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  movie.title,
                                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  movie.genre,
                                  style: const TextStyle(color: Colors.black45, fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: logoYellow,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.star, size: 16, color: Colors.black),
                                const SizedBox(width: 4),
                                Text(
                                  '${movie.rating}/10',
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          _buildInfoItem(Icons.access_time_rounded, movie.duration),
                          const SizedBox(width: 24),
                          _buildInfoItem(Icons.calendar_today_rounded, '15/03/2026'),
                        ],
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () => context.push('/cinemas/${movie.id}'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryPurple,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 56),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        child: const Text('Book Tickets', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 32),
                      _buildSectionCard(
                        'Synopsis',
                        Text(
                          movie.synopsis,
                          style: const TextStyle(color: Colors.black54, fontSize: 15, height: 1.6),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildSectionCard(
                        'Cast & Crew',
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Director', style: TextStyle(fontSize: 13, color: Colors.black38, fontWeight: FontWeight.w500)),
                            const SizedBox(height: 4),
                            Text(movie.director, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87)),
                            const SizedBox(height: 20),
                            const Text('Cast', style: TextStyle(fontSize: 13, color: Colors.black38, fontWeight: FontWeight.w500)),
                            const SizedBox(height: 12),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 2.8,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                              ),
                              itemCount: movie.cast.length,
                              itemBuilder: (context, index) {
                                final actor = movie.cast[index];
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF3F4F6).withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 16,
                                        backgroundColor: primaryPurple.withOpacity(0.15),
                                        child: Text(
                                          actor['role'] ?? '',
                                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: primaryPurple),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          actor['name'] ?? '',
                                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildSectionCard(
                        'Additional Information',
                        Column(
                          children: [
                            _buildInfoRow('Language', movie.language),
                            const SizedBox(height: 12),
                            _buildInfoRow('Format', '2D, 3D, IMAX'),
                            const SizedBox(height: 12),
                            _buildInfoRow('Rating', movie.ratingText),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(String title, Widget content) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 16),
          content,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.black45, fontSize: 14, fontWeight: FontWeight.w500)),
        Text(value, style: const TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildInfoItem(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.black45),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(color: Colors.black45, fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
