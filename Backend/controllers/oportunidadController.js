const Oportunidad = require('../models/Oportunidad');
const User = require('../models/User');
const { enviarNotificacionFCM } = require('../services/fcmService');

// Crear oportunidad (contratista o camionero)
const crearOportunidad = async (req, res) => {
  try {
    console.log('Datos para crear oportunidad:', req.body);
    console.log('Usuario que intenta crear la oportunidad:', req.usuario);

    // Si algunos campos no están presentes, establecer valores predeterminados
    const datosOportunidad = {
      ...req.body,
      contratista: req.usuario.id,
      estado: 'disponible',
      finalizada: false
    };

    console.log('Datos procesados para la oportunidad:', datosOportunidad);
    
    const oportunidad = new Oportunidad(datosOportunidad);
    await oportunidad.save();
    
    console.log('Oportunidad creada con éxito:', oportunidad);
    
    // Opcionalmente, enviar notificaciones a camioneros disponibles
    try {
      // Buscar camioneros disponibles (solo si quien crea es contratista)
      if (req.usuario.tipoUsuario === 'contratista') {
        const camioneros = await User.find({ 
          tipoUsuario: 'camionero', 
          deviceToken: { $exists: true, $ne: '' },
          disponible: true 
        });

        console.log(`Enviando notificaciones a ${camioneros.length} camioneros disponibles`);
        
        // Enviar notificación a cada camionero
        for (const camionero of camioneros) {
          if (camionero.deviceToken) {
            await enviarNotificacionFCM(
              camionero.deviceToken, 
              'Nueva oportunidad disponible', 
              `${req.usuario.nombre} ha publicado una nueva carga de ${oportunidad.origen} a ${oportunidad.destino}`
            );
          }
        }
      }
    } catch (notifError) {
      console.error('Error al enviar notificaciones:', notifError);
      // Continuamos aunque falle el envío de notificaciones
    }
    
    res.status(201).json({ 
      mensaje: 'Oportunidad creada', 
      oportunidad 
    });
  } catch (error) {
    console.error('Error al crear oportunidad:', error);
    res.status(500).json({ 
      mensaje: 'Error al crear oportunidad', 
      error: error.message,
      detalles: error.toString() 
    });
  }
};

// Listar oportunidades disponibles (pueden verlas todos los autenticados)
const listarOportunidades = async (req, res) => {
  try {
    const oportunidades = await Oportunidad.find({ estado: 'disponible' })
      .populate('contratista', 'nombre correo');
    res.json(oportunidades);
  } catch (error) {
    res.status(500).json({ error: 'Error al listar oportunidades' });
  }
};

// Asignar camionero a oportunidad (cualquier camionero puede aceptar)
const asignarCamionero = async (req, res) => {
  try {
    const { id } = req.params;
    const camioneroId = req.usuario.id; // Obtener el ID del camionero desde el token de autenticación

    const oportunidad = await Oportunidad.findById(id);

    if (!oportunidad || oportunidad.estado !== 'disponible') {
      return res.status(400).json({ error: 'Oportunidad no disponible para asignación' });
    }

    oportunidad.camioneroAsignado = camioneroId;
    oportunidad.estado = 'asignada';
    await oportunidad.save();

    // Enviar notificación al camionero si tiene token FCM
    const camionero = await User.findById(camioneroId);
    if (camionero?.deviceToken) {
      await enviarNotificacionFCM(
        camionero.deviceToken,
        '📦 Nueva carga aceptada',
        `Has aceptado una carga de ${oportunidad.origen} a ${oportunidad.destino}.`
      );
    }

    res.json({ mensaje: 'Carga aceptada', oportunidad });
  } catch (error) {
    res.status(500).json({ error: 'Error al aceptar la carga' });
  }
};

// Finalizar carga (solo contratista)
const finalizarCarga = async (req, res) => {
  try {
    const carga = await Oportunidad.findById(req.params.id);

    if (!carga || carga.contratista.toString() !== req.usuario.id) {
      return res.status(403).json({ error: 'No tienes permisos para finalizar esta carga' });
    }

    carga.estado = 'finalizada';
    carga.finalizada = true;
    await carga.save();

    // Notificación al camionero
    const camionero = await User.findById(carga.camioneroAsignado);
    if (camionero?.deviceToken) {
      await enviarNotificacionFCM(
        camionero.deviceToken,
        '✔️ Carga finalizada',
        `La carga de ${carga.origen} a ${carga.destino} ha sido finalizada.`
      );
    }

    res.json({ mensaje: 'Carga finalizada correctamente', carga });
  } catch (error) {
    res.status(500).json({ error: 'Error al finalizar la carga' });
  }
};

module.exports = {
  crearOportunidad,
  listarOportunidades,
  asignarCamionero,
  finalizarCarga
};
