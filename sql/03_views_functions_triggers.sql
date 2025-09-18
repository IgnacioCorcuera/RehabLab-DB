
CREATE VIEW vw_progress_week AS
SELECT
  p.id AS patient_id,
  e.code AS exercise_code,
  date_trunc('week', s.started_at) AS week,
  AVG(ss.mean_angle) AS avg_mean_angle,
  AVG(ss.mean_velocity) AS avg_mean_velocity,
  SUM(ss.hits) AS total_hits,
  SUM(ss.misses) AS total_misses
FROM patient p
JOIN session s ON s.patient_id = p.id
JOIN session_exercise se ON se.session_id = s.id
JOIN exercise e ON e.id = se.exercise_id
LEFT JOIN score_summary ss ON ss.session_exercise_id = se.id
GROUP BY p.id, e.code, date_trunc('week', s.started_at);

CREATE OR REPLACE FUNCTION compute_score_summary(p_session_exercise_id BIGINT)
RETURNS VOID AS $$
BEGIN
  INSERT INTO score_summary(session_exercise_id, hits, misses, mean_angle, max_angle, mean_velocity, duration_s)
  SELECT
    se.id,
    SUM(CASE WHEN m.success_flag THEN 1 ELSE 0 END) AS hits,
    SUM(CASE WHEN m.success_flag THEN 0 ELSE 1 END) AS misses,
    AVG(m.angle_deg) AS mean_angle,
    MAX(m.angle_deg) AS max_angle,
    AVG(m.velocity_dps) AS mean_velocity,
    EXTRACT(EPOCH FROM (MAX(m.ts) - MIN(m.ts))) AS duration_s
  FROM session_exercise se
  JOIN measurement m ON m.session_exercise_id = se.id
  WHERE se.id = p_session_exercise_id
  GROUP BY se.id
  ON CONFLICT (session_exercise_id) DO UPDATE SET
    hits = EXCLUDED.hits,
    misses = EXCLUDED.misses,
    mean_angle = EXCLUDED.mean_angle,
    max_angle = EXCLUDED.max_angle,
    mean_velocity = EXCLUDED.mean_velocity,
    duration_s = EXCLUDED.duration_s;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION trg_after_measurement()
RETURNS TRIGGER AS $$
BEGIN
  PERFORM compute_score_summary(NEW.session_exercise_id);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_measurement_ai
AFTER INSERT OR UPDATE ON measurement
FOR EACH ROW EXECUTE PROCEDURE trg_after_measurement();
