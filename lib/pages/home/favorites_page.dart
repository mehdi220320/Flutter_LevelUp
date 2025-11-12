import 'package:flutter/material.dart';
import 'package:levelup/models/JobPost.dart';

class FavoritesPage extends StatelessWidget {
  final List<JobPost> favoriteJobs;
  final Function(List<JobPost>) onFavoritesUpdated;

  const FavoritesPage({
    super.key,
    required this.favoriteJobs,
    required this.onFavoritesUpdated,
  });

  void _removeFromFavorites(int index, BuildContext context) {
    final updatedFavorites = List<JobPost>.from(favoriteJobs);
    updatedFavorites.removeAt(index);
    onFavoritesUpdated(updatedFavorites);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Removed from favorites'),
        backgroundColor: Colors.red,
      ),
    );
  }

  Widget _buildFavoriteJobCard(JobPost job, int index, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Center(
              child: Text(job.logo, style: const TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  job.companyName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  job.title,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
                Text(
                  "${job.experience} • ${job.location}",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () => _removeFromFavorites(index, context),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 80,
              color: Colors.white.withOpacity(0.5),
            ),
            const SizedBox(height: 20),
            Text(
              "No Favorites Yet",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Swipe right on jobs you like to add them here!",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (favoriteJobs.isEmpty) {
      return _buildEmptyState();
    }

    return Container(
      color: Colors.black,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "Your Favorite Jobs (${favoriteJobs.length})",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favoriteJobs.length,
              itemBuilder: (context, index) {
                final job = favoriteJobs[index];
                return _buildFavoriteJobCard(job, index, context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
