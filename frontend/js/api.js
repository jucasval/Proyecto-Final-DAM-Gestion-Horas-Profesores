// js/api.js

const API_BASE = window.location.hostname === 'localhost'
  ? '/Proyecto DAM/proyecto/api'
  : '/api';

// ========== ESCAPADO HTML (prevención de XSS) ==========
// Usar SIEMPRE al interpolar datos de la API dentro de innerHTML / cadenas HTML.
function esc(v) {
  return String(v ?? '').replace(/[&<>"']/g, c => ({
    '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;'
  }[c]));
}

// Parsear errores de la API sin reventar si la respuesta no es JSON
async function parseApiError(res) {
  try { return await res.json(); }
  catch { return { error: `Error ${res.status} del servidor` }; }
}

const api = {
  async get(recurso, id = null) {
    const url = id ? `${API_BASE}/${recurso}/${id}` : `${API_BASE}/${recurso}`;
    // Agregar timestamp para evitar caché
    const separator = url.includes('?') ? '&' : '?';
    const urlConBusting = `${url}${separator}t=${Date.now()}`;
    const res = await fetch(urlConBusting);
    if (!res.ok) throw await parseApiError(res);
    return res.json();
  },
  async post(recurso, data) {
    const res = await fetch(`${API_BASE}/${recurso}`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(data),
    });
    if (!res.ok) throw await parseApiError(res);
    return res.json();
  },
  async put(recurso, id, data) {
    const res = await fetch(`${API_BASE}/${recurso}/${id}`, {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(data),
    });
    if (!res.ok) throw await parseApiError(res);
    return res.json();
  },
  async delete(recurso, id) {
    // Asegurar que id es número
    id = parseInt(id);
    if (isNaN(id)) {
      throw new Error('ID inválido para DELETE');
    }
    const url = `${API_BASE}/${recurso}/${id}`;
    const res = await fetch(url, {
      method: 'DELETE',
    });
    if (!res.ok) throw await parseApiError(res);
    return res.json();
  },
};

function showAlert(msg, tipo = 'success', contenedor = 'alert-box') {
  const el = document.getElementById(contenedor);
  if (!el) return;
  el.textContent = msg;
  el.className = `alert alert-${tipo} show`;
  setTimeout(() => el.classList.remove('show'), 3500);
}

// ========== FUNCIÓN GLOBAL PARA MOSTRAR ERRORES EN MODALES ==========
function mostrarErrorModal(mensaje, modalId = 'modal') {
  let alertEl = document.getElementById('modal-alert');
  if (!alertEl) {
    alertEl = document.createElement('div');
    alertEl.id = 'modal-alert';
    alertEl.style.cssText = 'padding:12px 14px;border-radius:6px;font-size:13px;margin-bottom:14px;background:#fef2f2;border:1px solid #fecaca;color:#b91c1c;display:none';
    const modal = document.getElementById(modalId);
    const modalBody = modal ? modal.querySelector('.modal-body') : null;
    if (modalBody) modalBody.insertBefore(alertEl, modalBody.firstChild);
  }
  alertEl.textContent = mensaje;
  alertEl.style.display = 'block';
}

function limpiarErroresModal() {
  const alertEl = document.getElementById('modal-alert');
  if (alertEl) alertEl.style.display = 'none';
}

function openModal(id = 'modal') {
  limpiarErroresModal();
  document.getElementById(id)?.classList.add('open');
}

function closeModal(id = 'modal') {
  document.getElementById(id)?.classList.remove('open');
}

document.addEventListener('click', e => {
  if (e.target.classList.contains('modal-overlay')) {
    e.target.classList.remove('open');
  }
});

document.addEventListener('keydown', e => {
  if (e.key === 'Escape') {
    document.querySelectorAll('.modal-overlay.open')
      .forEach(m => m.classList.remove('open'));
  }
});

function badgePuesto(puesto) {
  return puesto === 'PES'
    ? '<span class="badge badge-pes">PES</span>'
    : '<span class="badge badge-ptfp">PTFP</span>';
}

function horasBar(asignadas, total) {
  const a   = parseFloat(asignadas) || 0;
  const t   = parseFloat(total)     || 18;
  const pct = Math.min((a / t) * 100, 100);
  const color = a < t  ? '#ef4444'
              : a == t ? '#22c55e'
              :           '#3b82f6';
  return `
    <div class="horas-bar">
      <div class="bar-track">
        <div class="bar-fill" style="width:${pct}%;background:${color}"></div>
      </div>
      <span>${a}/${t}</span>
    </div>`;
}

function confirmar(msg) {
  return window.confirm(msg);
}
