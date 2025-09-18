
CREATE TABLE patient (
  id BIGSERIAL PRIMARY KEY,
  nhc TEXT UNIQUE,
  name TEXT NOT NULL,
  birthdate DATE,
  sex TEXT CHECK (sex IN ('M','F','O')),
  diagnosis TEXT,
  dominant_hand TEXT CHECK (dominant_hand IN ('L','R')),
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE therapist (
  id BIGSERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT UNIQUE,
  department TEXT,
  created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE device (
  id BIGSERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  model TEXT,
  location TEXT,
  sampling_hz INT CHECK (sampling_hz > 0),
  created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE exercise (
  id BIGSERIAL PRIMARY KEY,
  code TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  target_joint TEXT,
  description TEXT,
  unit_primary TEXT,
  created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE session (
  id BIGSERIAL PRIMARY KEY,
  patient_id BIGINT REFERENCES patient(id) ON DELETE CASCADE,
  therapist_id BIGINT REFERENCES therapist(id),
  device_id BIGINT REFERENCES device(id),
  started_at TIMESTAMPTZ NOT NULL,
  ended_at TIMESTAMPTZ,
  notes TEXT
);

CREATE TABLE session_exercise (
  id BIGSERIAL PRIMARY KEY,
  session_id BIGINT REFERENCES session(id) ON DELETE CASCADE,
  exercise_id BIGINT REFERENCES exercise(id),
  target_reps INT CHECK (target_reps >= 0),
  difficulty INT CHECK (difficulty BETWEEN 1 AND 10),
  config_json JSONB DEFAULT '{}'::jsonb
);

CREATE TABLE measurement (
  id BIGSERIAL PRIMARY KEY,
  session_exercise_id BIGINT REFERENCES session_exercise(id) ON DELETE CASCADE,
  ts TIMESTAMPTZ NOT NULL,
  angle_deg NUMERIC(6,2),
  velocity_dps NUMERIC(7,2),
  success_flag BOOLEAN,
  error_type TEXT,
  raw_json JSONB
);

CREATE TABLE achievement (
  id BIGSERIAL PRIMARY KEY,
  patient_id BIGINT REFERENCES patient(id) ON DELETE CASCADE,
  code TEXT NOT NULL,
  earned_at TIMESTAMPTZ NOT NULL,
  meta_json JSONB
);

CREATE TABLE score_summary (
  id BIGSERIAL PRIMARY KEY,
  session_exercise_id BIGINT UNIQUE REFERENCES session_exercise(id) ON DELETE CASCADE,
  hits INT DEFAULT 0,
  misses INT DEFAULT 0,
  mean_angle NUMERIC(6,2),
  max_angle NUMERIC(6,2),
  mean_velocity NUMERIC(7,2),
  duration_s NUMERIC(8,2)
);
