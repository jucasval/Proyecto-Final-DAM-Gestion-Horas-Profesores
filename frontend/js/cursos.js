// js/cursos.js

let todosCursos = [];
let profesoresAnterior = [];

async function cargarCursos() {
  try {
    todosCursos = await api.get('cursos');
    renderTabla(todosCursos);

    // Mostrar curso activo en el sidebar
    const activo = todosCursos.find(c => c.activo == 1);
    if (activo) {
      const label = document.getElementById('curso-activo-label');
      if (label) label.textContent = activo.nombre;
    }
  } catch (err) {
    document.getElementById('tbody-cursos').innerHTML =
      '<tr><td colspan="5" class="table-loading">Error al cargar datos</td></tr>';
  }
}

function renderTabla(lista) {
  const tbody = document.getElementById('tbody-cursos');
  if (!lista.length) {
    tbody.innerHTML = '<tr><td colspan="5" class="table-loading">Sin cursos registrados</td></tr>';
    return;
  }
  tbody.innerHTML = lista.map(c => `
    <tr>
      <td><strong style="font-family:var(--font-mono)">${esc(c.nombre)}</strong></td>
      <td>${esc(c.fecha_inicio)}</td>
      <td>${esc(c.fecha_fin)}</td>
      <td>${c.activo == 1
        ? '<span class="badge" style="background:#f0fdf4;color:#166534;border:1px solid #bbf7d0">● Activo</span>'
        : '<span style="color:var(--text-muted);font-size:12px">Histórico</span>'}</td>
      <td>
        ${c.activo != 1
          ? `<button class="btn btn-secondary btn-sm" onclick="activarCurso(${c.id})">Activar</button>`
          : '<span style="color:var(--text-muted);font-size:12px">—</span>'}
        <button class="btn btn-danger btn-sm" onclick="eliminarCurso(${c.id})" ${c.activo == 1 ? 'disabled title="No se puede eliminar el curso activo"' : ''}>Eliminar</button>
      </td>
    </tr>`).join('');
}

async function abrirModalNuevo() {
  document.getElementById('modal-titulo').textContent = 'Nuevo curso escolar';
  document.getElementById('curso-id').value    = '';
  document.getElementById('curso-nombre').value = '';
  document.getElementById('curso-inicio').value = '';
  document.getElementById('curso-fin').value    = '';
  limpiarErrores();

  // Cargar profesores del curso activo para que el usuario elija cuáles continúan
  try {
    const cursoActivo = todosCursos.find(c => c.activo == 1);
    if (cursoActivo) {
      profesoresAnterior = await api.get('cursos/' + cursoActivo.id + '/profesores');
      renderSelectorProfesores(profesoresAnterior);
      document.getElementById('seccion-profesores').style.display = 'block';
    } else {
      document.getElementById('seccion-profesores').style.display = 'none';
    }
  } catch (err) {
    document.getElementById('seccion-profesores').style.display = 'none';
  }

  openModal();
}

function renderSelectorProfesores(lista) {
  const container = document.getElementById('check-profesores');
  container.innerHTML = lista
    .sort((a, b) => a.apellidos.localeCompare(b.apellidos))
    .map(p => `
      <label style="display:flex;align-items:center;gap:10px;padding:7px 8px;cursor:pointer;border-radius:4px;transition:background 0.1s"
             onmouseover="this.style.background='#f8fafc'" onmouseout="this.style.background=''">
        <input type="checkbox" class="check-profesor" value="${p.id}" checked
               style="flex-shrink:0;width:15px;height:15px;cursor:pointer;accent-color:#3b82f6">
        <span style="font-size:13px;color:#0f172a">${esc(p.apellidos)}, ${esc(p.nombre)}</span>
        <span style="font-size:11px;color:var(--text-secondary);margin-left:auto">${p.puesto}</span>
      </label>`).join('');
}

function getProfesoresSeleccionados() {
  return Array.from(document.querySelectorAll('.check-profesor:checked'))
    .map(cb => parseInt(cb.value));
}

// ========== MOSTRAR ERRORES EN EL MODAL ==========
function mostrarErrorModal(mensaje) {
  let alertEl = document.getElementById('modal-alert');
  if (!alertEl) {
    alertEl = document.createElement('div');
    alertEl.id = 'modal-alert';
    alertEl.style.cssText = 'padding:12px 14px;border-radius:6px;font-size:13px;margin-bottom:14px;background:#fef2f2;border:1px solid #fecaca;color:#b91c1c;display:none';
    const modalBody = document.querySelector('#modal .modal-body');
    if (modalBody) modalBody.insertBefore(alertEl, modalBody.firstChild);
  }
  alertEl.textContent = mensaje;
  alertEl.style.display = 'block';
}

function limpiarErrores() {
  const alertEl = document.getElementById('modal-alert');
  if (alertEl) alertEl.style.display = 'none';
}

async function guardarCurso() {
  limpiarErrores();
  
  const id = document.getElementById('curso-id').value;
  const data = {
    nombre:       document.getElementById('curso-nombre').value.trim(),
    fecha_inicio: document.getElementById('curso-inicio').value,
    fecha_fin:    document.getElementById('curso-fin').value,
  };

  if (!data.nombre || !data.fecha_inicio || !data.fecha_fin) {
    mostrarErrorModal('Todos los campos son obligatorios.');
    return;
  }

  // ========== VALIDAR FECHAS EN FRONTEND ==========
  const fInicio = new Date(data.fecha_inicio);
  const fFin = new Date(data.fecha_fin);
  if (fFin < fInicio) {
    mostrarErrorModal('La fecha final no puede ser anterior a la fecha inicial.');
    return;
  }

  // Al crear, incluir los profesores seleccionados
  if (!id) {
    data.profesores_ids = getProfesoresSeleccionados();
  }

  try {
    if (id) {
      await api.put('cursos', id, data);
      showAlert('Curso actualizado correctamente.');
    } else {
      const res = await api.post('cursos', data);
      showAlert('Curso creado. ' + res.profesores_copiados + ' profesores copiados al nuevo curso.');
    }
    closeModal();
    cargarCursos();
  } catch (err) {
    // Capturar error del servidor
    let mensajeError = 'Error al guardar el curso.';
    if (err && err.error) {
      mensajeError = err.error;
    } else if (err && typeof err === 'string') {
      mensajeError = err;
    }
    mostrarErrorModal(mensajeError);
  }
}

async function activarCurso(id) {
  if (!confirmar('¿Activar este curso? El curso actual pasará a ser histórico.')) return;
  try {
    await fetch(API_BASE + '/cursos/' + id + '/activar', { method: 'PUT' });
    showAlert('Curso activado correctamente.');
    cargarCursos();
  } catch (err) {
    showAlert('Error al activar el curso.', 'error');
  }
}

async function eliminarCurso(id) {
  if (!confirmar('¿Eliminar este curso? Se eliminarán también sus profesores.')) return;
  try {
    await api.delete('cursos', id);
    showAlert('Curso eliminado.');
    cargarCursos();
  } catch (err) {
    showAlert(err.error || 'Error al eliminar.', 'error');
  }
}

cargarCursos();

// Sincronización automática
initSync('cursos', async (datosNuevos) => {
  console.log('📚 Cursos actualizados desde otro dispositivo');
  todosCursos = datosNuevos;
  renderTabla(todosCursos);
}, 15000);

window.addEventListener('beforeunload', () => stopSync('cursos'));
