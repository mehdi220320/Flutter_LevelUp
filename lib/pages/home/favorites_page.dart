import 'package:flutter/material.dart';
import 'package:levelup/models/Offer.dart';

class FavoritesPage extends StatelessWidget {
  final List<Offer> favoriteOffers;
  final Function(List<Offer>) onFavoritesUpdated;

  const FavoritesPage({
    super.key,
    required this.favoriteOffers,
    required this.onFavoritesUpdated,
  });

  void _removeFromFavorites(int index, BuildContext context) {
    final updatedFavorites = List<Offer>.from(favoriteOffers);
    updatedFavorites.removeAt(index);
    onFavoritesUpdated(updatedFavorites);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Removed from favorites'),
        backgroundColor: Colors.red,
      ),
    );
  }

  Widget _buildFavoriteOfferCard(Offer offer, int index, BuildContext context) {
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
              child: Text(offer.logo, style: const TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  offer.company,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  offer.title,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
                Text(
                  "${offer.experience} • ${offer.location}",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: offer.requiredSkills
                      .take(3)
                      .map(
                        (skill) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            skill.name,
                            style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      )
                      .toList(),
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
            const Text(
              "No Favorites Yet",
              style: TextStyle(
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
    if (favoriteOffers.isEmpty) {
      return _buildEmptyState();
    }

    return Container(
      color: Colors.black,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "Your Favorite Jobs (${favoriteOffers.length})",
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
              itemCount: favoriteOffers.length,
              itemBuilder: (context, index) {
                final offer = favoriteOffers[index];
                return _buildFavoriteOfferCard(offer, index, context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
