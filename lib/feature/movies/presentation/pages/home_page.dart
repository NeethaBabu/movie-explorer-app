import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart' hide CarouselController;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/movie_bloc.dart';
import '../bloc/movie_event.dart';
import '../bloc/movie_state.dart';


class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

    final state = context.read<MovieBloc>().state;

    if (state is MovieDetailsLoaded) {
      context.read<MovieBloc>().add(
        FetchMovies(currentQuery, page),
      );
    }
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
              _heroSection(),

              _centerCarousel(),

              _sectionTitle("Trending Movie Near You"),
              _trendingSlider(),

              _sectionTitle("Upcoming"),
              _upcomingSlider(),

              BlocBuilder<MovieBloc, MovieState>(
                builder: (context, state) {
                  if (state is MovieLoaded && state.hasMore) {
                    if (state.isLoadingMore) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Center(
                        child: ElevatedButton(
                          onPressed: () {
                            page++;
                            context.read<MovieBloc>().add(
                              FetchMovies(currentQuery, page, loadMore: true),
                            );
                          },
                          child: const Text("Load More"),
                        ),
                      ),
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

  Widget _heroSection() {
    return Stack(
      children: [
        // background image
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

        // dark gradient overlay
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

        // search bar
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
                  currentQuery = value;
                  page = 1;
                  context.read<MovieBloc>().add(
                    FetchMovies(currentQuery, page),
                  );
                }
              },
              onChanged: (value) {
                if (value.isEmpty) {
                  currentQuery = "avengers";
                  page = 1;
                  context.read<MovieBloc>().add(
                    FetchMovies(currentQuery, page),
                  );
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

        // play button
        Positioned.fill(
          child: Center(
            child: Icon(
              Icons.play_circle_fill,
              size: 80,
              color: Colors.white,
            ),
          ),
        ),

        // category chips
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _chip("Drama"),
              _chip("12+"),
              _chip("Action"),
            ],
          ),
        ),
      ],
    );
  }
  Widget _chip(String text) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white54),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
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
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: "Find"),
        BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: "Saved"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }


  Widget _centerCarousel() {
    return SizedBox(
      height: 210,
      child: BlocBuilder<MovieBloc, MovieState>(
        builder: (context, state) {
          if (state is MovieLoaded) {
            return Column(
              children: [
                CarouselSlider.builder(
                  itemCount: state.movies.length,
                  options: CarouselOptions(
                    height: 173,
                    viewportFraction: 0.38,
                    enableInfiniteScroll: false,
                    enlargeCenterPage: false, // IMPORTANT
                    onPageChanged: (index, reason) {
                      setState(() => activeCenterIndex = index);

                      // pagination
                      if (index >= state.movies.length - 2 &&
                          state.hasMore) {
                        page++;
                        context.read<MovieBloc>().add(
                          FetchMovies(currentQuery, page, loadMore: true),
                        );
                      }
                    },
                  ),
                  itemBuilder: (context, i, realIndex) {
                    final movie = state.movies[i];
                    final bool isCenter = i == activeCenterIndex;

                    return Center(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                        width: 120,
                        height: isCenter ? 173 : 155, // 👈 center taller
                        child: Opacity(
                          opacity: isCenter ? 1.0 : 0.55, // 👈 dim sides
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(13.92),
                            child: Stack(
                              children: [
                                Image.network(
                                  movie.poster,
                                  width: 120,
                                  height: 173,
                                  fit: BoxFit.cover,
                                ),

                                // gradient only for center
                                if (isCenter)
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black.withOpacity(0.85),
                                        ],
                                      ),
                                    ),
                                  ),

                                // Book Now only for center
                                if (isCenter)
                                  Positioned(
                                    bottom: 8,
                                    left: 8,
                                    right: 8,
                                    child: SizedBox(
                                      height: 28,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.black38,
                                          padding: EdgeInsets.zero,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(5),
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.pushNamed(
                                            context,
                                            "/details",
                                            arguments: movie.imdbID,
                                          );
                                        },
                                        child: const Text(
                                          "Book Now",
                                          style: TextStyle(fontSize: 11,color: Colors.white70),
                                        ),
                                      ),
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

                const SizedBox(height: 8),

                // dots indicator (matches image)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    state.movies.length > 5 ? 5 : state.movies.length,
                        (i) => Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: activeCenterIndex == i
                            ? Colors.white
                            : Colors.white30,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }



  Widget _trendingSlider() {
    return SizedBox(
      height: 110,
      child: BlocBuilder<MovieBloc, MovieState>(
        builder: (context, state) {
          if (state is MovieLoaded) {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: state.movies.length,
              itemBuilder: (_, i) {
                final movie = state.movies[i];

                return Container(
                  width: 169,
                  height: 94.93,
                  margin: EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(
                      color: Colors.white24,
                      width: 0.5,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(13),
                    child: Image.network(
                      movie.poster,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            );
          }
          return SizedBox();
        },
      ),
    );
  }


  Widget _upcomingSlider() {
    return SizedBox(
      height: 205,
      child: BlocBuilder<MovieBloc, MovieState>(
        builder: (context, state) {
          if (state is MovieLoaded) {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: state.movies.length,
              itemBuilder: (_, i) {
                final movie = state.movies[i];

                return Container(
                  width: 126,
                  height: 187,
                  margin: EdgeInsets.only(right: 12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      children: [
                        Image.network(
                          movie.poster,
                          width: 126,
                          height: 187,
                          fit: BoxFit.cover,
                        ),

                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.85),
                              ],
                            ),
                          ),
                        ),

                        Positioned(
                          bottom: 8,
                          left: 8,
                          right: 8,
                          child: SizedBox(
                            height: 26,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black38,
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  "/details",
                                  arguments: movie.imdbID,
                                );
                              },
                              child: Text(
                                "Book Now",
                                style: TextStyle(fontSize: 11,color: Colors.white70),
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
          return SizedBox();
        },
      ),
    );
  }


}
