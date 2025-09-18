from fastapi import FastAPI
import os
import psycopg2

app = FastAPI(title="RehabLab DB API (demo)")

def get_conn():
    return psycopg2.connect(
        host=os.getenv("PGHOST","localhost"),
        port=os.getenv("PGPORT","5432"),
        user=os.getenv("PGUSER","rehab"),
        password=os.getenv("PGPASSWORD","rehab"),
        dbname=os.getenv("PGDATABASE","rehablab")
    )

@app.get("/health")
def health():
    return {"status":"ok"}

@app.get("/patients/{patient_id}/progress")
def patient_progress(patient_id: int, exercise: str | None = None):
    q = """
SELECT * FROM vw_progress_week
WHERE patient_id = %s
"""
    params = [patient_id]
    if exercise:
        q += " AND exercise_code = %s"
        params.append(exercise)
    q += " ORDER BY week"
    with get_conn() as conn, conn.cursor() as cur:
        cur.execute(q, params)
        cols = [d[0] for d in cur.description]
        rows = [dict(zip(cols, r)) for r in cur.fetchall()]
    return rows
