import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/movie_bloc.dart';
import '../bloc/movie_event.dart';
import '../bloc/movie_state.dart';

class CenterCarousel extends StatefulWidget {
  final String currentQuery;
  final int page;
  final ValueChanged<int> onPageUpdate;

  const CenterCarousel({
    super.key,
    required this.currentQuery,
    required this.page,
    required this.onPageUpdate,
  });

  @override
  State<CenterCarousel> createState() => _CenterCarouselState();
}

class _CenterCarouselState extends State<CenterCarousel> {
  int activeCenterIndex = 0;

  @override
  Widget build(BuildContext context) {
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
                    viewportFraction: 0.50,
                    enableInfiniteScroll: false,
                    enlargeCenterPage: false,
                    onPageChanged: (index, reason) {
                      setState(() => activeCenterIndex = index);

                      if (index >= state.movies.length - 2 && state.hasMore) {
                        final nextPage = widget.page + 1;
                        widget.onPageUpdate(nextPage);

                        context.read<MovieBloc>().add(
                          FetchMovies(
                            widget.currentQuery,
                            nextPage,
                            loadMore: true,
                          ),
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
                        height: isCenter ? 173 : 130,
                        child: Opacity(
                          opacity: isCenter ? 1.0 : 0.55,
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
                                            borderRadius: BorderRadius.circular(
                                              5,
                                            ),
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
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.white70,
                                          ),
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

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    state.movies.length > 5 ? 5 : state.movies.length,
                    (i) => Container(
                      width: 6,
                      height: 3,
                      margin: const EdgeInsets.symmetric(horizontal: 1.5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
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

          if (state is MovieLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return const SizedBox();
        },
      ),
    );
  }
}
