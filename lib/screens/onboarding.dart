import 'package:flutter/material.dart';
import 'package:levelup/widgets/gradient_button.dart';
import '../pages/authScreens/login.dart';

class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingItem> _onboardingItems = [
    OnboardingItem(
      title: "Find Your First Opportunity",
      description:
          "Kickstart your career journey with companies looking for fresh talent like you.",
      image: "assets/images/landingPageHero.png",
    ),
    OnboardingItem(
      title: "Level Up Your Future",
      description:
          "Connect with top employers, grow your skills, and take the next big step.",
      image: "assets/images/levelUp.jpg",
    ),
    OnboardingItem(
      title: "Make Your Career Shine",
      description:
          "Your future starts here — explore, apply, and succeed with us.",
      image: "assets/images/landingPageHero2.jpg",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  child: Text(
                    "Skip", 
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: PageView.builder(
                controller: _pageController,
                itemCount: _onboardingItems.length,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemBuilder: (context, index) {
                  return OnboardingSlide(item: _onboardingItems[index]);
                },
              ),
            ),

            Container(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildPageIndicator(),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24.0),
              child: GradientButton(
                onPressed: () {
                  if (_currentPage == _onboardingItems.length - 1) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  } else {
                    _pageController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                  }
                },
                text: _currentPage == _onboardingItems.length - 1
                    ? "Get Started" 
                    : "Next", 
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> indicators = [];
    for (int i = 0; i < _onboardingItems.length; i++) {
      indicators.add(
        Container(
          width: 8.0,
          height: 8.0,
          margin: EdgeInsets.symmetric(horizontal: 4.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == i ? Color(0xFF6C63FF) : Colors.grey[300],
          ),
        ),
      );
    }
    return indicators;
  }
}

class OnboardingItem {
  final String title;
  final String description;
  final String image;

  OnboardingItem({
    required this.title,
    required this.description,
    required this.image,
  });
}

class OnboardingSlide extends StatelessWidget {
  final OnboardingItem item;

  const OnboardingSlide({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration
          Expanded(
            flex: 2,
            child: Container(
              child: Image.asset(item.image, fit: BoxFit.contain),
            ),
          ),

          SizedBox(height: 40),

          // Title
          Text(
            item.title,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D2B3A),
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 16),

          // Description
          Text(
            item.description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
