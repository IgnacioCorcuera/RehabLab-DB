
CREATE INDEX idx_session_patient ON session(patient_id, started_at DESC);
CREATE INDEX idx_measurement_sx_ts ON measurement(session_exercise_id, ts);
CREATE INDEX idx_measurement_success ON measurement(success_flag);
CREATE INDEX idx_achievement_patient ON achievement(patient_id, earned_at DESC);
