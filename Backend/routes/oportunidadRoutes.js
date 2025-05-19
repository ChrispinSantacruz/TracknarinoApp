const express = require('express');
const router = express.Router();
const { crearOportunidad, listarOportunidades, asignarCamionero, finalizarCarga } = require('../controllers/oportunidadController');
const verificarToken = require('../middleware/authMiddleware');
const soloRol = require('../middleware/rolMiddleware');

// Crear oportunidad (contratistas)
router.post('/crear', verificarToken, soloRol(['contratista', 'camionero']), crearOportunidad);

// Listar oportunidades disponibles (pueden verlas todos los autenticados)
router.get('/disponibles', verificarToken, listarOportunidades);

// Asignar camionero a oportunidad (cualquier camionero puede aceptar)
router.post('/asignar/:id', verificarToken, soloRol('camionero'), asignarCamionero);

// Finalizar una carga (solo contratista)
router.post('/finalizar/:id', verificarToken, soloRol('contratista'), finalizarCarga);

module.exports = router;
