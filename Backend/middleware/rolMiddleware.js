function soloRol(rol) {
  return (req, res, next) => {
    console.log(`Verificando rol: requerido=${rol}, actual=${req.usuario.tipoUsuario}`);
    
    // Si se pasa un array de roles, verificar si el usuario tiene alguno de ellos
    if (Array.isArray(rol)) {
      if (!rol.includes(req.usuario.tipoUsuario)) {
        console.log(`Acceso denegado: El usuario con rol ${req.usuario.tipoUsuario} no tiene uno de los roles permitidos: ${rol.join(', ')}`);
        return res.status(403).json({ 
          mensaje: 'Acceso denegado: Rol insuficiente',
          rolesPermitidos: rol,
          rolActual: req.usuario.tipoUsuario
        });
      }
    } else {
      // Si se pasa un solo rol, verificar si el usuario lo tiene
      if (req.usuario.tipoUsuario !== rol) {
        console.log(`Acceso denegado: El usuario con rol ${req.usuario.tipoUsuario} no tiene el rol requerido: ${rol}`);
        return res.status(403).json({ 
          mensaje: 'Acceso denegado: Rol insuficiente',
          rolRequerido: rol,
          rolActual: req.usuario.tipoUsuario
        });
      }
    }
    
    console.log(`Usuario con rol ${req.usuario.tipoUsuario} autorizado`);
    next();
  };
}

module.exports = soloRol;
