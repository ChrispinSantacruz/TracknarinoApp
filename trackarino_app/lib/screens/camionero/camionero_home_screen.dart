import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../../services/location_service.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math' as math;
import '../../models/oportunidad_model.dart';
import '../../screens/camionero/alertas_screen.dart';
import '../../utils/flutter_map_fixes.dart';

class CamioneroHomeScreen extends StatefulWidget {
  final User usuario;

  const CamioneroHomeScreen({
    super.key,
    required this.usuario,
  });

  @override
  State<CamioneroHomeScreen> createState() => _CamioneroHomeScreenState();
}

class _CamioneroHomeScreenState extends State<CamioneroHomeScreen> {
  int _selectedIndex = 0;
  bool _isLoading = false;
  final LocationService _locationService = LocationService();
  final MapController _mapController = MapController();
  LatLng? _currentPosition;
  LatLng? _destinoPosition;
  
  bool _isFollowingUser = true;
  final List<Oportunidad> _oportunidadesAsignadas = [];

  @override
  void initState() {
    super.initState();
    _initLocationTracking();
    _cargarOportunidades();
    _initializeLocation();
    
    // Coordenadas simuladas para pruebas (Pasto - Nariño)
    _destinoPosition = LatLng(1.2136, -77.2811);
  }

  // Iniciar el seguimiento de ubicación
  Future<void> _initLocationTracking() async {
    final locationService = Provider.of<LocationService>(context, listen: false);
    await locationService.startTracking();
  }

  // Cargar oportunidades asignadas al camionero
  Future<void> _cargarOportunidades() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Esta es una función que necesitarías implementar en oportunidadService
      // _oportunidadesAsignadas = await OportunidadService.obtenerOportunidadesAsignadas(widget.usuario.id!);
      
      // Por ahora, usaremos un placeholder
    } catch (e) {
      debugPrint('Error al cargar oportunidades: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _initializeLocation() async {
    try {
      // Iniciar el servicio de localización
      if (widget.usuario.id != null) {
        await _locationService.init(widget.usuario.id!);
      }
      
      // Obtener posición actual
      final position = await _locationService.getCurrentLocation();
      
      if (position != null && mounted) {
        setState(() {
          _currentPosition = LatLng(position.latitude, position.longitude);
          _isLoading = false;
        });
      }
      
      // Suscribirse a actualizaciones de posición
      _locationService.positionStream.listen((position) {
        if (mounted) {
          setState(() {
            _currentPosition = LatLng(position.latitude, position.longitude);
          });
          
          // Centrar mapa si está siguiendo al usuario
          if (_isFollowingUser) {
            _mapController.move(_currentPosition!, _mapController.zoom);
          }
        }
      });
    } catch (e) {
      debugPrint('Error al inicializar ubicación: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          // Usar coordenadas predeterminadas para pruebas (Pasto)
          _currentPosition = LatLng(1.2053, -77.2886);
        });
      }
    }
  }

  void _toggleFollowUser() {
    setState(() {
      _isFollowingUser = !_isFollowingUser;
      
      if (_isFollowingUser && _currentPosition != null) {
        _mapController.move(_currentPosition!, _mapController.zoom);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tracknariño - Camionero'),
        actions: [
          IconButton(
            onPressed: () async {
              await Provider.of<AuthService>(context, listen: false).logout();
            },
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                // Mostrar mapa solo en la pantalla de inicio
                if (_selectedIndex == 0) _buildMap(),
                // Mostrar lista de oportunidades
                if (_selectedIndex == 1) _buildOportunidadesList(),
                // Mostrar alertas
                if (_selectedIndex == 2) _buildAlertas(),
                // Panel de estado
                _buildStatusPanel(),
              ],
            ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_shipping),
            label: 'Oportunidades',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.warning),
            label: 'Alertas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }

  Widget _buildMap() {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        center: _currentPosition ?? LatLng(1.2053, -77.2886),
        zoom: 13.0,
        onPositionChanged: (position, hasGesture) {
          if (hasGesture) {
            setState(() {
              _isFollowingUser = false;
            });
          }
        },
      ),
      children: [
        TileLayer(
          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: const ['a', 'b', 'c'],
        ),
        MarkerLayer(
          markers: [
            if (_currentPosition != null)
              Marker(
                width: 40.0,
                height: 40.0,
                point: _currentPosition!,
                builder: (ctx) => Icon(
                  Icons.location_on,
                  color: Colors.blue,
                  size: 40,
                ),
              ),
            if (_destinoPosition != null)
              Marker(
                width: 40.0,
                height: 40.0,
                point: _destinoPosition!,
                builder: (ctx) => Icon(
                  Icons.flag,
                  color: Colors.red,
                  size: 40,
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildControls() {
    return Positioned(
      right: 16,
      bottom: 200,
      child: Column(
        children: [
          FloatingActionButton(
            heroTag: 'zoom_in',
            onPressed: () {
              _mapController.move(
                _mapController.center, 
                _mapController.zoom + 1.0
              );
            },
            mini: true,
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: 'zoom_out',
            onPressed: () {
              _mapController.move(
                _mapController.center, 
                _mapController.zoom - 1.0
              );
            },
            mini: true,
            child: const Icon(Icons.remove),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: 'my_location',
            onPressed: _toggleFollowUser,
            mini: true,
            backgroundColor: _isFollowingUser ? Colors.blue : Colors.grey,
            child: const Icon(Icons.my_location),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteInfo() {
    // Calcular distancia aproximada en km
    final distance = calculateDistance(_currentPosition!, _destinoPosition!).round();
    
    return Positioned(
      left: 16,
      right: 16,
      bottom: 100,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.red),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Destino: Pasto, Nariño',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$distance km',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Dirección: Calle 20 # 15-30, Centro, Pasto',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildStatusPanel() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(25),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'En ruta',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Tiempo estimado:',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '45 minutos restantes',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    _showAlertDialog(context);
                  },
                  child: const Text('Alertar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reportar problema'),
          content: const Text('¿Deseas reportar un problema en tu ruta?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _selectedIndex = 2; // Cambiar a pantalla de alertas
                });
              },
              child: const Text('Ir a Alertas'),
            ),
          ],
        );
      },
    );
  }
  
  double calculateDistance(LatLng point1, LatLng point2) {
    // Cálculo simple de distancia en kilómetros usando la fórmula de Haversine
    const R = 6371.0; // Radio de la Tierra en km
    
    final lat1Rad = point1.latitude * (math.pi / 180);
    final lat2Rad = point2.latitude * (math.pi / 180);
    final dLat = (point2.latitude - point1.latitude) * (math.pi / 180);
    final dLon = (point2.longitude - point1.longitude) * (math.pi / 180);
    
    final a = math.sin(dLat/2) * math.sin(dLat/2) +
              math.cos(lat1Rad) * math.cos(lat2Rad) * 
              math.sin(dLon/2) * math.sin(dLon/2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1-a));
    
    return R * c;
  }

  // Método para construir la lista de oportunidades
  Widget _buildOportunidadesList() {
    return ListView.builder(
      itemCount: _oportunidadesAsignadas.length,
      itemBuilder: (context, index) {
        final oportunidad = _oportunidadesAsignadas[index];
        return ListTile(
          title: Text(oportunidad.titulo),
          subtitle: Text('De ${oportunidad.origen} a ${oportunidad.destino}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.check, color: Colors.green),
                onPressed: () {
                  // Lógica para aceptar la oportunidad
                },
              ),
              IconButton(
                icon: Icon(Icons.close, color: Colors.red),
                onPressed: () {
                  // Lógica para rechazar la oportunidad
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Método para construir la lista de alertas
  Widget _buildAlertas() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Encabezado con botón para crear nueva alerta
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Alertas de seguridad',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => const AlertasScreen(),
                    ),
                  ).then((_) => {
                    // Recargar datos cuando regresa
                  });
                },
                icon: const Icon(Icons.add_alert),
                label: const Text('Crear alerta'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
        
        // Lista de alertas (vacía por ahora)
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.notification_important,
                        size: 64,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No hay alertas activas',
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Usa el botón "Alertar" para reportar problemas',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 24),
                      OutlinedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context, 
                            MaterialPageRoute(
                              builder: (context) => const AlertasScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.warning),
                        label: const Text('Ver todas las alertas'),
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }
} 