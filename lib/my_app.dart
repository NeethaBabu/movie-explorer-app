import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/utils/app_route.dart';
import 'feature/booking/presenattion/booking_page.dart';
import 'feature/movies/data/datasource/movie_remote_datasource.dart';
import 'feature/movies/data/repository/movie_repository.dart';
import 'feature/movies/presentation/bloc/movie_bloc.dart';
import 'feature/movies/presentation/pages/home_page.dart';
import 'feature/movies/presentation/pages/movie_details_page.dart';
import 'feature/movies/presentation/pages/walkthrough_page.dart';
import 'feature/splash/splash_page.dart';
import 'main.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MovieBloc(MovieRepository(MovieRemoteDataSource())),
      child: MaterialApp(
        navigatorObservers: [routeObserver],
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        initialRoute: AppRoute.splash,
        routes: {
          AppRoute.splash: (_) => SplashPage(),
          AppRoute.walkthrough: (_) => WalkthroughPage(),
          AppRoute.home: (_) => HomePage(),
          AppRoute.details: (_) => MovieDetailsPage(),
          AppRoute.booking: (_) => BookingPage(),
        },
      ),
    );
  }
}
