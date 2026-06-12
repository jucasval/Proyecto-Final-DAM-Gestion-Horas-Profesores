// sync.js - Sistema de sincronización con Polling
// Uso: initSync('asignaciones', cargarDatos, 15000)

let syncIntervals = {};
let syncCallbacks = {};

// Pausar el polling cuando la pestaña no está visible y reanudarlo
// (con sincronización inmediata) al volver. Ahorra hits del hosting.
document.addEventListener('visibilitychange', () => {
  if (document.hidden) {
    Object.keys(syncIntervals).forEach(recurso => {
      clearInterval(syncIntervals[recurso].timer);
      syncIntervals[recurso].timer = null;
    });
  } else {
    Object.keys(syncIntervals).forEach(recurso => {
      const s = syncIntervals[recurso];
      if (!s.timer) {
        sincronizar(recurso, syncCallbacks[recurso]);
        s.timer = setInterval(() => sincronizar(recurso, syncCallbacks[recurso]), s.intervalo);
      }
    });
  }
});

/**
 * Inicializar sincronización automática de datos
 * @param {string} recurso - Nombre del recurso (asignaciones, profesores, etc)
 * @param {function} callbackActualizar - Función que se ejecuta cuando hay cambios
 * @param {number} intervalo - Milisegundos entre sincronizaciones (default: 15000)
 */
function initSync(recurso, callbackActualizar, intervalo = 15000) {
  // Limpiar intervalo anterior si existe
  if (syncIntervals[recurso] && syncIntervals[recurso].timer) {
    clearInterval(syncIntervals[recurso].timer);
  }

  syncCallbacks[recurso] = callbackActualizar;

  // Primera sincronización inmediata
  sincronizar(recurso, callbackActualizar);

  // Luego cada X segundos
  syncIntervals[recurso] = {
    intervalo: intervalo,
    timer: setInterval(() => sincronizar(recurso, callbackActualizar), intervalo),
  };

  console.log(`✅ Sincronización de ${recurso} iniciada (cada ${intervalo}ms)`);
}

/**
 * Función interna que realiza la sincronización
 */
async function sincronizar(recurso, callback) {
  try {
    const datos = await api.get(recurso);
    
    // Comparar con datos anteriores
    const elementoDatos = document.getElementById(`_sync_${recurso}`);
    const datosAnteriores = elementoDatos ? JSON.parse(elementoDatos.textContent) : null;
    
    // Si hay cambios, actualizar y notificar
    if (!datosAnteriores || JSON.stringify(datos) !== JSON.stringify(datosAnteriores)) {
      // Guardar nuevos datos
      if (!elementoDatos) {
        const div = document.createElement('div');
        div.id = `_sync_${recurso}`;
        div.style.display = 'none';
        document.body.appendChild(div);
      }
      document.getElementById(`_sync_${recurso}`).textContent = JSON.stringify(datos);
      
      // Ejecutar callback para actualizar UI
      if (callback && typeof callback === 'function') {
        callback(datos);
      }
      
      // Notificación (opcional)
      mostrarNotificacionSync(recurso);
    }
  } catch (err) {
    console.error(`❌ Error sincronizando ${recurso}:`, err);
  }
}

/**
 * Mostrar notificación visual de sincronización
 */
function mostrarNotificacionSync(recurso) {
  // Opcional: agregar badge o animación
  const badge = document.getElementById('sync-badge');
  if (badge) {
    badge.style.display = 'inline-block';
    badge.textContent = '🔄 Actualizado';
    setTimeout(() => {
      badge.style.display = 'none';
    }, 2000);
  }
}

/**
 * Detener sincronización de un recurso
 */
function stopSync(recurso) {
  if (syncIntervals[recurso]) {
    if (syncIntervals[recurso].timer) clearInterval(syncIntervals[recurso].timer);
    delete syncIntervals[recurso];
    delete syncCallbacks[recurso];
    console.log(`⏹️ Sincronización de ${recurso} detenida`);
  }
}

/**
 * Detener todas las sincronizaciones
 */
function stopAllSync() {
  Object.keys(syncIntervals).forEach(recurso => stopSync(recurso));
}
