import 'package:flutter/material.dart';

class HeroSection extends StatelessWidget {
  final TextEditingController searchController;
  final String currentQuery;
  final int page;
  final Function(String query, int page) onSearch;

  const HeroSection({
    super.key,
    required this.searchController,
    required this.currentQuery,
    required this.page,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 420,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                "https://image.tmdb.org/t/p/w500/9Gtg2DzBhmYamXBS1hKAhiwbBKS.jpg",
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),

        Container(
          height: 420,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.2),
                Colors.black.withOpacity(0.9),
              ],
            ),
          ),
        ),

        Positioned(
          top: 16,
          left: 16,
          right: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(30),
            ),
            child: TextField(
              controller: searchController,
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  onSearch(value, 1);
                }
              },
              onChanged: (value) {
                if (value.isEmpty) {
                  onSearch("avengers", 1);
                }
              },
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "Search Movie",
                hintStyle: TextStyle(color: Colors.white70),
                prefixIcon: Icon(Icons.search, color: Colors.white),
                border: InputBorder.none,
              ),
            ),
          ),
        ),

        Positioned.fill(
          child: Center(
            child: Icon(
              Icons.play_circle,
              size: 80,
              color: Colors.white.withOpacity(0.3),
            ),
          ),
        ),

        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              _Chip(text: "Drama"),
              _Chip(text: "12+"),
              _Chip(text: "Action"),
            ],
          ),
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  final String text;

  const _Chip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white54),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white)),
    );
  }
}
