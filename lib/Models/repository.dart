class Repository {
  final int id;
  final String name;
  final String image;
  final String login;

  Repository({required this.id, required this.name, required this.image, required this.login});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name,'image':image,'login':login};
  }
}
