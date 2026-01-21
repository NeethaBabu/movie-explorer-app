import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'feature/booking/presenattion/booking_page.dart';
import 'feature/movies/data/datasource/movie_remote_datasource.dart';
import 'feature/movies/data/repository/movie_repository.dart';
import 'feature/movies/presentation/bloc/movie_bloc.dart';
import 'feature/movies/presentation/pages/home_page.dart';
import 'feature/movies/presentation/pages/movie_details_page.dart';
import 'feature/splash/splash_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MovieBloc(
        MovieRepository(MovieRemoteDataSource()),
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        routes: {
          "/": (_) => SplashPage(),
          "/home": (_) => HomePage(),
          "/details": (_) => MovieDetailsPage(),
          "/booking": (_) => BookingPage(),
        },
      ),
    );
  }
}
