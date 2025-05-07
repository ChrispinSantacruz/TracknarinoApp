import 'package:flutter/material.dart';
import 'package:trackarino/models/trip_offer_model.dart';

class AlertCard extends StatelessWidget {
  final RoadAlert alert;
  final VoidCallback onTap;
  final bool showActions;
  final VoidCallback? onDelete;
  final VoidCallback? onToggleActive;

  const AlertCard({
    Key? key,
    required this.alert,
    required this.onTap,
    this.showActions = false,
    this.onDelete,
    this.onToggleActive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAlertIcon(),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          alert.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          alert.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  if (!alert.isActive)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Inactiva',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                  SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      alert.location,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                  SizedBox(width: 4),
                  Text(
                    _getTimeAgo(alert.timestamp),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              if (showActions) ...[
                SizedBox(height: 8),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: onToggleActive,
                      icon: Icon(
                        alert.isActive ? Icons.visibility_off : Icons.visibility,
                        size: 16,
                      ),
                      label: Text(
                        alert.isActive ? 'Desactivar' : 'Activar',
                        style: TextStyle(fontSize: 12),
                      ),
                      style: TextButton.styleFrom(
                        primary: Colors.grey[700],
                        padding: EdgeInsets.symmetric(horizontal: 8),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: onDelete,
                      icon: Icon(Icons.delete, size: 16),
                      label: Text(
                        'Eliminar',
                        style: TextStyle(fontSize: 12),
                      ),
                      style: TextButton.styleFrom(
                        primary: Colors.red[700],
                        padding: EdgeInsets.symmetric(horizontal: 8),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAlertIcon() {
    Color backgroundColor;
    IconData iconData;
    
    switch (alert.type) {
      case RoadAlertType.blockage:
        backgroundColor = Colors.red[100]!;
        iconData = Icons.block;
        break;
      case RoadAlertType.accident:
        backgroundColor = Colors.orange[100]!;
        iconData = Icons.car_crash;
        break;
      case RoadAlertType.construction:
        backgroundColor = Colors.yellow[100]!;
        iconData = Icons.construction;
        break;
      case RoadAlertType.weather:
        backgroundColor = Colors.blue[100]!;
        iconData = Icons.cloud;
        break;
      default:
        backgroundColor = Colors.grey[100]!;
        iconData = Icons.warning;
    }
    
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        iconData,
        color: Colors.grey[800],
        size: 24,
      ),
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    
    if (difference.inDays > 0) {
      return 'Hace ${difference.inDays} ${difference.inDays == 1 ? 'día' : 'días'}';
    } else if (difference.inHours > 0) {
      return 'Hace ${difference.inHours} ${difference.inHours == 1 ? 'hora' : 'horas'}';
    } else if (difference.inMinutes > 0) {
      return 'Hace ${difference.inMinutes} ${difference.inMinutes == 1 ? 'minuto' : 'minutos'}';
    } else {
      return 'Hace un momento';
    }
  }
}
