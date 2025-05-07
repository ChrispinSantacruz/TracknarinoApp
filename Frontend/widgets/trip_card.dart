import 'package:flutter/material.dart';
import 'package:trackarino/models/trip_offer_model.dart';

class TripCard extends StatelessWidget {
  final TripOffer tripOffer;
  final bool isContratista;
  final VoidCallback onTap;

  const TripCard({
    Key? key,
    required this.tripOffer,
    required this.isContratista,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: Colors.green[500]!,
                width: 4,
              ),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Información principal
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Origen - Destino
                          Row(
                            children: [
                              Icon(Icons.location_on, size: 16, color: Colors.green[500]),
                              SizedBox(width: 4),
                              Text(
                                '${tripOffer.origin} → ${tripOffer.destination}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
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
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 8),
                          
                          // Fecha y peso
                          Row(
                            children: [
                              Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                              SizedBox(width: 4),
                              Text(
                                tripOffer.date,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(width: 16),
                              Icon(Icons.local_shipping, size: 14, color: Colors.grey[600]),
                              SizedBox(width: 4),
                              Text(
                                tripOffer.weight,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          
                          // Tipo de carga
                          Row(
                            children: [
                              Text(
                                'Carga:',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(width: 4),
                              Text(
                                tripOffer.cargo,
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          
                          // Métodos de pago
                          Wrap(
                            spacing: 4,
                            runSpacing: 4,
                            children: tripOffer.paymentMethods.map((method) {
                              IconData getIcon() {
                                switch (method) {
                                  case 'Transferencia bancaria':
                                    return Icons.account_balance;
                                  case 'Nequi':
                                  case 'Daviplata':
                                    return Icons.smartphone;
                                  case 'PSE':
                                    return Icons.credit_card;
                                  case 'Efectivo':
                                    return Icons.money;
                                  default:
                                    return Icons.payment;
                                }
                              }
                              
                              return Container(
                                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(getIcon(), size: 12, color: Colors.grey[700]),
                                    SizedBox(width: 4),
                                    Text(
                                      method,
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    
                    // Precio y botón
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.attach_money, size: 20, color: Colors.green[500]),
                            Text(
                              '${tripOffer.price.toStringAsFixed(0)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${tripOffer.distance} km',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: onTap,
                          child: Text(isContratista ? 'Editar' : 'Ver Detalles'),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green[600],
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            textStyle: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
