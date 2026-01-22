import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart' hide CarouselController;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../main.dart';
import '../bloc/movie_bloc.dart';
import '../bloc/movie_event.dart';
import '../bloc/movie_state.dart';
import '../widget/center_carousel.dart';
import '../widget/hero_section.dart';
import '../widget/trending_slider.dart';
import '../widget/upcoming_slider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with RouteAware {
  int selectedIndex = 0;
  int activeCenterIndex = 0;
  int page = 1;
  String currentQuery = "avengers";
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<MovieBloc>().add(FetchMovies("avengers", 1));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
  }

  @override
  void didPopNext() {
    context.read<MovieBloc>().add(FetchMovies(currentQuery, page));
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: _bottomBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeroSection(
                searchController: searchController,
                currentQuery: currentQuery,
                page: page,
                onSearch: (query, p) {
                  currentQuery = query;
                  page = p;
                  context.read<MovieBloc>().add(
                    FetchMovies(currentQuery, page),
                  );
                },
              ),

              CenterCarousel(
                currentQuery: currentQuery,
                page: page,
                onPageUpdate: (p) => page = p,
              ),

              _sectionTitle("Trending Movie Near You"),
              const TrendingSlider(),

              _sectionTitle("Upcoming"),
              const UpcomingSlider(),

              BlocBuilder<MovieBloc, MovieState>(
                builder: (context, state) {
                  if (state is MovieLoaded) {
                    final pages = List.generate(5, (index) => index + 1);

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: pages.map((p) {
                          final bool isActive = p == page;

                          return GestureDetector(
                            onTap: () {
                              setState(() => page = p);
                              context.read<MovieBloc>().add(
                                FetchMovies(currentQuery, page),
                              );
                            },
                            child: Container(
                              width: 36,
                              height: 36,
                              margin: const EdgeInsets.symmetric(horizontal: 6),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: isActive
                                    ? Colors.red
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(color: Colors.white30),
                              ),
                              child: Text(
                                "$p",
                                style: TextStyle(
                                  color: isActive
                                      ? Colors.white
                                      : Colors.white70,
                                  fontWeight: isActive
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  }
                  if (state is MovieLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.red),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _bottomBar() {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      backgroundColor: Colors.black,
      selectedItemColor: Colors.red,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      onTap: (i) => setState(() => selectedIndex = i),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: "Find"),
        BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: "Saved"),
        BottomNavigationBarItem(icon: Icon(Icons.person_3), label: "Profile"),
      ],
    );
  }
}
