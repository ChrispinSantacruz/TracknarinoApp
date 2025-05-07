class AppConstants {
  // Colores
  static const String primaryColor = '#4CAF50';
  static const String accentColor = '#66BB6A';
  
  // Métodos de pago
  static const List<String> paymentMethods = [
    'Transferencia bancaria',
    'Nequi',
    'PSE',
    'Efectivo',
    'Daviplata',
  ];
  
  // Niveles de urgencia
  static const Map<String, String> urgencyLevels = {
    'alta': 'Alta',
    'normal': 'Normal',
    'baja': 'Baja',
  };
  
  // Mensajes
  static const String appName = 'TRACKNARIÑO';
  static const String appSlogan = 'Conectando caminos en Nariño y Colombia';
  
  // Rutas de navegación
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String dashboardRoute = '/dashboard';
  static const String createTripRoute = '/create-trip';
  static const String tripDetailsRoute = '/trip-details';
}
