enum UrgencyLevel { alta, normal, baja }
enum TripStatus { pending, assigned, inProgress, completed, cancelled }

class TripOffer {
  final String id;
  final String origin;
  final String destination;
  final String date;
  final double price;
  final int distance;
  final String cargo;
  final String weight;
  final String client;
  final UrgencyLevel urgency;
  final List<String> paymentMethods;
  final String? preferredPaymentMethod;
  final String description;
  final TripStatus status;
  final String? assignedDriverId;
  final List<RoadAlert>? roadAlerts;

  TripOffer({
    required this.id,
    required this.origin,
    required this.destination,
    required this.date,
    required this.price,
    required this.distance,
    required this.cargo,
    required this.weight,
    required this.client,
    required this.urgency,
    required this.paymentMethods,
    this.preferredPaymentMethod,
    required this.description,
    this.status = TripStatus.pending,
    this.assignedDriverId,
    this.roadAlerts,
  });

  factory TripOffer.fromJson(Map<String, dynamic> json) {
    UrgencyLevel getUrgency(String value) {
      switch (value) {
        case 'alta':
          return UrgencyLevel.alta;
        case 'baja':
          return UrgencyLevel.baja;
        default:
          return UrgencyLevel.normal;
      }
    }

    TripStatus getStatus(String? value) {
      switch (value) {
        case 'assigned':
          return TripStatus.assigned;
        case 'inProgress':
          return TripStatus.inProgress;
        case 'completed':
          return TripStatus.completed;
        case 'cancelled':
          return TripStatus.cancelled;
        default:
          return TripStatus.pending;
      }
    }

    List<RoadAlert>? roadAlerts;
    if (json['roadAlerts'] != null) {
      roadAlerts = (json['roadAlerts'] as List)
          .map((alert) => RoadAlert.fromJson(alert))
          .toList();
    }

    return TripOffer(
      id: json['id'],
      origin: json['origin'],
      destination: json['destination'],
      date: json['date'],
      price: json['price'].toDouble(),
      distance: json['distance'],
      cargo: json['cargo'],
      weight: json['weight'],
      client: json['client'],
      urgency: getUrgency(json['urgency']),
      paymentMethods: List<String>.from(json['paymentMethods']),
      preferredPaymentMethod: json['preferredPaymentMethod'],
      description: json['description'],
      status: getStatus(json['status']),
      assignedDriverId: json['assignedDriverId'],
      roadAlerts: roadAlerts,
    );
  }

  Map<String, dynamic> toJson() {
    String getUrgencyString() {
      switch (urgency) {
        case UrgencyLevel.alta:
          return 'alta';
        case UrgencyLevel.baja:
          return 'baja';
        default:
          return 'normal';
      }
    }

    String getStatusString() {
      switch (status) {
        case TripStatus.assigned:
          return 'assigned';
        case TripStatus.inProgress:
          return 'inProgress';
        case TripStatus.completed:
          return 'completed';
        case TripStatus.cancelled:
          return 'cancelled';
        default:
          return 'pending';
      }
    }

    final Map<String, dynamic> data = {
      'id': id,
      'origin': origin,
      'destination': destination,
      'date': date,
      'price': price,
      'distance': distance,
      'cargo': cargo,
      'weight': weight,
      'client': client,
      'urgency': getUrgencyString(),
      'paymentMethods': paymentMethods,
      'preferredPaymentMethod': preferredPaymentMethod,
      'description': description,
      'status': getStatusString(),
      'assignedDriverId': assignedDriverId,
    };

    if (roadAlerts != null) {
      data['roadAlerts'] = roadAlerts!.map((alert) => alert.toJson()).toList();
    }

    return data;
  }

  TripOffer copyWith({
    String? id,
    String? origin,
    String? destination,
    String? date,
    double? price,
    int? distance,
    String? cargo,
    String? weight,
    String? client,
    UrgencyLevel? urgency,
    List<String>? paymentMethods,
    String? preferredPaymentMethod,
    String? description,
    TripStatus? status,
    String? assignedDriverId,
    List<RoadAlert>? roadAlerts,
  }) {
    return TripOffer(
      id: id ?? this.id,
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
      date: date ?? this.date,
      price: price ?? this.price,
      distance: distance ?? this.distance,
      cargo: cargo ?? this.cargo,
      weight: weight ?? this.weight,
      client: client ?? this.client,
      urgency: urgency ?? this.urgency,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      preferredPaymentMethod: preferredPaymentMethod ?? this.preferredPaymentMethod,
      description: description ?? this.description,
      status: status ?? this.status,
      assignedDriverId: assignedDriverId ?? this.assignedDriverId,
      roadAlerts: roadAlerts ?? this.roadAlerts,
    );
  }
}

class RoadAlert {
  final String id;
  final String title;
  final String description;
  final String location;
  final DateTime timestamp;
  final RoadAlertType type;
  final String reportedBy;
  final bool isActive;

  RoadAlert({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.timestamp,
    required this.type,
    required this.reportedBy,
    this.isActive = true,
  });

  factory RoadAlert.fromJson(Map<String, dynamic> json) {
    RoadAlertType getType(String value) {
      switch (value) {
        case 'blockage':
          return RoadAlertType.blockage;
        case 'accident':
          return RoadAlertType.accident;
        case 'construction':
          return RoadAlertType.construction;
        case 'weather':
          return RoadAlertType.weather;
        default:
          return RoadAlertType.other;
      }
    }

    return RoadAlert(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      location: json['location'],
      timestamp: DateTime.parse(json['timestamp']),
      type: getType(json['type']),
      reportedBy: json['reportedBy'],
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    String getTypeString() {
      switch (type) {
        case RoadAlertType.blockage:
          return 'blockage';
        case RoadAlertType.accident:
          return 'accident';
        case RoadAlertType.construction:
          return 'construction';
        case RoadAlertType.weather:
          return 'weather';
        default:
          return 'other';
      }
    }

    return {
      'id': id,
      'title': title,
      'description': description,
      'location': location,
      'timestamp': timestamp.toIso8601String(),
      'type': getTypeString(),
      'reportedBy': reportedBy,
      'isActive': isActive,
    };
  }
}

enum RoadAlertType { blockage, accident, construction, weather, other }
