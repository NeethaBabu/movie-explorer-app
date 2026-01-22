import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/movie_bloc.dart';
import '../bloc/movie_event.dart';
import '../bloc/movie_state.dart';

class MovieDetailsPage extends StatefulWidget {
  const MovieDetailsPage({super.key});

  @override
  State<MovieDetailsPage> createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  int selectedDateIndex = 3;
  int selectedTimeIndex = 0;

  final dates = ["Fri", "Sat", "Sun", "Mon", "Tue", "Wed", "Thu"];
  final days = ["12", "13", "14", "15", "16", "17", "18"];
  final times = ["09:40 AM", "12:30 PM", "04:00 PM", "09:40 PM"];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final imdbId = ModalRoute.of(context)!.settings.arguments as String;
    context.read<MovieBloc>().add(FetchMovieDetails(imdbId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocBuilder<MovieBloc, MovieState>(
        builder: (context, state) {
          if (state is MovieLoading) {
            return Center(child: CircularProgressIndicator(color: Colors.red));
          }

          if (state is MovieDetailsLoaded) {
            final d = state.details;

            return Stack(
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _headerPoster(d),
                      _movieInfo(d),
                      _description(d),
                      _castSection(),
                      _dateSelector(),
                      _timeSelector(),
                    ],
                  ),
                ),
                _bookNowButton(d),
              ],
            );
          }

          return Center(
            child: Text("No Data", style: TextStyle(color: Colors.white)),
          );
        },
      ),
    );
  }

  Widget _headerPoster(Map d) {
    return Stack(
      children: [
        Image.network(
          d["Poster"],
          height: 420,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Container(
          height: 420,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black.withOpacity(0.1), Colors.black],
            ),
          ),
        ),
        Positioned(
          top: 50,
          left: 16,
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        Positioned(
          bottom: 20,
          left: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                d["Title"],
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 6),
              Text(
                "${d["Rated"]} • ${d["Language"]} • ${d["Runtime"]}",
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _movieInfo(Map d) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Wrap(
        spacing: 8,
        children: d["Genre"]
            .split(",")
            .map<Widget>(
              (g) =>
                  Chip(label: Text(g), backgroundColor: Colors.grey.shade800),
            )
            .toList(),
      ),
    );
  }

  Widget _description(Map d) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Description",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(d["Plot"], style: TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _castSection() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Cast",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              _CastItem(name: "Robert Downey Jr", role: "Tony Stark"),
              _CastItem(name: "Scarlett Johansson", role: "Natasha"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _dateSelector() {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: dates.length,
        itemBuilder: (_, i) {
          final selected = i == selectedDateIndex;
          return GestureDetector(
            onTap: () => setState(() => selectedDateIndex = i),
            child: Container(
              width: 70,
              margin: EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: selected ? Colors.red : Colors.grey.shade900,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(dates[i]),
                  SizedBox(height: 4),
                  Text(days[i], style: TextStyle(fontSize: 18)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _timeSelector() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: List.generate(times.length, (i) {
          final selected = i == selectedTimeIndex;
          return GestureDetector(
            onTap: () => setState(() => selectedTimeIndex = i),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(color: selected ? Colors.red : Colors.grey),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(times[i]),
            ),
          );
        }),
      ),
    );
  }

  Widget _bookNowButton(Map d) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black,
          boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 10)],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            minimumSize: Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          onPressed: () {
            final bookingData = {
              "movie": d,
              "date": "${dates[selectedDateIndex]} ${days[selectedDateIndex]}",
              "time": times[selectedTimeIndex],
              "row": "2",
              "seats": "9, 10",
            };

            Navigator.pushNamed(context, "/booking", arguments: bookingData);
          },

          child: Text(
            "BOOK NOW",
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ),
      ),
    );
  }
}

class _CastItem extends StatelessWidget {
  final String name;
  final String role;

  const _CastItem({required this.name, required this.role});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(radius: 28, backgroundColor: Colors.grey),
        SizedBox(height: 6),
        Text(name, style: TextStyle(fontSize: 12)),
        Text(role, style: TextStyle(fontSize: 10, color: Colors.white70)),
      ],
    );
  }
}
