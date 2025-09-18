# RehabLab-DB

Plataforma de datos para rehabilitación de miembro superior. Incluye esquema SQL, despliegue con Docker y (opcional) una API mínima.

## Estructura
```
RehabLab-DB/
├─ sql/
│  ├─ 01_schema_postgres.sql
│  ├─ 02_indexes.sql
│  ├─ 03_views_functions_triggers.sql
│  └─ 04_seed.sql
├─ docker/
│  ├─ docker-compose.yml
│  └─ init/  (copias de los .sql para autoinicializar)
├─ api/      (opcional: FastAPI)
│  ├─ app.py
│  └─ requirements.txt
└─ notebooks/
   └─ analytics.ipynb (placeholder)
```

## Puesta en marcha rápida
1. Instala Docker Desktop y activa WSL2.
2. En `docker/`: `docker compose up -d`.
3. Conéctate a Postgres: `localhost:5432` (user=rehab, pass=rehab, db=rehablab).
4. Revisa la vista `vw_progress_week`.

## Licencia
MIT
