import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackarino/models/trip_offer_model.dart';
import 'package:trackarino/models/user_model.dart';
import 'package:trackarino/providers/auth_provider.dart';
import 'package:trackarino/providers/trip_provider.dart';
import 'package:trackarino/screens/trips/create_trip_screen.dart';
import 'package:trackarino/screens/trips/trip_details_screen.dart';
import 'package:trackarino/widgets/trip_card.dart';

class TripsScreen extends StatefulWidget {
  @override
  _TripsScreenState createState() => _TripsScreenState();
}

class _TripsScreenState extends State<TripsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = '';
  String _filterType = 'all';
  List<TripOffer> _filteredOffers = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    
    // Cargar ofertas de viajes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TripProvider>(context, listen: false).loadTripOffers();
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchTerm = _searchController.text;
      _filterOffers();
    });
  }

  void _filterOffers() {
    final tripProvider = Provider.of<TripProvider>(context, listen: false);
    final allOffers = tripProvider.tripOffers;
    
    setState(() {
      _filteredOffers = allOffers.where((offer) {
        // Filtrar por término de búsqueda
        final matchesSearch = _searchTerm.isEmpty ||
            offer.origin.toLowerCase().contains(_searchTerm.toLowerCase()) ||
            offer.destination.toLowerCase().contains(_searchTerm.toLowerCase()) ||
            offer.cargo.toLowerCase().contains(_searchTerm.toLowerCase());
        
        // Filtrar por tipo de urgencia
        final matchesFilter = _filterType == 'all' ||
            (_filterType == 'alta' && offer.urgency == UrgencyLevel.alta) ||
            (_filterType == 'normal' && offer.urgency == UrgencyLevel.normal) ||
            (_filterType == 'baja' && offer.urgency == UrgencyLevel.baja);
        
        return matchesSearch && matchesFilter;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).currentUser!;
    final isContratista = user.userType == UserType.contratista;
    final tripProvider = Provider.of<TripProvider>(context);
    
    // Actualizar la lista filtrada cuando cambian las ofertas
    if (_filteredOffers.isEmpty && tripProvider.tripOffers.isNotEmpty) {
      _filteredOffers = tripProvider.tripOffers;
    }
    
    return Scaffold(
      body: Column(
        children: [
          // Tarjeta de búsqueda y filtros
          Card(
            margin: EdgeInsets.all(8),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isContratista ? 'Gestión de Viajes' : 'Buscar Ofertas de Viajes',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (isContratista)
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CreateTripScreen(),
                              ),
                            );
                          },
                          icon: Icon(Icons.add, size: 18),
                          label: Text('Nuevo Viaje'),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green[600],
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      // Campo de búsqueda
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Buscar por origen, destino o tipo de carga...',
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 0),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      // Filtro de urgencia
                      Container(
                        width: 150,
                        child: DropdownButtonFormField<String>(
                          value: _filterType,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12),
                          ),
                          items: [
                            DropdownMenuItem(
                              value: 'all',
                              child: Text('Todas'),
                            ),
                            DropdownMenuItem(
                              value: 'alta',
                              child: Text('Urgencia alta'),
                            ),
                            DropdownMenuItem(
                              value: 'normal',
                              child: Text('Urgencia normal'),
                            ),
                            DropdownMenuItem(
                              value: 'baja',
                              child: Text('Urgencia baja'),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _filterType = value!;
                              _filterOffers();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // Lista de ofertas
          Expanded(
            child: tripProvider.isLoading
                ? Center(child: CircularProgressIndicator())
                : _filteredOffers.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: EdgeInsets.all(8),
                        itemCount: _filteredOffers.length,
                        itemBuilder: (context, index) {
                          final offer = _filteredOffers[index];
                          return TripCard(
                            tripOffer: offer,
                            isContratista: isContratista,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TripDetailsScreen(
                                    tripOffer: offer,
                                    isContratista: isContratista,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 64,
            color: Colors.grey[300],
          ),
          SizedBox(height: 16),
          Text(
            'No se encontraron ofertas',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Intenta con otros términos de búsqueda o filtros',
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
