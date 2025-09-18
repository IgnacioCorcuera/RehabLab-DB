
INSERT INTO patient(name, birthdate, sex, diagnosis, dominant_hand) VALUES
('Marta González','1982-03-12','F','Radiculopatía cervical','R'),
('Luis Pérez','1975-09-01','M','Secuelas post-ictus','L');

INSERT INTO therapist(name,email,department) VALUES
('Ana Ruiz','ana.ruiz@rehab.es','TO'),
('Javier Martín','javier.martin@rehab.es','Fisio');

INSERT INTO device(name,model,location,sampling_hz) VALUES
('HandTracker','Cam-MP','Hospital U. Toledo',30);

INSERT INTO exercise(code,name,target_joint,unit_primary) VALUES
('PRON_SUP','Prono-Supinación','antebrazo','deg'),
('FLEX_EXT','Flexo-Extensión','muñeca','deg');

-- Ejemplo: sesión de hace 2 días
INSERT INTO session(patient_id,therapist_id,device_id,started_at,ended_at,notes)
VALUES (1,1,1, now()-interval '2 days', now()-interval '2 days' + interval '30 min','Sesión inicial');
