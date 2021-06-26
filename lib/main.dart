import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.deepPurple,
      ),
      home: new MyHomePage(
          title:'Movie titles',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  bool _isLoading = true;
  final List<Movie> _movies = <Movie>[];

  @override
  void initState() {
    super.initState();
    _getMovies();
  }

  Future <void> _getMovies() async {
    final Uri url = Uri(
      scheme: 'https',
      host: 'yts.mx',
      pathSegments: <String>['api', 'v2', 'list_movies.json'],
    );
    final Response response = await get(url);
    final Map<String, dynamic> body = jsonDecode(response.body) as Map<String, dynamic>;
    final Map<String, dynamic> data = body['data'] as Map<String, dynamic>;
    final List<dynamic> movies = data['movies'] as List<dynamic>;

    setState(() {
      for (int i = 0; i < movies.length; i++) {
        final Map <String, dynamic> movie = movies[i] as Map<String, dynamic>;
      _movies.add(Movie(movie));
      }
      _isLoading=false;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text('Movie titles'),
      ),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.69,
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,

          ),
          itemCount: _movies.length,
          itemBuilder: (BuildContext context, int index){
            
    final Movie movie=_movies[index];
    return GestureDetector(
      onTap: () {
        Navigator.push
          (context, MaterialPageRoute(
          builder: (context) => SecondScreen(
              movie:movie,
          ),
        ));
      },
      child: new GridTile(
      child: Image.network(
      movie.image,
      fit:BoxFit.cover,
      ),
      footer:GridTileBar(
      backgroundColor:Colors.black38,
      title:Text(movie.title),
      subtitle:Text(movie.summary),
      ),

      ),
    );
    },
    ),


    );

  }

}

class Movie
{
  Movie (Map<String, dynamic> movie)
  : title=movie['title'] as String,
  image=movie['medium_cover_image'] as String,
  year=movie['year'] as int,
  rating=(movie['rating'] as num).toDouble(),
  summary=movie['summary'] as String;

  final String title;
  final String image;
  final int year;
  final double rating;
  final String summary;

  String get movieTitle
  {
    return '$title ($year) - $rating';
  }
}
class SecondScreen extends StatelessWidget
{

  @override
  const SecondScreen({Key? key, required this.movie}) : super(key: key);
  final Movie movie;
  Widget build(BuildContext context) {
    return  Scaffold(
        resizeToAvoidBottomInset : false,
      appBar:AppBar(
        title:Text(
            'Movie box office',
          style: TextStyle(fontSize: 15)),
        centerTitle: true,

      ),
      body:

          Padding(
            padding: const EdgeInsets.all(18.0),
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                          maxWidth: 400
                      ),
                      child: Card(
                        elevation: 20,
                        shape:RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100.0)
                        ),
                        child: new Container(
                          color: Color(0xFFD1C4E9),
                          height: 800.0,
                          alignment: Alignment.center,


                            child: new Column(
                             // mainAxisSize: MainAxisSize.min,
                              //mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: new Text(
                                      movie.title,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize:20,

                                    )
                                  ),
                                ),
                                new Image.network(
                                  movie.image,
                                  height:250,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: new Text(
                                      movie.summary,

                                      ),
                                ),
                              ],


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

  }




}