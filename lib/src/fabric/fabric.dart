class FabricInfo {
  String name;
  String description;
  List<String> tags;
  String url;

  FabricInfo(this.name, this.description, this.tags, this.url);

  FabricInfo.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String,
        description = json['description'] as String,
        tags = json['tags'].cast<String>(),
        url = json['url'] as String;
}
