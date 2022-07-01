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

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        image,
        const Divider(),
        Text(
          movie.originalTitle,
          textWidthBasis: TextWidthBasis.longestLine,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18),
        ),
        Row(
          children: [
            Text(movie.language),
            const Spacer(),
            Text(movie.releaseDate)
          ],
        ),
        _generateTags()
      ],
    );
  }

  Tags _generateTags() {
    return Tags(
      textField: TagsTextField(textStyle: const TextStyle(fontSize: 10)),
      itemCount: movie.genres.length,
      itemBuilder: (int index) {
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
