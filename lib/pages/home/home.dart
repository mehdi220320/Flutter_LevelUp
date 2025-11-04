import 'package:flutter/material.dart';
import 'package:levelup/models/JobPost';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int currentIndex = 0;
  int _currentBottomNavIndex = 0;
  double _dragPosition = 0.0;
  bool _showLike = false;
  bool _showNope = false;
  late AnimationController _likeController;
  late AnimationController _nopeController;
  late Animation<double> _likeScaleAnimation;
  late Animation<double> _nopeScaleAnimation;
  late Animation<double> _likeOpacityAnimation;
  late Animation<double> _nopeOpacityAnimation;

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
    _likeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _nopeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    // Like animations
    _likeScaleAnimation = Tween<double>(begin: 0.5, end: 1.2).animate(
      CurvedAnimation(parent: _likeController, curve: Curves.elasticOut),
    );

    _likeOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _likeController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeIn),
      ),
    );

    // Nope animations
    _nopeScaleAnimation = Tween<double>(begin: 0.5, end: 1.2).animate(
      CurvedAnimation(parent: _nopeController, curve: Curves.elasticOut),
    );

    _nopeOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _nopeController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeIn),
      ),
    );
  }

  @override
  void dispose() {
    _likeController.dispose();
    _nopeController.dispose();
    super.dispose();
  }

  void _showSwipeFeedback(bool isLike) {
    setState(() {
      _showLike = isLike;
      _showNope = !isLike;
    });

    if (isLike) {
      _likeController.forward().then((_) {
        Future.delayed(const Duration(milliseconds: 200), () {
          _likeController.reset();
          setState(() {
            _showLike = false;
          });
        });
      });
    } else {
      _nopeController.forward().then((_) {
        Future.delayed(const Duration(milliseconds: 200), () {
          _nopeController.reset();
          setState(() {
            _showNope = false;
          });
        });
      });
    }
  }

  void _handleSwipe(bool isLike) {
    _showSwipeFeedback(isLike);
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        if (currentIndex < jobPosts.length - 1) {
          currentIndex++;
        } else {
          currentIndex = 0; // Reset or handle end of list
        }
        _dragPosition = 0.0;
      });
    });
  }

  void _handleButtonTap(bool isLike) {
    _showSwipeFeedback(isLike);
    Future.delayed(const Duration(milliseconds: 400), () {
      setState(() {
        if (currentIndex < jobPosts.length - 1) {
          currentIndex++;
        } else {
          currentIndex = 0;
        }
        _dragPosition = 0.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: _showMenu,
        ),
        title: Text(
          _getAppBarTitle(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: _buildCurrentScreen(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildCurrentScreen() {
    switch (_currentBottomNavIndex) {
      case 0: // Swipe Jobs
        return currentIndex < jobPosts.length
            ? _buildJobCard(jobPosts[currentIndex])
            : _buildEmptyState();
      case 1: // Favorites
        return _buildFavoritesScreen();
      case 2: // Forum
        return _buildForumScreen();
      default:
        return const SizedBox();
    }
  }

  Widget _buildJobCard(JobPost job) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          _dragPosition = details.delta.dx;
          _showLike = _dragPosition > 20;
          _showNope = _dragPosition < -20;
        });
      },
      onPanEnd: (details) {
        if (_dragPosition > 50) {
          _handleSwipe(true);
        } else if (_dragPosition < -50) {
          _handleSwipe(false);
        } else {
          setState(() {
            _dragPosition = 0.0;
            _showLike = false;
            _showNope = false;
          });
        }
      },
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

          // Swipe Feedback - Like
          if (_showLike)
            AnimatedBuilder(
              animation: _likeController,
              builder: (context, child) {
                return Opacity(
                  opacity: _likeOpacityAnimation.value,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
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
                            Icons.favorite,
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

          // Swipe Feedback - Nope
          if (_showNope)
            AnimatedBuilder(
              animation: _nopeController,
              builder: (context, child) {
                return Opacity(
                  opacity: _nopeOpacityAnimation.value,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
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

          // Content
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),

                // Company & Basic Info
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

                // Mutual Connections
                Row(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black, width: 2),
                          ),
                        ),
                        Positioned(
                          left: 10,
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.black, width: 2),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 20,
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.black, width: 2),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "${job.mutualConnections} mutual connections",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Job Title
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

                // Description
                Text(
                  job.description,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 25),

                // Skills Section
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

                // Action Buttons
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
        // Skip Button
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

        // Favorite Button
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

        // Info Button
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.1),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
          ),
          child: const Icon(Icons.info_outline, color: Colors.white, size: 30),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 80,
            color: Colors.white.withOpacity(0.8),
          ),
          const SizedBox(height: 20),
          const Text(
            "No more jobs for now!",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Check back later for new opportunities",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          GestureDetector(
            onTap: () {
              setState(() {
                currentIndex = 0;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: const Text(
                "Refresh",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesScreen() {
    return Container(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite,
              size: 80,
              color: Colors.white.withOpacity(0.5),
            ),
            const SizedBox(height: 20),
            const Text(
              "Your Favorite Jobs",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Jobs you liked will appear here",
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

  Widget _buildForumScreen() {
    return Container(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.forum, size: 80, color: Colors.white.withOpacity(0.5)),
            const SizedBox(height: 20),
            const Text(
              "Community Forum",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Connect with other job seekers",
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

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentBottomNavIndex,
      onTap: (index) {
        setState(() {
          _currentBottomNavIndex = index;
        });
      },
      backgroundColor: Colors.black,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.swipe), label: 'Swipe Jobs'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
        BottomNavigationBarItem(icon: Icon(Icons.forum), label: 'Forum'),
      ],
    );
  }

  String _getAppBarTitle() {
    switch (_currentBottomNavIndex) {
      case 0:
        return "JobSwipe";
      case 1:
        return "Favorites";
      case 2:
        return "Forum";
      default:
        return "JobSwipe";
    }
  }

  void _showMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 300,
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A1A),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            _buildMenuOption(Icons.person, "Profile"),
            _buildMenuOption(Icons.settings, "Settings"),
            _buildMenuOption(Icons.help, "Help & Support"),
            _buildMenuOption(Icons.logout, "Logout"),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuOption(IconData icon, String text) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(text, style: const TextStyle(color: Colors.white)),
      onTap: () {
        Navigator.pop(context);
        // Handle menu option tap
      },
    );
  }
}
