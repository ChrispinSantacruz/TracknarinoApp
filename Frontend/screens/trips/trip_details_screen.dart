import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackarino/models/trip_offer_model.dart';
import 'package:trackarino/models/user_model.dart';
import 'package:trackarino/providers/auth_provider.dart';
import 'package:trackarino/providers/trip_provider.dart';
import 'package:trackarino/screens/trips/create_trip_screen.dart';

class TripDetailsScreen extends StatelessWidget {
  final TripOffer tripOffer;
  final bool isContratista;

  const TripDetailsScreen({
    Key? key,
    required this.tripOffer,
    required this.isContratista,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del Viaje'),
        backgroundColor: Colors.green[600],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Origen - Destino
              Row(
                children: [
                  Icon(Icons.location_on, color: Colors.green[500], size: 24),
                  SizedBox(width: 8),
                  Text(
                    '${tripOffer.origin} → ${tripOffer.destination}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 8),
                  if (tripOffer.urgency == UrgencyLevel.alta)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Urgente',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 24),
              
              // Información principal
              _buildInfoCard(context),
              SizedBox(height: 16),
              
              // Descripción
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Descripción',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(tripOffer.description),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              
              // Métodos de pago
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Métodos de Pago Aceptados',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: tripOffer.paymentMethods.map((method) {
                          final isPreferred = method == tripOffer.preferredPaymentMethod;
                          
                          return Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: isPreferred ? Colors.green[50] : Colors.grey[100],
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isPreferred ? Colors.green[300]! : Colors.grey[300]!,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _getPaymentMethodIcon(method),
                                SizedBox(width: 6),
                                Text(
                                  method,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isPreferred ? Colors.green[700] : Colors.grey[800],
                                    fontWeight: isPreferred ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                                if (isPreferred) ...[
                                  SizedBox(width: 4),
                                  Icon(
                                    Icons.star,
                                    size: 14,
                                    color: Colors.amber,
                                  ),
                                ],
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              
              // Precio total
              Card(
                color: Colors.green[50],
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Pago por el viaje',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '\$${tripOffer.price.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[700],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Aprox. \$${(tripOffer.price / tripOffer.distance).round()} por km',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 32),
              
              // Botones de acción
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Volver'),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (isContratista) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreateTripScreen(tripToEdit: tripOffer),
                            ),
                          );
                        } else {
                          _applyForTrip(context);
                        }
                      },
                      child: Text(isContratista ? 'Editar Oferta' : 'Aplicar a esta oferta'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green[600],
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Información principal en grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              childAspectRatio: 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildInfoItem('Fecha de carga', tripOffer.date, Icons.calendar_today),
                _buildInfoItem('Distancia', '${tripOffer.distance} km', Icons.route),
                _buildInfoItem('Tipo de carga', tripOffer.cargo, Icons.inventory),
                _buildInfoItem('Peso', tripOffer.weight, Icons.scale),
                _buildInfoItem('Cliente', tripOffer.client, Icons.business),
                _buildInfoItem(
                  'Urgencia', 
                  _getUrgencyText(tripOffer.urgency), 
                  Icons.priority_high,
                  _getUrgencyColor(tripOffer.urgency),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon, [Color? valueColor]) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: valueColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getUrgencyText(UrgencyLevel urgency) {
    switch (urgency) {
      case UrgencyLevel.alta:
        return 'Alta';
      case UrgencyLevel.baja:
        return 'Baja';
      default:
        return 'Normal';
    }
  }

  Color _getUrgencyColor(UrgencyLevel urgency) {
    switch (urgency) {
      case UrgencyLevel.alta:
        return Colors.red;
      case UrgencyLevel.baja:
        return Colors.green;
      default:
        return Colors.orange;
    }
  }

  Widget _getPaymentMethodIcon(String method) {
    IconData iconData;
    
    switch (method) {
      case 'Transferencia bancaria':
        iconData = Icons.account_balance;
        break;
      case 'Nequi':
      case 'Daviplata':
        iconData = Icons.smartphone;
        break;
      case 'PSE':
        iconData = Icons.credit_card;
        break;
      case 'Efectivo':
        iconData = Icons.money;
        break;
      default:
        iconData = Icons.payment;
    }
    
    return Icon(iconData, size: 16);
  }

  void _applyForTrip(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final tripProvider = Provider.of<TripProvider>(context, listen: false);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Aplicar a esta oferta'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('¿Estás seguro que deseas aplicar a esta oferta de viaje?'),
            SizedBox(height: 16),
            Text(
              'Método de pago preferido por el contratista:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                _getPaymentMethodIcon(tripOffer.preferredPaymentMethod ?? tripOffer.paymentMethods.first),
                SizedBox(width: 8),
                Text(tripOffer.preferredPaymentMethod ?? tripOffer.paymentMethods.first),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              // Aquí iría la lógica para aplicar a la oferta
              tripProvider.applyForTrip(tripOffer.id, authProvider.currentUser!.id);
              Navigator.pop(context); // Cerrar el diálogo
              Navigator.pop(context); // Volver a la pantalla anterior
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Has aplicado a esta oferta con éxito'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: Text('Confirmar'),
            style: ElevatedButton.styleFrom(
              primary: Colors.green[600],
            ),
          ),
        ],
      ),
    );
  }
}
