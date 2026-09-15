// RED AYUDA — Frontend Logic (Leaflet Map + Live Tracking)

let shareMap = null;
let shareMarker = null;
let shareAccuracyCircle = null;

let adminMap = null;
let adminMarkers = [];

const ayacuchoCenter = [-13.1631, -74.2236]; // Plaza Mayor de Huamanga

const app = {
  currentView: 'share',

  init() {
    this.initShareMap();
    this.checkUrlForToken();
    this.startPeriodicTracking();
  },

  showShareView() {
    this.currentView = 'share';
    document.getElementById('share-view').classList.add('active');
    document.getElementById('admin-view').classList.remove('active');
    document.getElementById('nav-share-btn').classList.add('active');
    document.getElementById('nav-admin-btn').classList.remove('active');

    setTimeout(() => {
      if (shareMap) shareMap.invalidateSize();
    }, 200);
  },

  showAdminView() {
    this.currentView = 'admin';
    document.getElementById('admin-view').classList.add('active');
    document.getElementById('share-view').classList.remove('active');
    document.getElementById('nav-admin-btn').classList.add('active');
    document.getElementById('nav-share-btn').classList.remove('active');

    if (!adminMap) {
      this.initAdminMap();
    } else {
      setTimeout(() => adminMap.invalidateSize(), 200);
    }
  },

  initShareMap() {
    if (typeof L === 'undefined') return;

    shareMap = L.map('share-map').setView(ayacuchoCenter, 16);

    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      attribution: '&copy; OpenStreetMap contributors | RED AYUDA',
      maxZoom: 19
    }).addTo(shareMap);

    const sosIcon = L.divIcon({
      className: 'custom-sos-marker',
      html: '<div style="background-color:#ef4444; width:22px; height:22px; border-radius:50%; border:3px solid white; box-shadow:0 0 15px #ef4444;"></div>',
      iconSize: [22, 22],
      iconAnchor: [11, 11]
    });

    shareMarker = L.marker(ayacuchoCenter, { icon: sosIcon }).addTo(shareMap);
    shareMarker.bindPopup('<b>Carlos Mendoza Quispe</b><br>Alerta SOS Activa<br>Ayacucho Centro').openPopup();

    shareAccuracyCircle = L.circle(ayacuchoCenter, {
      radius: 15,
      color: '#ef4444',
      fillColor: '#ef4444',
      fillOpacity: 0.15
    }).addTo(shareMap);
  },

  initAdminMap() {
    if (typeof L === 'undefined') return;

    adminMap = L.map('admin-map').setView(ayacuchoCenter, 15);

    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      attribution: '&copy; OpenStreetMap | Centro de Control RED AYUDA',
      maxZoom: 19
    }).addTo(adminMap);

    // Marker 1: Carlos Mendoza (Robo)
    const m1 = L.marker(ayacuchoCenter).addTo(adminMap)
      .bindPopup('<b>Incidente #1: ROBO</b><br>Ciudadano: Carlos Mendoza<br>Estado: ACTIVA');
    adminMarkers.push(m1);

    // Marker 2: Lucía Morales (Accidente)
    const pos2 = [-13.1670, -74.2210];
    const m2 = L.marker(pos2).addTo(adminMap)
      .bindPopup('<b>Incidente #2: ACCIDENTE</b><br>Ciudadano: Lucía Morales<br>Estado: EN_ATENCIÓN');
    adminMarkers.push(m2);
  },

  checkUrlForToken() {
    const path = window.location.pathname;
    if (path.includes('/emergency/share/')) {
      const token = path.split('/emergency/share/')[1];
      this.fetchSharedEmergencyData(token);
    }
  },

  async fetchSharedEmergencyData(token) {
    try {
      const res = await fetch(`/api/v1/public/share/${token}`);
      if (res.ok) {
        const data = await res.json();
        document.getElementById('victim-name').textContent = data.nombreVictima || 'Ciudadano en Emergencia';
        document.getElementById('emergency-meta').textContent = `Tipo: ${data.tipo} • Estado: ${data.estado}`;
        if (data.latitud && data.longitud && shareMap && shareMarker) {
          const newPos = [data.latitud, data.longitud];
          shareMarker.setLatLng(newPos);
          if (shareAccuracyCircle) shareAccuracyCircle.setLatLng(newPos);
          shareMap.panTo(newPos);
        }
      }
    } catch (e) {
      console.log('Modo demostración activo');
    }
  },

  startPeriodicTracking() {
    // Simula telemetría periódica cada 6 segundos en tiempo real
    setInterval(() => {
      const date = new Date();
      const timeStr = date.toLocaleTimeString();
      const updatedEl = document.getElementById('last-updated-text');
      if (updatedEl) {
        updatedEl.textContent = `Última actualización satelital: ${timeStr}`;
      }
    }, 6000);
  },

  refreshAdminData() {
    alert('Métricas de Centro de Control actualizadas.');
  }
};

window.app = app;

document.addEventListener('DOMContentLoaded', () => {
  app.init();
});
