enum Type { movie }

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

final typeValues = EnumValues({"movie": Type.movie});

class MovieData {
  String title;
  String year;
  String imdbId;
  Type type;
  String poster;

  MovieData({
    required this.title,
    required this.year,
    required this.imdbId,
    required this.type,
    required this.poster,
  });

  factory MovieData.fromJson(Map<String, dynamic> json) => MovieData(
        title: json["Title"],
        year: json["Year"],
        imdbId: json["imdbID"],
        type: typeValues.map[json["Type"]]!,
        poster: json["Poster"],
      );

  Map<String, dynamic> toJson() => {
        "Title": title,
        "Year": year,
        "imdbID": imdbId,
        "Type": typeValues.reverse[type],
        "Poster": poster,
      };
}
