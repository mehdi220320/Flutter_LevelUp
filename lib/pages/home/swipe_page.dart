import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:levelup/models/JobPost.dart';

class SwipePage extends StatefulWidget {
  final List<JobPost> favoriteJobs;
  final Function(List<JobPost>) onFavoritesUpdated;

  const SwipePage({
    super.key,
    required this.favoriteJobs,
    required this.onFavoritesUpdated,
  });

  @override
  SwipePageState createState() => SwipePageState();
}

class SwipePageState extends State<SwipePage> with TickerProviderStateMixin {
  bool _showLike = false;
  bool _showNope = false;
  int _currentCardIndex = 0;

  late AnimationController _likeController;
  late AnimationController _nopeController;
  late AnimationController _infoController;
  late Animation<double> _likeScaleAnimation;
  late Animation<double> _nopeScaleAnimation;
  late Animation<double> _likeOpacityAnimation;
  late Animation<double> _nopeOpacityAnimation;
  late Animation<double> _infoScaleAnimation;
  late Animation<double> _infoOpacityAnimation;

  final CardSwiperController _swiperController = CardSwiperController();

  final List<JobPost> jobPosts = [
    JobPost(
      companyName: "Alibra",
      logo: "🚀",
      title: "Senior Flutter Developer",
      description:
          "Hey! We're looking for a Flutter developer who loves clean code and building amazing mobile experiences. If you're passionate about mobile tech, you'll fit right in!",
      skills: ["Flutter", "Dart", "Firebase", "REST API"],
      experience: "3+ years",
      location: "San Francisco, CA",
      mutualConnections: 3,
      image: "assets/images/landingPageHero.png",
    ),
    JobPost(
      companyName: "TechNova",
      logo: "📊",
      title: "Data Scientist",
      description:
          "Join our data team to solve complex problems! We value creativity and analytical thinking. Bring your ML skills and let's build something amazing together!",
      skills: ["Python", "Machine Learning", "SQL", "TensorFlow"],
      experience: "2+ years",
      location: "Remote",
      mutualConnections: 2,
      image: "assets/images/landingPageHero2.jpg",
    ),
    JobPost(
      companyName: "DesignHub",
      logo: "🎨",
      title: "UI/UX Designer",
      description:
          "Love creating beautiful interfaces? We're looking for a designer who understands users and can translate complex ideas into intuitive designs.",
      skills: ["Figma", "Adobe XD", "User Research", "Prototyping"],
      experience: "2+ years",
      location: "New York, NY",
      mutualConnections: 5,
      image: "assets/images/levelUp.jpg",
    ),
    JobPost(
      companyName: "CloudSystems",
      logo: "☁️",
      title: "DevOps Engineer",
      description:
          "Passionate about infrastructure and automation? Join our team to build scalable systems and help us deliver amazing products to millions of users.",
      skills: ["AWS", "Docker", "Kubernetes", "CI/CD"],
      experience: "4+ years",
      location: "Austin, TX",
      mutualConnections: 1,
      image: "assets/images/landingPageHero.png",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _likeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _nopeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _infoController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _likeScaleAnimation = Tween<double>(begin: 0.5, end: 1.2).animate(
      CurvedAnimation(parent: _likeController, curve: Curves.elasticOut),
    );

    _likeOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _likeController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeIn),
      ),
    );

    _nopeScaleAnimation = Tween<double>(begin: 0.5, end: 1.2).animate(
      CurvedAnimation(parent: _nopeController, curve: Curves.elasticOut),
    );

    _nopeOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _nopeController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeIn),
      ),
    );

    _infoScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _infoController, curve: Curves.easeOutBack),
    );

    _infoOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _infoController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _likeController.dispose();
    _nopeController.dispose();
    _infoController.dispose();
    super.dispose();
  }

  void _showSwipeFeedback(bool isLike) {
    setState(() {
      _showLike = isLike;
      _showNope = !isLike;
    });

    final controller = isLike ? _likeController : _nopeController;
    controller.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 200), () {
        controller.reset();
        setState(() {
          _showLike = false;
          _showNope = false;
        });
      });
    });
  }

  void _handleButtonTap(bool isLike) {
    _showSwipeFeedback(isLike);

    // Update favorites
    List<JobPost> updatedFavorites = List.from(widget.favoriteJobs);
    final currentJob = jobPosts[_currentCardIndex];

    if (isLike) {
      // Add to favorites when liking
      if (!updatedFavorites.contains(currentJob)) {
        updatedFavorites.add(currentJob);
      }
    } else {
      // Remove from favorites when disliking
      updatedFavorites.remove(currentJob);
    }

    widget.onFavoritesUpdated(updatedFavorites);

    // Swipe the card
    if (isLike) {
      _swiperController.swipe(CardSwiperDirection.right);
    } else {
      _swiperController.swipe(CardSwiperDirection.left);
    }
  }

  void _showInfoPopup() {
    _infoController.forward();
    Future.delayed(const Duration(seconds: 3), () {
      _infoController.reverse();
    });
  }

  void _showExtendedInfo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(20),
          child: Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.info, color: Colors.blue, size: 24),
                    SizedBox(width: 10),
                    Text(
                      "How to Use JobSwipe",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildInstructionItem(
                  Icons.thumb_up_alt,
                  "Swipe Right / Heart Button",
                  "Adds job to your favorites and shows you more like this",
                  Colors.green,
                ),
                const SizedBox(height: 15),
                _buildInstructionItem(
                  Icons.close,
                  "Swipe Left / X Button",
                  "Removes job from your list and skips to next opportunity",
                  Colors.red,
                ),
                const SizedBox(height: 15),
                _buildInstructionItem(
                  Icons.favorite,
                  "Favorites Tab",
                  "View all your saved jobs in one place for easy access",
                  Colors.pink,
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      "Got it!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInstructionItem(
    IconData icon,
    String title,
    String description,
    Color color,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: color.withOpacity(0.5)),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildSwiper(),

        // Info Popup
        AnimatedBuilder(
          animation: _infoController,
          builder: (context, child) {
            return Opacity(
              opacity: _infoOpacityAnimation.value,
              child: Transform.scale(
                scale: _infoScaleAnimation.value,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 100),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A).withOpacity(0.95),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                      border: Border.all(color: Colors.blue.withOpacity(0.5)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.thumb_up_alt, color: Colors.green, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          "Like = Save to Favorites",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          width: 1,
                          height: 20,
                          color: Colors.white.withOpacity(0.3),
                        ),
                        const SizedBox(width: 12),
                        Icon(Icons.close, color: Colors.red, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          "Dislike = Skip",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSwiper() {
    return Stack(
      children: [
        CardSwiper(
          controller: _swiperController,
          cardsCount: jobPosts.length,
          onSwipe: (prev, current, direction) {
            if (current != null) {
              setState(() {
                _currentCardIndex = current;
              });
            }

            List<JobPost> updatedFavorites = List.from(widget.favoriteJobs);
            final currentJob = jobPosts[_currentCardIndex];

            if (direction == CardSwiperDirection.right) {
              if (!updatedFavorites.contains(currentJob)) {
                updatedFavorites.add(currentJob);
              }
              _showSwipeFeedback(true);
            } else if (direction == CardSwiperDirection.left) {
              updatedFavorites.remove(currentJob);
              _showSwipeFeedback(false);
            }

            widget.onFavoritesUpdated(updatedFavorites);
            return true;
          },
          cardBuilder: (context, index, percentX, percentY) {
            final job = jobPosts[index];
            return _buildJobCard(job);
          },
          numberOfCardsDisplayed: 1,
          isLoop: true,
          padding: EdgeInsets.zero,
        ),

        // Swipe Feedback Animations
        if (_showLike)
          AnimatedBuilder(
            animation: _likeController,
            builder: (context, child) {
              return Opacity(
                opacity: _likeOpacityAnimation.value,
                child: Container(
                  color: Colors.green.withOpacity(
                    0.3 * _likeOpacityAnimation.value,
                  ),
                  child: Center(
                    child: Transform.scale(
                      scale: _likeScaleAnimation.value,
                      child: Container(
                        padding: const EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.8),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.5),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.thumb_up_alt,
                          color: Colors.white,
                          size: 70,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        if (_showNope)
          AnimatedBuilder(
            animation: _nopeController,
            builder: (context, child) {
              return Opacity(
                opacity: _nopeOpacityAnimation.value,
                child: Container(
                  color: Colors.red.withOpacity(
                    0.3 * _nopeOpacityAnimation.value,
                  ),
                  child: Center(
                    child: Transform.scale(
                      scale: _nopeScaleAnimation.value,
                      child: Container(
                        padding: const EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.8),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.withOpacity(0.5),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 70,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildJobCard(JobPost job) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          // Background Image
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(job.image),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Gradient Overlay
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.7),
                  Colors.black.withOpacity(0.9),
                ],
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Center(
                        child: Text(
                          job.logo,
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job.companyName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${job.experience} • ${job.location}",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  job.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  job.description,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 25),
                Text(
                  "What we're looking for:",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: job.skills
                      .map(
                        (skill) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            skill,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 40),
                _buildActionButtons(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () => _handleButtonTap(false),
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.1),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: const Icon(Icons.close, color: Colors.white, size: 30),
          ),
        ),
        GestureDetector(
          onTap: () => _handleButtonTap(true),
          child: Container(
            width: 70,
            height: 70,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFFFF3868), Color(0xFFFF6B8A)],
              ),
            ),
            child: const Icon(
              Icons.thumb_up_alt,
              color: Colors.white,
              size: 35,
            ),
          ),
        ),
        GestureDetector(
          onTap: _showInfoPopup,
          onLongPress: _showExtendedInfo,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.1),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: const Icon(
              Icons.info_outline,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
      ],
    );
  }
}
