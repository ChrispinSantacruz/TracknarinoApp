import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user_model.dart';
import '../../models/oportunidad_model.dart';
import '../../services/auth_service.dart';
import '../../services/oportunidad_service.dart';
import 'crear_oportunidad_screen.dart';
import 'seguimiento_screen.dart';

class ContratistaHomeScreen extends StatefulWidget {
  final User usuario;

  const ContratistaHomeScreen({
    super.key,
    required this.usuario,
  });

  @override
  State<ContratistaHomeScreen> createState() => _ContratistaHomeScreenState();
}

class _ContratistaHomeScreenState extends State<ContratistaHomeScreen> {
  int _selectedIndex = 0;
  List<Oportunidad> _misOportunidades = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _cargarOportunidades();
  }

  // Cargar oportunidades creadas por este contratista
  Future<void> _cargarOportunidades() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Esta es una función que necesitarías implementar en oportunidadService
      // _misOportunidades = await OportunidadService.obtenerOportunidadesPorContratista(widget.usuario.id!);
      
      // Por ahora, usaremos un placeholder
      _misOportunidades = [];
    } catch (e) {
      print('Error al cargar oportunidades: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Páginas del menú inferior
    final List<Widget> pages = [
      _buildHomePage(), // Dashboard principal
      const CrearOportunidadScreen(), // Crear nueva oportunidad
      const SeguimientoScreen(),
      _buildPerfilContratista(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tracknariño - Contratista'),
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
      body: pages[_selectedIndex],
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
            icon: Icon(Icons.add_circle),
            label: 'Crear',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Seguimiento',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
      floatingActionButton: _selectedIndex == 0 
          ? FloatingActionButton(
              onPressed: () {
                setState(() {
                  _selectedIndex = 1; // Ir a la pestaña de crear oportunidad
                });
              },
              tooltip: 'Crear nueva oportunidad',
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  // Construir la página principal con las tarjetas de información
  Widget _buildHomePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Saludo al usuario
          Text(
            '¡Hola, ${widget.usuario.nombre}!',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 8),
          
          Text(
            'Empresa: ${widget.usuario.empresa}',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Resumen de oportunidades - tarjeta
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Mis Oportunidades',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (_misOportunidades.isEmpty)
                    const Center(
                      child: Text('No has creado oportunidades aún.'),
                    )
                  else
                    Column(
                      children: _misOportunidades.map((oportunidad) {
                        return ListTile(
                          title: Text(oportunidad.titulo),
                          subtitle: Text(
                            'De ${oportunidad.origen} a ${oportunidad.destino} - ${oportunidad.estado}',
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            // Implementar navegación a detalle
                          },
                        );
                      }).toList(),
                    ),
                  
                  const SizedBox(height: 16),
                  
                  OutlinedButton.icon(
                    onPressed: () {
                      setState(() {
                        _selectedIndex = 1; // Ir a la pestaña de crear oportunidad
                      });
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Crear nueva oportunidad'),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Camioneros asignados - tarjeta
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Seguimiento de camioneros',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Center(
                    child: Text('Sin camioneros en ruta actualmente.'),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () {
                      setState(() {
                        _selectedIndex = 2; // Ir a la pestaña de seguimiento
                      });
                    },
                    icon: const Icon(Icons.map),
                    label: const Text('Ver mapa de seguimiento'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Método para construir el perfil del contratista
  Widget _buildPerfilContratista() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Nombre: ${widget.usuario.nombre}'),
          Text('Empresa: ${widget.usuario.empresa}'),
          // Agregar más detalles del perfil aquí
        ],
      ),
    );
  }
} 