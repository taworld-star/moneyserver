class Category {
    int id;
    String name;
    String type;

    Category({
        required this.id,
        required this.name,
        required this.type,
    });

    factory Category.fromMap(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
        type: json["type"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "type": type,
    };
}