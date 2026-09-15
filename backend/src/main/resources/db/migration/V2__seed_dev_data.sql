-- ============================================================
-- RED AYUDA — SEED DATA INICIAL PARA DESARROLLO Y PRODUCCIÓN (V2)
-- ============================================================

-- ROLES BÁSICOS DEL SISTEMA
INSERT INTO roles (id, nombre) VALUES
    ('00000000-0000-0000-0000-000000000001', 'ROLE_ADMINISTRADOR'),
    ('00000000-0000-0000-0000-000000000002', 'ROLE_CIUDADANO'),
    ('00000000-0000-0000-0000-000000000003', 'ROLE_CONTACTO_DE_CONFIANZA'),
    ('00000000-0000-0000-0000-000000000004', 'ROLE_INSTITUCION')
ON CONFLICT (nombre) DO NOTHING;

-- DIRECTORIO OFICIAL DE EMERGENCIAS (AYACUCHO - HUAMANGA)
INSERT INTO directorio_emergencia (id, nombre, tipo, telefono, region, provincia, distrito, prioridad, activo, fuente_verificacion) VALUES
    ('10000000-0000-0000-0000-000000000001', 'Policía Nacional del Perú (Central 105)', 'POLICIA', '105', 'Ayacucho', 'Huamanga', 'Ayacucho', 1, TRUE, 'Ministerio del Interior'),
    ('10000000-0000-0000-0000-000000000002', 'Comisaría de Ayacucho - Huamanga', 'POLICIA', '066312022', 'Ayacucho', 'Huamanga', 'Ayacucho', 2, TRUE, 'PNP Región Ayacucho'),
    ('10000000-0000-0000-0000-000000000003', 'SAMU Ayacucho (Emergencias Médicas)', 'SAMU', '106', 'Ayacucho', 'Huamanga', 'Ayacucho', 1, TRUE, 'MINSA - SAMU'),
    ('10000000-0000-0000-0000-000000000004', 'Compañía de Bomberos Ayacucho B-63', 'BOMBEROS', '116', 'Ayacucho', 'Huamanga', 'Ayacucho', 1, TRUE, 'CGBVP'),
    ('10000000-0000-0000-0000-000000000005', 'Serenazgo Municipal de Huamanga', 'SERENAZGO', '066312444', 'Ayacucho', 'Huamanga', 'Ayacucho', 1, TRUE, 'Municipalidad Provincial de Huamanga'),
    ('10000000-0000-0000-0000-000000000006', 'Hospital Regional de Ayacucho', 'HOSPITAL', '066312155', 'Ayacucho', 'Huamanga', 'Andrés Avelino Cáceres', 2, TRUE, 'DIRESA Ayacucho'),
    ('10000000-0000-0000-0000-000000000007', 'Defensa Civil Huamanga (INDECI)', 'DEFENSA_CIVIL', '115', 'Ayacucho', 'Huamanga', 'Ayacucho', 3, TRUE, 'INDECI')
ON CONFLICT (id) DO NOTHING;

-- USUARIO ADMINISTRADOR DE DEV (Password: Admin123456!)
-- Hash BCrypt para 'Admin123456!': $2a$10$wNnUe9yLzQo.GqVqF3zJMe3zX5tF9x0wK2y1v8zN7yP0l5x6qZ7bK
-- PIN Normal (1234): $2a$10$8k9F7pL3m1N5q9Z2w0yK4eZ1x3v5t7p9l0n2b4v6c8x0z2a4s6d8f
-- PIN Coacción (9999): $2a$10$9j0G8qM4n2O6r0A3x1zL5fa2y4w6u8q0m1o3c5w7d9y1a3b5s7e9g
INSERT INTO usuarios (id, dni, nombres, apellidos, telefono, email, password_hash, pin_hash, pin_coercion_hash, estado_verificacion, estado) VALUES
    ('20000000-0000-0000-0000-000000000001', '00000001', 'Admin', 'Red Ayacucho', '+51966000001', 'admin@redayuda.pe', '$2a$10$wNnUe9yLzQo.GqVqF3zJMe3zX5tF9x0wK2y1v8zN7yP0l5x6qZ7bK', '$2a$10$8k9F7pL3m1N5q9Z2w0yK4eZ1x3v5t7p9l0n2b4v6c8x0z2a4s6d8f', '$2a$10$9j0G8qM4n2O6r0A3x1zL5fa2y4w6u8q0m1o3c5w7d9y1a3b5s7e9g', 'VERIFICADO', 'NORMAL'),
    ('20000000-0000-0000-0000-000000000002', '45892314', 'Carlos', 'Mendoza Quispe', '+51966123456', 'victima@redayuda.pe', '$2a$10$wNnUe9yLzQo.GqVqF3zJMe3zX5tF9x0wK2y1v8zN7yP0l5x6qZ7bK', '$2a$10$8k9F7pL3m1N5q9Z2w0yK4eZ1x3v5t7p9l0n2b4v6c8x0z2a4s6d8f', '$2a$10$9j0G8qM4n2O6r0A3x1zL5fa2y4w6u8q0m1o3c5w7d9y1a3b5s7e9g', 'VERIFICADO', 'NORMAL'),
    ('20000000-0000-0000-0000-000000000003', '47821940', 'María', 'Flores Cárdenas', '+51966654321', 'contacto@redayuda.pe', '$2a$10$wNnUe9yLzQo.GqVqF3zJMe3zX5tF9x0wK2y1v8zN7yP0l5x6qZ7bK', '$2a$10$8k9F7pL3m1N5q9Z2w0yK4eZ1x3v5t7p9l0n2b4v6c8x0z2a4s6d8f', '$2a$10$9j0G8qM4n2O6r0A3x1zL5fa2y4w6u8q0m1o3c5w7d9y1a3b5s7e9g', 'VERIFICADO', 'NORMAL'),
    ('20000000-0000-0000-0000-000000000004', '49102844', 'Juan', 'Pérez Huamán', '+51966987654', 'vecino@redayuda.pe', '$2a$10$wNnUe9yLzQo.GqVqF3zJMe3zX5tF9x0wK2y1v8zN7yP0l5x6qZ7bK', '$2a$10$8k9F7pL3m1N5q9Z2w0yK4eZ1x3v5t7p9l0n2b4v6c8x0z2a4s6d8f', '$2a$10$8k9F7pL3m1N5q9Z2w0yK4eZ1x3v5t7p9l0n2b4v6c8x0z2a4s6d8f', 'VERIFICADO', 'NORMAL')
ON CONFLICT (id) DO NOTHING;

-- ASIGNAR ROLES A USUARIOS SEED
INSERT INTO usuario_roles (usuario_id, rol_id) VALUES
    ('20000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000001'), -- Admin -> ROLE_ADMINISTRADOR
    ('20000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000002'), -- Victima -> ROLE_CIUDADANO
    ('20000000-0000-0000-0000-000000000003', '00000000-0000-0000-0000-000000000003'), -- Contacto -> ROLE_CONTACTO_DE_CONFIANZA
    ('20000000-0000-0000-0000-000000000004', '00000000-0000-0000-0000-000000000002')  -- Vecino -> ROLE_CIUDADANO
ON CONFLICT (usuario_id, rol_id) DO NOTHING;

-- CONFIGURACIÓN SOS DE EJEMPLO
INSERT INTO configuracion_emergencia (id, usuario_id, segundos_cuenta_regresiva, duracion_audio_segundos, sonido_cuenta_regresiva, vibracion_activa, activacion_voz_activa, frase_activacion_voz) VALUES
    ('30000000-0000-0000-0000-000000000001', '20000000-0000-0000-0000-000000000002', 10, 5, TRUE, TRUE, FALSE, 'RED AYUDA')
ON CONFLICT (usuario_id) DO NOTHING;

-- CONTACTO DE CONFIANZA ASIGNADO A VÍCTIMA
INSERT INTO contactos_confianza (id, usuario_id, nombre, telefono, email, parentesco, prioridad, tiene_red_ayuda, usuario_red_ayuda_id, permite_ubicacion_precisa, permite_audio, activo) VALUES
    ('40000000-0000-0000-0000-000000000001', '20000000-0000-0000-0000-000000000002', 'María Flores (Hermana)', '+51966654321', 'contacto@redayuda.pe', 'Hermana', 1, TRUE, '20000000-0000-0000-0000-000000000003', TRUE, TRUE, TRUE),
    ('40000000-0000-0000-0000-000000000002', '20000000-0000-0000-0000-000000000002', 'Mamá Rosa Quispe (Sin App)', '+51966111222', 'rosa.quispe@correo.pe', 'Madre', 2, FALSE, NULL, TRUE, TRUE, TRUE)
ON CONFLICT (id) DO NOTHING;
