import 'package:flutter/material.dart';
import 'package:movie_explore_app/core/utils/app_route.dart';

class WalkthroughPage extends StatefulWidget {
  const WalkthroughPage({super.key});

  @override
  State<WalkthroughPage> createState() => _WalkthroughPageState();
}

class _WalkthroughPageState extends State<WalkthroughPage> {
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _walkPage(
            image: "assets/images/image1.png",
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0x00FFFFFF), Color(0xCC9C9E8E)],
            ),
            title: "Catch Every\nBlockbuster Without\nthe Queue",
            color: Colors.black54,
            onNext: () {
              _controller.nextPage(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
              );
            },
          ),
          _walkPage(
            image: "assets/images/image2.png",
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0x003B6DFF), Color(0xCC0D2C6E)],
            ),
            title: "Because\nMovies Deserve\nMore Than Queues",
            color: Colors.white70,
            onNext: () {
              Navigator.pushReplacementNamed(context, AppRoute.home);
            },
          ),
        ],
      ),
    );
  }

  Widget _walkPage({
    required String image,
    required Gradient gradient,
    required String title,
    required VoidCallback onNext,
    required Color? color,
  }) {
    return Stack(
      children: [
        Positioned.fill(child: Image.asset(image, fit: BoxFit.cover)),

        Positioned.fill(
          child: Container(decoration: BoxDecoration(gradient: gradient)),
        ),

        Positioned(
          left: 24,
          right: 24,
          bottom: 40,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.23),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: onNext,
                  child: const Text(
                    "NEXT",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
