enum UserType { camionero, contratista }

class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String since;
  final double rating;
  final UserType userType;
  
  // Campos específicos para camioneros
  final int? trips;
  final int? kilometers;
  final int? deliveries;
  final Vehicle? vehicle;
  
  // Campos específicos para contratistas
  final int? tripsPublished;
  final int? tripsCompleted;
  final Company? company;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.since,
    required this.rating,
    required this.userType,
    this.trips,
    this.kilometers,
    this.deliveries,
    this.vehicle,
    this.tripsPublished,
    this.tripsCompleted,
    this.company,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      since: json['since'],
      rating: json['rating'].toDouble(),
      userType: json['userType'] == 'camionero' 
          ? UserType.camionero 
          : UserType.contratista,
      trips: json['trips'],
      kilometers: json['kilometers'],
      deliveries: json['deliveries'],
      vehicle: json['vehicle'] != null 
          ? Vehicle.fromJson(json['vehicle']) 
          : null,
      tripsPublished: json['tripsPublished'],
      tripsCompleted: json['tripsCompleted'],
      company: json['company'] != null 
          ? Company.fromJson(json['company']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'since': since,
      'rating': rating,
      'userType': userType == UserType.camionero ? 'camionero' : 'contratista',
      'trips': trips,
      'kilometers': kilometers,
      'deliveries': deliveries,
      'vehicle': vehicle?.toJson(),
      'tripsPublished': tripsPublished,
      'tripsCompleted': tripsCompl  vehicle?.toJson(),
      'tripsPublished': tripsPublished,
      'tripsCompleted': tripsCompleted,
      'company': company?.toJson(),
    };
  }
}

class Vehicle {
  final String type;
  final String plate;
  final String capacity;
  final String? imageUrl;
  final String? license;

  Vehicle({
    required this.type,
    required this.plate,
    required this.capacity,
    this.imageUrl,
    this.license,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      type: json['type'],
      plate: json['plate'],
      capacity: json['capacity'],
      imageUrl: json['imageUrl'],
      license: json['license'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'plate': plate,
      'capacity': capacity,
      'imageUrl': imageUrl,
      'license': license,
    };
  }
}

class Company {
  final String name;
  final String nit;
  final String address;

  Company({
    required this.name,
    required this.nit,
    required this.address,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      name: json['name'],
      nit: json['nit'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'nit': nit,
      'address': address,
    };
  }
}
