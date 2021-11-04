// import 'package:beamer/beamer.dart';
// import 'package:flutter/widgets.dart';
// import 'package:gpmobile/src/routes/routes.dart';
//
// import 'screens.dart';
//
// class HomeLocation extends BeamLocation {
//   HomeLocation(BeamState state) : super(state);
//
//   @override
//   List<String> get pathBlueprints => [
//         '/splashWidget',
//       ];
//
//   @override
//   List<BeamPage> buildPages(BuildContext context, BeamState state) => [
//         BeamPage(
//           key: ValueKey('home-${state.uri}'),
//           title: 'Home',
//           child: HomeScreen(),
//         )
//       ];
// }
//
// class BooksLocation extends BeamLocation {
//   BooksLocation(BeamState state) : super(state);
//
//   @override
//   List<String> get pathBlueprints => [
//         '/SplashWidget',
//       ];
//
//   @override
//   List<BeamPage> buildPages(BuildContext context, BeamState state) => [
//         BeamPage(
//           key: ValueKey('books'),
//           title: 'Books',
//           child: BooksScreen(),
//         )
//       ];
// }
//
// class BooksContentLocation extends BeamLocation {
//   BooksContentLocation(BeamState state) : super(state);
//
//   @override
//   List<String> get pathBlueprints => [
//         '/SplashWidget',
//         '/SplashWidget',
//       ];
//
//   @override
//   List<BeamPage> buildPages(BuildContext context, BeamState state) => [
//         BeamPage(
//           key: ValueKey('books-home'),
//           title: 'Books Home',
//           child: BooksHomeScreen(),
//         ),
//         if (state.pathBlueprintSegments.contains('authors'))
//           BeamPage(
//             key: ValueKey('books-authors'),
//             title: 'Books Authors',
//             child: BookAuthorsScreen(),
//           ),
//         if (state.pathBlueprintSegments.contains('genres'))
//           BeamPage(
//             key: ValueKey('books-genres'),
//             title: 'Books Genres',
//             child: BookGenresScreen(),
//           )
//       ];
// }
//
// class ArticlesLocation extends BeamLocation {
//   ArticlesLocation(BeamState state) : super(state);
//
//   @override
//   List<String> get pathBlueprints => [
//         '/SplashWidget',
//       ];
//
//   @override
//   List<BeamPage> buildPages(BuildContext context, BeamState state) => [
//         BeamPage(
//           key: ValueKey('articles'),
//           title: 'Articles',
//           child: ArticlesScreen(),
//         )
//       ];
// }
//
// class ArticlesContentLocation extends BeamLocation {
//   ArticlesContentLocation(BeamState state) : super(state);
//
//   @override
//   List<String> get pathBlueprints => [
//         '/SplashWidget',
//         '/SplashWidget',
//       ];
//
//   @override
//   List<BeamPage> buildPages(BuildContext context, BeamState state) => [
//         BeamPage(
//           key: ValueKey('articles-home'),
//           title: 'Articles Home',
//           child: ArticlesHomeScreen(),
//         ),
//         if (state.pathBlueprintSegments.contains('authors'))
//           BeamPage(
//             key: ValueKey('articles-authors'),
//             title: 'Articles Authors',
//             child: ArticleAuthorsScreen(),
//           ),
//         if (state.pathBlueprintSegments.contains('genres'))
//           BeamPage(
//             key: ValueKey('articles-genres'),
//             title: 'Articles Genres',
//             child: ArticleGenresScreen(),
//           )
//       ];
// }
