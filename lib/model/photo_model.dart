class PhotoModel {
  String id;
  String pathImage;
  DateTime createdAt;

  PhotoModel({
    required this.id,
    required this.pathImage,
    required this.createdAt,
  });

  factory PhotoModel.fromJson(Map<String, dynamic> json) => PhotoModel(
        id: json["id"],
        pathImage: json["pathImage"],
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "pathImage": pathImage,
        "createdAt": createdAt.toIso8601String(),
      };
}
