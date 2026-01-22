import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/movie_bloc.dart';
import '../bloc/movie_state.dart';

class TrendingSlider extends StatelessWidget {
  const TrendingSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: BlocBuilder<MovieBloc, MovieState>(
        builder: (context, state) {
          if (state is MovieLoaded) {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: state.movies.length,
              itemBuilder: (_, i) {
                final movie = state.movies[i];

                return Container(
                  width: 169,
                  height: 94.93,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(color: Colors.white24, width: 0.5),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(13),
                    child: Image.network(movie.poster, fit: BoxFit.cover),
                  ),
                );
              },
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
