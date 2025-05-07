import 'package:flutter/material.dart';
import 'package:trackarino/models/user_model.dart';

class ProfileDialog extends StatelessWidget {
  final User user;

  const ProfileDialog({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isContratista = user.userType == UserType.contratista;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: EdgeInsets.all(16),
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Encabezado
            Text(
              'Bienvenido, ${user.name}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              isContratista 
                ? 'Información de tu empresa contratista' 
                : 'Información de tu perfil de transportista',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 16),
            
            // Avatar y nombre
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  isContratista ? Icons.business : Icons.person,
                  size: 40,
                  color: Colors.grey[500],
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
              user.name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              isContratista 
                ? 'Empresa contratista desde ${user.since}' 
                : 'Transportista desde ${user.since}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 16),
            
            // Estadísticas
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItem(
                  'Calificación',
                  '${user.rating}/5.0',
                ),
                _buildStatItem(
                  isContratista ? 'Viajes Publicados' : 'Viajes',
                  isContratista ? '${user.tripsPublished}' : '${user.trips}',
                ),
              ],
            ),
            SizedBox(height: 24),
            
            // Botón de cerrar
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cerrar'),
              style: ElevatedButton.styleFrom(
                primary: Colors.green[600],
                minimumSize: Size(double.infinity, 40),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Container(
      width: 120,
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
