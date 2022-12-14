import 'package:flutter/material.dart';
import 'package:movies/constants/api_constants.dart';
import 'package:movies/modal_class/credits.dart';
import 'package:movies/modal_class/function.dart';
import 'package:movies/modal_class/genres.dart';
import 'package:movies/modal_class/movie.dart';
import 'package:movies/screens/castncrew.dart';
import 'package:movies/screens/genremovies.dart';
import 'package:movies/screens/movie_detail.dart';

class ScrollingMovies extends StatefulWidget {
  final ThemeData themeData;
  final String? api, title;
  final List<Genres> genres;

  ScrollingMovies(
      {required this.themeData, this.api, this.title, required this.genres});

  @override
  _ScrollingMoviesState createState() => _ScrollingMoviesState();
}

class _ScrollingMoviesState extends State<ScrollingMovies> {
  List<Movie>? moviesList;

  @override
  void initState() {
    super.initState();
    fetchMovies(widget.api!).then((value) {
      setState(() {
        moviesList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.title!,
                  style: widget.themeData.textTheme.headline5),
            ),
          ],
        ),
        SizedBox(
          width: double.infinity,
          height: 200,
          child: moviesList == null
              ? const Center(
            child: CircularProgressIndicator(),
          )
              : ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: moviesList!.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                MovieDetailPage(
                                    movie: moviesList![index],
                                    themeData: widget.themeData,
                                    genres: widget.genres,
                                    heroId:
                                    '${moviesList![index].id}${widget
                                        .title}')));
                  },
                  child: Hero(
                    tag: '${moviesList![index].id}${widget.title}',
                    child: SizedBox(
                      width: 100,
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: FadeInImage(
                                image: NetworkImage(
                                    '${TMDB_BASE_IMAGE_URL}w500/${moviesList![index]
                                        .posterPath!}'),
                                fit: BoxFit.cover,
                                placeholder: const AssetImage(
                                    'assets/images/loading.gif'),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              moviesList![index].title!,
                              style: widget.themeData.textTheme.bodyText1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class ParticularGenreMovies extends StatefulWidget {
  final ThemeData themeData;
  final String api;
  final List<Genres> genres;

  ParticularGenreMovies(
      {required this.themeData, required this.api, required this.genres});

  @override
  _ParticularGenreMoviesState createState() => _ParticularGenreMoviesState();
}

class _ParticularGenreMoviesState extends State<ParticularGenreMovies> {
  List<Movie>? moviesList;

  @override
  void initState() {
    super.initState();
    fetchMovies(widget.api).then((value) {
      setState(() {
        moviesList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.themeData.primaryColor.withOpacity(0.8),
      child: moviesList == null
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: moviesList!.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            MovieDetailPage(
                                movie: moviesList![index],
                                themeData: widget.themeData,
                                genres: widget.genres,
                                heroId: '${moviesList![index].id}')));
              },
              child: Container(
                height: 150,
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 40.0),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: widget.themeData.primaryColor,
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(
                                width: 1,
                                color: widget.themeData.accentColor)),
                        height: 100,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 118.0, top: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                moviesList![index].title!,
                                style:
                                widget.themeData.textTheme.bodyText2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      moviesList![index].voteAverage!,
                                      style: widget
                                          .themeData.textTheme.bodyText1,
                                    ),
                                    const Icon(
                                      Icons.star,
                                      color: Colors.green,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 8,
                      child: Hero(
                        tag: '${moviesList![index].id}',
                        child: SizedBox(
                          width: 100,
                          height: 125,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: FadeInImage(
                              image: NetworkImage(
                                  '${TMDB_BASE_IMAGE_URL}w500/${moviesList![index]
                                      .posterPath!}'),
                              fit: BoxFit.cover,
                              placeholder:
                              const AssetImage('assets/images/loading.gif'),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ScrollingArtists extends StatefulWidget {
  final ThemeData? themeData;
  final String? api, title, tapButtonText;
  final Function(Cast)? onTap;

  ScrollingArtists(
      {this.themeData, this.api, this.title, this.tapButtonText, this.onTap});

  @override
  _ScrollingArtistsState createState() => _ScrollingArtistsState();
}

class _ScrollingArtistsState extends State<ScrollingArtists> {
  Credits? credits;

  @override
  void initState() {
    super.initState();
    fetchCredits(widget.api!).then((value) {
      setState(() {
        credits = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        credits == null
            ? Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Text(widget.title!,
                  style: widget.themeData!.textTheme.bodyText1),
            ],
          ),
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.title!,
                  style: widget.themeData!.textTheme.bodyText1),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CastAndCrew(
                              themeData: widget.themeData,
                              credits: credits,
                            )));
              },
              child: Text(widget.tapButtonText!,
                  style: widget.themeData!.textTheme.caption),
            ),
          ],
        ),
        SizedBox(
          width: double.infinity,
          height: 120,
          child: credits == null
              ? const Center(
            child: CircularProgressIndicator(),
          )
              : ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: credits!.cast!.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    widget.onTap!(credits!.cast![index]);
                  },
                  child: SizedBox(
                    width: 80,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: SizedBox(
                            width: 70,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: credits!.cast![index].profilePath ==
                                  null
                                  ? Image.asset(
                                'assets/images/na.jpg',
                                fit: BoxFit.cover,
                              )
                                  : FadeInImage(
                                image: NetworkImage(
                                    '${TMDB_BASE_IMAGE_URL}w500/${credits!
                                        .cast![index]
                                        .profilePath!}'),
                                fit: BoxFit.cover,
                                placeholder: const AssetImage(
                                    'assets/images/loading.gif'),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            credits!.cast![index].name!,
                            style: widget.themeData!.textTheme.caption,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class GenreList extends StatefulWidget {
  final ThemeData themeData;
  final List<int> genres;
  final List<Genres> totalGenres;

  GenreList({required this.themeData,
    required this.genres,
    required this.totalGenres});

  @override
  _GenreListState createState() => _GenreListState();
}

class _GenreListState extends State<GenreList> {
  List<Genres>? _genres;

  @override
  void initState() {
    super.initState();
    _genres = [];
    Future.delayed(Duration.zero, () {
      widget.totalGenres.forEach((valueGenre) {
        widget.genres.forEach((genre) {
          if (valueGenre.id == genre) {
            _genres?.add(valueGenre);
            setState(() {});
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        height: 50,
        child: Center(
          child: _genres == null
              ? const CircularProgressIndicator()
              : ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: _genres!.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                GenreMovies(
                                  themeData: widget.themeData,
                                  genre: _genres![index],
                                  genres: widget.totalGenres,
                                )));
                  },
                  child: Chip(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                          width: 1,
                          style: BorderStyle.solid,
                          color: widget.themeData.accentColor),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    label: Text(
                      _genres![index].name!,
                      style: widget.themeData.textTheme.bodyText1,
                    ),
                    backgroundColor: Colors.transparent,
                  ),
                ),
              );
            },
          ),
        ));
  }
}






