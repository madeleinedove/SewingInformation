class PatternInfo {
  String name;
  String description;
  List<String> tags;
  PatternManufactors manufactor;

  PatternInfo(this.name, this.description, this.tags, this.manufactor);

  PatternInfo.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String,
        description = json['description'] as String,
        tags = List<String>.from(json['tags']),
        manufactor = PatternManufactors.values.byName(json['manufactor']);
}

enum PatternManufactors {
  burda,
  mcCall,
  simplicity,
  vogue,
  butterick,
  kwikSew,
  newLook,
  other
}
