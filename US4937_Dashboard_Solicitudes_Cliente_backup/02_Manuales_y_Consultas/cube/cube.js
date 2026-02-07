// Configuración dinámica para forzar el uso de mysql2 (soporta SHA2 de MySQL 8)
// No requiere cambios en el servidor MySQL de Comsatel

module.exports = {
  dbType: 'mysql',
  driverFactory: () => {
    const MySqlDriver = require('@cubejs-backend/mysql-driver');
    return new MySqlDriver({
      host: process.env.CUBEJS_DB_HOST || '192.168.1.180',
      user: process.env.CUBEJS_DB_USER || 'microservicio',
      password: process.env.CUBEJS_DB_PASS || 'secr3t!',
      database: process.env.CUBEJS_DB_NAME || 'solicitudesservicio',
      port: 3306,
      // Esta es la clave para soportar MySQL 8 sin root
      authProtocol: 'caching_sha2_password' 
    });
  }
};

console.log("-----------------------------------------");
console.log("CUBE.JS: FORCED MYSQL2 DRIVER LOADED");
console.log("-----------------------------------------");
