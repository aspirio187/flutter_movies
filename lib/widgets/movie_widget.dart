import 'package:flutter/material.dart';
import 'package:flutter_movies/models/movie.dart';
import 'package:flutter_tags/flutter_tags.dart';

class MovieWidget extends StatelessWidget {
  const MovieWidget({Key? key, required this.movie}) : super(key: key);

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    Image image = Image.network(
      movie.posterPath,
      width: 250,
      height: 500,
    );

    return Flex(
      direction: Axis.vertical,
      children: [
        image,
        const Divider(),
        Text(
          movie.originalTitle,
          textWidthBasis: TextWidthBasis.longestLine,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18),
        ),
        const Divider(),
        Text('Langue: ' + movie.language),
        const Divider(),
        Text('Date de sortie :' + movie.releaseDate),
        const Divider(),
        _generateTags(),
      ],
    );
  }

  Tags _generateTags() {
    return Tags(
      itemCount: movie.genres.length,
      itemBuilder: (int index) {
        if (movie.genres.isEmpty) {
          return ItemTags(index: 0, title: 'No tags');
        }

        final genre = movie.genres[index];

        return ItemTags(
          key: Key(index.toString()),
          index: index,
          title: genre.name,
        );
      },
      spacing: 1.5,
    );
  }
}
