class AlertaSeguridad {
  final String? id;
  final String tipo;
  final String? descripcion;
  final String usuario;
  final Map<String, double> coords;
  final DateTime timestamp;

  AlertaSeguridad({
    this.id,
    required this.tipo,
    this.descripcion,
    required this.usuario,
    required this.coords,
    required this.timestamp,
  });

  factory AlertaSeguridad.fromJson(Map<String, dynamic> json) {
    return AlertaSeguridad(
      id: json['_id'],
      tipo: json['tipo'],
      descripcion: json['descripcion'],
      usuario: json['usuario'],
      coords: {
        'lat': json['coords']['lat'].toDouble(),
        'lng': json['coords']['lng'].toDouble(),
      },
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tipo': tipo,
      'descripcion': descripcion,
      'usuario': usuario,
      'coords': coords,
      'timestamp': timestamp.toIso8601String(),
    };
  }
  
  // Lista de tipos de alerta válidos
  static List<String> get tiposAlerta => [
    'trancon', 'sospecha', 'intento_robo', 'robo', 'obstaculo'
  ];

  // Obtiene un ícono según el tipo de alerta
  String get iconoAlerta {
    switch (tipo) {
      case 'trancon': return 'assets/icons/trafico.svg';
      case 'sospecha': return 'assets/icons/sospecha.svg';
      case 'intento_robo': return 'assets/icons/robo.svg';
      case 'robo': return 'assets/icons/peligro.svg';
      case 'obstaculo': return 'assets/icons/obstaculo.svg';
      default: return 'assets/icons/alerta.svg';
    }
  }
} 