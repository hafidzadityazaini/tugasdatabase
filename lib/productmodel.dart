class ContactModel {
  int? id;
  String? name;
  String? email;
  String? phone;

  ContactModel({this.id, this.name, this.email, this.phone});

  factory ContactModel.fromMap(Map<String, dynamic> map) {
    return ContactModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
    };
  } 
}