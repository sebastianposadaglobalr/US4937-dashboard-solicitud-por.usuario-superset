const { DateTime } = luxon;

// Chart is globally available from CDN

// fetchData function is no longer used as fetch calls are now inline in populateFilters and updateDashboard.

function renderKPIs(data) {
    if (!data) return;
    document.getElementById('kpi-received').textContent = (data.received || 0).toLocaleString();
    document.getElementById('kpi-scheduled').textContent = (data.scheduled || 0).toLocaleString();
    document.getElementById('kpi-completed').textContent = (data.completed || 0).toLocaleString();
    document.getElementById('kpi-pending').textContent = (data.pending || 0).toLocaleString();
    document.getElementById('kpi-adicionales').textContent = (data.adicionales || 0).toLocaleString();
}

function renderGantt(data) {
    const wrapper = document.querySelector('.chart-wrapper');
    
    if (!data || data.length === 0) {
        wrapper.innerHTML = '<div class="gantt-placeholder" style="display:flex;align-items:center;justify-content:center;height:100%;color:#95a5a6;font-style:italic;">Elegir filtros para ver datos...</div>';
        return;
    }

    wrapper.innerHTML = '';
    const ctx = document.createElement('canvas');
    wrapper.appendChild(ctx);

    // Process data with proper date handling
    const chartData = data.map((d, index) => {
        try {
            const startDt = DateTime.fromISO(d.start);
            const endDt = DateTime.fromISO(d.end);
            
            if (!startDt.isValid || !endDt.isValid) {
                console.warn(`Invalid dates for record ${index}:`, d);
                return null;
            }
            
            return {
                x: [startDt.toMillis(), endDt.toMillis()],
                y: d.vehicle || `Sin-ID-${index}`,
                event: d.event || 'Desconocido',
                asesor: d.asesor_name || 'No asignado',
                service: d.service_type || 'Sin especificar',
                cliente: d.cliente || 'Sin cliente',
                startDt: startDt,
                endDt: endDt
            };
        } catch (error) { 
            console.error(`Error processing record ${index}:`, error);
            return null; 
        }
    }).filter(d => d !== null);

    if (chartData.length === 0) {
        wrapper.innerHTML = '<div class="gantt-placeholder" style="display:flex;align-items:center;justify-content:center;height:100%;color:#e74c3c;">Error: No se pudieron procesar las fechas</div>';
        return;
    }

    // Calculate date range
    const allTimes = chartData.flatMap(d => d.x);
    const minTime = Math.min(...allTimes);
    const maxTime = Math.max(...allTimes);
    
    // Calculate time span to show ~10 dates initially
    const totalRange = maxTime - minTime;
    const daysInRange = totalRange / (24 * 3600000);
    
    // If more than 10 days, zoom to show only 10 days initially
    let initialMin, initialMax;
    if (daysInRange > 10) {
        const tenDaysMs = 10 * 24 * 3600000;
        initialMin = minTime;
        initialMax = minTime + tenDaysMs;
    } else {
        initialMin = minTime - (12 * 3600000);
        initialMax = maxTime + (12 * 3600000);
    }

    // Set wrapper width to accommodate wider bars
    // Each bar is 400px, so total width = number of records * 400px
    const calculatedWidth = Math.max(chartData.length * 450, 2000);
    wrapper.style.width = `${calculatedWidth}px`;

    const chart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: chartData.map(d => d.y),
            datasets: [{
                label: 'Servicios',
                data: chartData,
                backgroundColor: (context) => {
                    const e = context.raw?.event;
                    if (e === 'Pendiente') return 'rgba(241, 196, 15, 0.85)';
                    if (e === 'Programada') return 'rgba(52, 152, 219, 0.85)';
                    if (e === 'Atendida') return 'rgba(46, 204, 113, 0.85)';
                    if (e === 'Con Orden') return 'rgba(155, 89, 182, 0.85)';
                    return 'rgba(149, 165, 166, 0.85)';
                },
                borderColor: (context) => {
                    const e = context.raw?.event;
                    if (e === 'Pendiente') return '#f39c12';
                    if (e === 'Programada') return '#2980b9';
                    if (e === 'Atendida') return '#27ae60';
                    if (e === 'Con Orden') return '#8e44ad';
                    return '#7f8c8d';
                },
                borderWidth: 2,
                borderRadius: 6,
                borderSkipped: false,
                barThickness: 35, // Ajustado para mejor alineación
                maxBarThickness: 35,
                categoryPercentage: 0.9, // Mejor uso del espacio vertical
                barPercentage: 0.95 // Alineación precisa con etiquetas
            }]
        },
        options: {
            indexAxis: 'y',
            responsive: true,
            maintainAspectRatio: false,
            layout: {
                padding: { left: 15, right: 25, top: 15, bottom: 20 }
            },
            scales: {
                x: {
                    type: 'time',
                    min: initialMin,
                    max: initialMax,
                    time: {
                        unit: 'day',
                        displayFormats: {
                            day: 'dd MMM',
                            hour: 'HH:mm'
                        },
                        tooltipFormat: 'dd MMM yyyy HH:mm'
                    },
                    title: {
                        display: true,
                        text: '📅 Fecha de Cita | 🖱️ Rueda: Zoom | 👆 Arrastra: Desplazar | 🔄 Doble Click: Reset',
                        font: { size: 12, weight: 'bold' },
                        color: '#2c3e50',
                        padding: { top: 10, bottom: 5 }
                    },
                    grid: { 
                        color: 'rgba(52, 73, 94, 0.15)',
                        drawBorder: true,
                        borderColor: '#34495e',
                        borderWidth: 2,
                        lineWidth: 1.5
                    },
                    ticks: { 
                        font: { weight: 'bold', size: 12 },
                        color: '#2c3e50',
                        maxRotation: 0, // Horizontal para mejor legibilidad
                        minRotation: 0,
                        autoSkip: true,
                        maxTicksLimit: 10,
                        padding: 8,
                        align: 'center'
                    },
                    offset: false // Alineación precisa
                },
                y: {
                    type: 'category',
                    grid: { 
                        display: true,
                        color: 'rgba(0,0,0,0.05)',
                        drawBorder: true,
                        borderColor: '#34495e',
                        borderWidth: 2
                    },
                    ticks: { 
                        font: { weight: '600', size: 11 },
                        color: '#2c3e50',
                        padding: 5,
                        crossAlign: 'far',
                        align: 'end'
                    },
                    offset: true,
                    position: 'left'
                }
            },
            plugins: {
                legend: { display: false },
                tooltip: {
                    enabled: true,
                    backgroundColor: 'rgba(44, 62, 80, 0.95)',
                    titleColor: '#ecf0f1',
                    bodyColor: '#ecf0f1',
                    borderColor: '#3498db',
                    borderWidth: 2,
                    padding: 16,
                    titleFont: { size: 15, weight: 'bold' },
                    bodyFont: { size: 13 },
                    displayColors: true,
                    callbacks: {
                        title: (items) => {
                            const d = items[0].raw;
                            return `🚗 ${d.y}`;
                        },
                        label: (context) => {
                            const d = context.raw;
                            const fechaInicio = d.startDt.toFormat('dd/MM/yyyy');
                            const horaInicio = d.startDt.toFormat('HH:mm');
                            const horaFin = d.endDt.toFormat('HH:mm');
                            
                            return [
                                `📅 Fecha: ${fechaInicio}`,
                                `⏰ Horario: ${horaInicio} - ${horaFin}`,
                                `📊 Estado: ${d.event}`,
                                `🔧 Servicio: ${d.service}`,
                                `👤 Asesor: ${d.asesor}`,
                                `🏢 Cliente: ${d.cliente}`
                            ];
                        }
                    }
                },
                zoom: {
                    pan: {
                        enabled: true,
                        mode: 'x',
                        modifierKey: null,
                    },
                    zoom: {
                        wheel: {
                            enabled: true,
                            speed: 0.1,
                            modifierKey: null
                        },
                        pinch: {
                            enabled: true
                        },
                        mode: 'x',
                    },
                    limits: {
                        x: {
                            min: minTime - (24 * 3600000),
                            max: maxTime + (24 * 3600000)
                        }
                    }
                }
            }
        }
    });

    console.log('💡 Usa la rueda del mouse para hacer zoom. Arrastra para desplazar. Doble click para resetear.');
}

async function updateDashboard() {
    const client = document.getElementById('filter-client').value;
    const type = document.getElementById('filter-type').value;
    const asesor = document.getElementById('filter-asesor').value;
    const service = document.getElementById('filter-service').value;
    
    console.log(`Updating dashboard for: ${client} - ${type} - ${asesor} - ${service}`);
    
    try {
        const kpisRes = await fetch(`http://localhost:8000/api/kpis?client=${encodeURIComponent(client)}&order_type=${encodeURIComponent(type)}&asesor=${encodeURIComponent(asesor)}`);
        const kpis = await kpisRes.json();
        renderKPIs(kpis);
        
        const timelineRes = await fetch(`http://localhost:8000/api/timeline?client=${encodeURIComponent(client)}&asesor=${encodeURIComponent(asesor)}&service=${encodeURIComponent(service)}`);
        const timeline = await timelineRes.json();
        renderGantt(timeline);
        
        // Actualizar hora de última sincronización
        updateLastRefreshTime();
    } catch (err) {
        console.error('Update failed:', err);
    }
}

// Lógica de Auto-Refresh y Reloj Lima
let secondsRemaining = 300; // 5 minutos

function updateLastRefreshTime() {
    const now = DateTime.now().setZone('America/Lima').toFormat('HH:mm:ss');
    const refreshInfo = document.getElementById('refresh-info');
    if (refreshInfo) {
        refreshInfo.textContent = `Sincronizado: ${now}`;
    }
    secondsRemaining = 300; // Reset countdown
}

function updateCountdown() {
    const countdownEl = document.getElementById('countdown');
    if (countdownEl) {
        const minutes = Math.floor(secondsRemaining / 60);
        const seconds = secondsRemaining % 60;
        countdownEl.textContent = `Próxima en: ${minutes}:${seconds.toString().padStart(2, '0')}`;
    }
    secondsRemaining--;
    if (secondsRemaining < 0) {
        updateDashboard(); // Gatilla refresh automático
        secondsRemaining = 300;
    }
}

function updateLimaClock() {
    const clockEl = document.getElementById('lima-clock');
    if (clockEl) {
        // Muestra Fecha y Hora de Lima, Perú
        const now = DateTime.now().setZone('America/Lima');
        const dateStr = now.toFormat('dd/MM/yyyy');
        const timeStr = now.toFormat('HH:mm:ss');
        clockEl.textContent = `🇵🇪 Lima: ${dateStr} ${timeStr}`;
    }
}

function startAutoRefresh() {
    setInterval(updateCountdown, 1000); // Actualiza countdown cada segundo
    setInterval(updateLimaClock, 1000); // Reloj en tiempo real cada segundo
}

function manualRefresh() {
    console.log('🔄 Refresh manual solicitado');
    updateDashboard();
}

async function populateFilters() {
    console.log('Fetching filter data...');
    try {
        // Clients
        const clientsRes = await fetch('http://localhost:8000/api/clients');
        const clients = await clientsRes.json();
        console.log(`Received ${clients.length} clients`);
        const clientSelect = document.getElementById('filter-client');
        if (Array.isArray(clients)) {
            clients.forEach(c => {
                if (c && c.trim()) {
                    const opt = document.createElement('option');
                    opt.value = c.trim();
                    opt.textContent = c.trim();
                    clientSelect.appendChild(opt);
                }
            });
        }

        // Asesores
        const asesoresRes = await fetch('http://localhost:8000/api/asesores');
        const asesores = await asesoresRes.json();
        console.log(`Received ${asesores.length} asesores`);
        const asesorSelect = document.getElementById('filter-asesor');
        if (Array.isArray(asesores)) {
            asesores.forEach(a => {
                if (a && a.trim()) {
                    const opt = document.createElement('option');
                    opt.value = a.trim();
                    opt.textContent = a.trim();
                    asesorSelect.appendChild(opt);
                }
            });
        }

        // Services
        const servicesRes = await fetch('http://localhost:8000/api/services');
        const services = await servicesRes.json();
        console.log(`Received ${services.length} services`);
        const serviceSelect = document.getElementById('filter-service');
        if (Array.isArray(services)) {
            services.forEach(s => {
                if (s && s.trim()) {
                    const opt = document.createElement('option');
                    opt.value = s.trim();
                    opt.textContent = s.trim().replace('TIPO_SERVICIO_', '');
                    serviceSelect.appendChild(opt);
                }
            });
        }

    } catch (err) {
        console.error('Error populating filters:', err);
    }
}

function setupEventListeners() {
    const filters = ['filter-client', 'filter-type', 'filter-asesor', 'filter-service'];
    filters.forEach(id => {
        const el = document.getElementById(id);
        if (el) el.addEventListener('change', updateDashboard);
    });
}

async function initDashboard() {
    console.log("Dashboard Comsatel VIP Running");
    await populateFilters();
    setupEventListeners();
    await updateDashboard();
    startAutoRefresh(); // Iniciar timers
    updateLimaClock();   // Carga inicial del reloj
}

document.addEventListener('DOMContentLoaded', initDashboard);
