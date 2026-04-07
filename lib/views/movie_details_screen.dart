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
  YoutubePlayerController? _controller;
  bool _isPlayingTrailer = false;

  @override
  void initState() {
    super.initState();
  }

  void _initializePlayer(String videoId) {
    if (_controller != null) return;
    _controller = YoutubePlayerController.fromVideoId(
      videoId: videoId,
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
    _controller?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HomeViewModel>(context, listen: false);
    final allMovies = viewModel.currentMovies.isNotEmpty 
        ? viewModel.currentMovies 
        : [Movie(
            id: '1', 
            title: 'Loading...', 
            genre: '', 
            duration: '', 
            rating: 0.0, 
            posterUrl: '', 
            synopsis: '', 
            director: '', 
            cast: [], 
            language: '', 
            ratingText: '', 
            isNowShowing: true
          )];

    final movie = allMovies.firstWhere((m) => m.id == widget.id, orElse: () => allMovies.first);

    final colorScheme = Theme.of(context).colorScheme;
    const Color logoYellow = Color(0xFFFFC107);

    return Scaffold(
      backgroundColor: colorScheme.background,
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
                            errorBuilder: (_, __, ___) => Container(color: colorScheme.surfaceVariant),
                          ),
                        );
                      }
                      
                      return Image.network(
                        movie.posterUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(color: colorScheme.surfaceVariant),
                      );
                    },
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.4),
                          Colors.transparent,
                          colorScheme.background.withOpacity(0.8),
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (movie.youtubeVideoId.isNotEmpty) {
                          _initializePlayer(movie.youtubeVideoId);
                          setState(() {
                            _isPlayingTrailer = true;
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Trailer not available for this movie.')),
                          );
                        }
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
                        ],
                      ),
                    ),
                  ),
                ] else if (_controller != null)
                  YoutubePlayer(
                    controller: _controller!,
                    aspectRatio: 16 / 9,
                  ),
              ],
            ),
          ),

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
                      ),
                    ),
                    const SizedBox(width: 12),
                    CircleAvatar(
                      backgroundColor: Colors.black26,
                      child: IconButton(
                        icon: const Icon(Icons.favorite_border, color: Colors.white),
                        onPressed: () {},
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
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                    boxShadow: [
                      BoxShadow(color: colorScheme.shadow.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -5))
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
                                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  movie.genre,
                                  style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 16),
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
                          _buildInfoItem(context, Icons.access_time_rounded, movie.duration),
                          const SizedBox(width: 24),
                          _buildInfoItem(context, Icons.calendar_today_rounded, '15/03/2026'),
                        ],
                      ),
                      const SizedBox(height: 24),
                      FilledButton(
                        onPressed: () => context.push('/cinemas/${movie.id}'),
                        style: FilledButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                          minimumSize: const Size(double.infinity, 56),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        child: const Text('Book Tickets', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 32),
                      _buildSectionCard(
                        context,
                        'Synopsis',
                        Text(
                          movie.synopsis,
                          style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 15, height: 1.6),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildSectionCard(
                        context,
                        'Cast & Crew',
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Director', style: TextStyle(fontSize: 13, color: colorScheme.onSurfaceVariant.withOpacity(0.6), fontWeight: FontWeight.w500)),
                            const SizedBox(height: 4),
                            Text(movie.director, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
                            const SizedBox(height: 20),
                            Text('Cast', style: TextStyle(fontSize: 13, color: colorScheme.onSurfaceVariant.withOpacity(0.6), fontWeight: FontWeight.w500)),
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
                                    color: colorScheme.surfaceVariant.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 16,
                                        backgroundColor: colorScheme.primary.withOpacity(0.15),
                                        child: Text(
                                          actor['role'] ?? '',
                                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: colorScheme.primary),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          actor['name'] ?? '',
                                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: colorScheme.onSurface),
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
                        context,
                        'Additional Information',
                        Column(
                          children: [
                            _buildInfoRow(context, 'Language', movie.language),
                            const SizedBox(height: 12),
                            _buildInfoRow(context, 'Format', '2D, 3D, IMAX'),
                            const SizedBox(height: 12),
                            _buildInfoRow(context, 'Rating', movie.ratingText),
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

  Widget _buildSectionCard(BuildContext context, String title, Widget content) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: colorScheme.shadow.withOpacity(0.04), blurRadius: 10)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
          const SizedBox(height: 16),
          content,
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: colorScheme.onSurfaceVariant.withOpacity(0.6), fontSize: 14, fontWeight: FontWeight.w500)),
        Text(value, style: TextStyle(color: colorScheme.onSurface, fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildInfoItem(BuildContext context, IconData icon, String label) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, size: 18, color: colorScheme.onSurfaceVariant.withOpacity(0.6)),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(color: colorScheme.onSurfaceVariant.withOpacity(0.6), fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
