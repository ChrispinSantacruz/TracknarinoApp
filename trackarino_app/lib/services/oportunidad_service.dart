import '../config/api_config.dart';
import '../models/oportunidad_model.dart';
import 'api_service.dart';
import 'dart:math';

class OportunidadService {
  static final Random _random = Random();
  
  // Lista de lugares en Nariño para simulación
  static final List<String> _origenes = [
    'Pasto', 'Ipiales', 'Tumaco', 'La Unión', 'Túquerres',
    'Sandoná', 'La Cruz', 'Buesaco', 'Pupiales', 'Samaniego'
  ];
  
  static final List<String> _destinos = [
    'Cali', 'Bogotá', 'Medellín', 'Buenaventura', 'Popayán',
    'Neiva', 'Barranquilla', 'Cartagena', 'Bucaramanga', 'Mocoa'
  ];
  
  static final List<String> _tiposCarga = [
    'Productos agrícolas', 'Material de construcción', 'Alimentos procesados',
    'Productos lácteos', 'Muebles', 'Electrodomésticos', 'Insumos agrícolas',
    'Equipos médicos', 'Productos farmacéuticos', 'Equipos electrónicos'
  ];
  
  static final List<String> _requisitosEspecificos = [
    'Refrigeración', 'Camión grande (>10 ton)', 'Camión pequeño (<5 ton)',
    'Permiso especial para químicos', 'Transporte con seguro especializado',
    'Requiere entrega urgente', 'Requiere experiencia previa', 'Preferible camión cerrado',
    'Carga frágil', ''
  ];

  // Obtener listado de oportunidades disponibles
  static Future<List<Oportunidad>> obtenerOportunidadesDisponibles() async {
    try {
      final response = await ApiService.get(ApiConfig.oportunidades);
      return (response as List)
          .map((data) => Oportunidad.fromJson(data))
          .toList();
    } catch (e) {
      print('Error al obtener oportunidades: $e');
      rethrow;
    }
  }

  // Obtener detalles de una oportunidad específica
  static Future<Oportunidad?> obtenerDetalleOportunidad(String id) async {
    try {
      final response = await ApiService.get('${ApiConfig.oportunidades}/$id');
      return Oportunidad.fromJson(response);
    } catch (e) {
      print('Error al obtener detalle de oportunidad: $e');
      
      // Devolver una oportunidad simulada para desarrollo
      final simuladas = _generarOportunidadesSimuladas();
      return simuladas.firstWhere(
        (o) => o.id == id, 
        orElse: () => simuladas.first
      );
    }
  }
  
  // Aplicar a una oportunidad
  static Future<Map<String, dynamic>> aplicarOportunidad(String oportunidadId) async {
    try {
      final response = await ApiService.post(
        '${ApiConfig.oportunidades}/aplicar/$oportunidadId', 
        {}
      );
      return response;
    } catch (e) {
      print('Error al aplicar a oportunidad: $e');
      // Simular respuesta exitosa para desarrollo
      return {
        'success': true,
        'message': 'Aplicación enviada correctamente',
      };
    }
  }
  
  // Método auxiliar para generar datos simulados
  static List<Oportunidad> _generarOportunidadesSimuladas() {
    List<Oportunidad> oportunidades = [];
    
    // Generar entre 6 y 15 oportunidades
    int cantidad = _random.nextInt(10) + 6;
    
    for (int i = 0; i < cantidad; i++) {
      // Seleccionar origen y destino aleatorios distintos
      String origen = _origenes[_random.nextInt(_origenes.length)];
      String destino;
      do {
        destino = _destinos[_random.nextInt(_destinos.length)];
      } while (destino == origen);
      
      // Tipo de carga aleatorio
      String tipoCarga = _tiposCarga[_random.nextInt(_tiposCarga.length)];
      
      // Generar fecha entre hoy y 15 días adelante
      DateTime fechaActual = DateTime.now();
      int diasAdelante = _random.nextInt(15);
      DateTime fecha = fechaActual.add(Duration(days: diasAdelante));
      
      // Peso de carga entre 1 y 20 toneladas
      int peso = _random.nextInt(19) + 1;
      
      // Precio entre 500.000 y 5.000.000 COP
      int precio = (_random.nextInt(45) + 5) * 100000;
      
      // 40% de probabilidad de requisitos específicos
      String? requisitos;
      if (_random.nextInt(10) < 4) {
        requisitos = _requisitosEspecificos[_random.nextInt(_requisitosEspecificos.length)];
        if (requisitos.isEmpty) requisitos = null;
      }
      
      String direccionOrigen = _generarDireccionAleatoria(origen);
      String direccionDestino = _generarDireccionAleatoria(destino);
      
      oportunidades.add(Oportunidad(
        id: '${1000 + i}',
        titulo: 'Transporte de $tipoCarga de $origen a $destino',
        descripcion: 'Se requiere transportar $peso toneladas de $tipoCarga desde $origen hasta $destino.${requisitos != null ? ' Requisito especial: $requisitos.' : ''}',
        origen: origen,
        destino: destino,
        direccionCargue: direccionOrigen,
        direccionDescargue: direccionDestino,
        fecha: fecha,
        precio: precio.toDouble(),
        pesoCarga: peso,
        tipoCarga: tipoCarga,
        requisitosEspeciales: requisitos,
        contratista: 'Contratista #${1000 + _random.nextInt(50)}',
        distanciaKm: 50 + _random.nextInt(950), // Entre 50 y 1000 km
        duracionEstimadaHoras: 1 + _random.nextInt(23), // Entre 1 y 24 horas
        estado: 'disponible',
        finalizada: false,
      ));
    }
    
    return oportunidades;
  }
  
  // Generar dirección aleatoria para simulación
  static String _generarDireccionAleatoria(String ciudad) {
    List<String> calles = ['Calle', 'Carrera', 'Avenida', 'Diagonal', 'Transversal'];
    List<String> sectores = ['Centro', 'Norte', 'Sur', 'Oriente', 'Occidente', 'Industrial', 'Comercial', 'Residencial'];
    
    String tipoCalle = calles[_random.nextInt(calles.length)];
    int numeroCalle = 1 + _random.nextInt(100);
    int numeroCasa = 1 + _random.nextInt(150);
    String sector = sectores[_random.nextInt(sectores.length)];
    
    return '$tipoCalle $numeroCalle # $numeroCasa, $sector, $ciudad';
  }

  // Crear una nueva oportunidad (solo contratistas)
  static Future<Oportunidad?> crearOportunidad({
    required String titulo,
    String? descripcion,
    required String origen,
    required String destino,
    required DateTime fecha,
    required double precio,
  }) async {
    try {
      final data = {
        'titulo': titulo,
        'descripcion': descripcion,
        'origen': origen,
        'destino': destino,
        'fecha': fecha.toIso8601String(),
        'precio': precio,
      };

      final response = await ApiService.post('${ApiConfig.oportunidades}/crear', data);
      return Oportunidad.fromJson(response['oportunidad']);
    } catch (e) {
      print('Error al crear oportunidad: $e');
      return null;
    }
  }
  
  // Crear una nueva oportunidad con todos los campos (solo contratistas)
  static Future<Oportunidad?> crearOportunidadCompleta(Map<String, dynamic> data) async {
    try {
      print('Intentando crear oportunidad con datos: $data');
      final response = await ApiService.post('${ApiConfig.oportunidades}/crear', data);
      
      print('Respuesta del servidor al crear oportunidad: $response');
      return Oportunidad.fromJson(response['oportunidad']);
    } catch (e) {
      print('Error detallado al crear oportunidad completa: $e');
      
      if (ApiConfig.isDevelopment) {
        print('Simulando respuesta de oportunidad en modo desarrollo tras error');
        print('Intentando crear oportunidad con datos: $data');
        // Crear una oportunidad simulada en caso de error si estamos en desarrollo
        return Oportunidad(
          id: '${1000 + _random.nextInt(999)}',
          titulo: data['titulo'],
          descripcion: data['descripcion'],
          origen: data['origen'],
          destino: data['destino'],
          direccionCargue: data['direccionCargue'],
          direccionDescargue: data['direccionDescargue'],
          fecha: DateTime.parse(data['fecha']),
          precio: data['precio'].toDouble(),
          pesoCarga: data['pesoCarga'],
          tipoCarga: data['tipoCarga'],
          requisitosEspeciales: data['requisitosEspeciales'],
          contratista: 'Usuario actual',
          estado: 'disponible',
          finalizada: false,
        );
      }
      return null;
    }
  }

  // Asignar un camionero a una oportunidad (solo contratistas)
  static Future<bool> asignarCamionero({
    required String oportunidadId,
    required String camioneroId,
  }) async {
    try {
      final data = {
        'camioneroId': camioneroId,
      };

      await ApiService.post(
        '${ApiConfig.oportunidades}/asignar/$oportunidadId', 
        data
      );
      return true;
    } catch (e) {
      print('Error al asignar camionero: $e');
      return false;
    }
  }

  // Finalizar una carga (solo contratistas)
  static Future<bool> finalizarCarga(String oportunidadId) async {
    try {
      await ApiService.post(
        '${ApiConfig.oportunidades}/finalizar/$oportunidadId',
        {}
      );
      return true;
    } catch (e) {
      print('Error al finalizar carga: $e');
      return false;
    }
  }

  /// Aceptar una oportunidad (nuevo método con validaciones)
  static Future<Oportunidad> aceptarOportunidad(String oportunidadId) async {
    try {
      final response = await ApiService.put(
        '${ApiConfig.oportunidades}/$oportunidadId/aceptar',
        {},
      );
      
      return Oportunidad.fromJson(response['oportunidad']);
    } catch (e) {
      print('Error al aceptar oportunidad: $e');
      rethrow;
    }
  }

  /// Obtener viaje activo del camionero
  static Future<Oportunidad?> obtenerViajeActivo() async {
    try {
      final response = await ApiService.get('${ApiConfig.oportunidades}/viaje-activo');
      
      if (response['viajeActivo'] == null) {
        return null;
      }
      
      return Oportunidad.fromJson(response['viajeActivo']);
    } catch (e) {
      print('Error al obtener viaje activo: $e');
      return null;
    }
  }

  /// Iniciar viaje
  static Future<Oportunidad> iniciarViaje(String oportunidadId) async {
    try {
      final response = await ApiService.put(
        '${ApiConfig.oportunidades}/$oportunidadId/iniciar',
        {},
      );
      
      return Oportunidad.fromJson(response['oportunidad']);
    } catch (e) {
      print('Error al iniciar viaje: $e');
      rethrow;
    }
  }
} 