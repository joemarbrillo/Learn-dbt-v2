# Automated Job Postings Pipeline (v1) - dbt + DuckDB

###### Inspired by dbt for Data Analytics and Engineering by Luke Barousse.

![dbt pipeline diagram](image/dbt_pipeline.png)

A public dbt + DuckDB pipeline over ~627k real job postings, rebuilt and republished automatically every push.

- Models the the raw postings into tested, documented insight marts.
- Publishes the docs site and the finished warehouse - open to anyone, no credentials
- Runs itself on GitHub Actions: every push and every Monday

> **v1 of this pipeline** - everything free and local-friendly: DuckDB as the warehouse, GitHub Actions as the scheduler. [v2] (../project_2) rebuilds its production-grade on DataBricks.

| What I Build | How I Implemented | Where to Look |
| --- | --- | --- |
| **dbt pipeline** | sources -> cleaned model -> insight marts | [`analytics/models`](analytics/models/) |
| **Data tests** | `unique` / `not_null` on every mart grain | [`schema.yml`](analytics/models/schema.yml) |
| **Hosted dbt docs** | lineage, descriptions, column tests | [Live docs site](https://joemarbrillo.github.io/Learn-dbt-v2/) |
| **Public CI** | build + test + publish on every push | [Actions workflow](https://github.com/joemarbrillo/Learn-dbt-v2/blob/master/.github/workflows/dbt_build.yml) |
| **Environments** | local `dev` vs CI `prod` targets | [`ci/profiles.yml`](https://github.com/joemarbrillo/Learn-dbt-v2/blob/master/ci/profiles.yml) |
| **Published warehouse** | one `ATTACH`, queryable by anyone | [Query it](https://github.com/joemarbrillo/Learn-dbt-v2/releases/download/warehouse/prod.duckdb) |

`dbt build` compiles SQL, materializes models, ad fails the run if any test fails - same command locally and in CI.

On each run, Actions:
1. Installs deps with `uv`
2. Downloads raw parquet
3. Runs `dbt build` with the committed CI profile (prod)
4. Publishes `prod.duckdb` as a GitHub Release asset.

The badge at the top of this README links to the latest runs.

---
## Query the published warehouse

No clone required. [Install DuckDB](https://duckdb.org/docs/installation) (`brew install duckdb`), then from a `duckdb` session:

```sql
INSTALL httpfs;
LOAD https;

ATTACH 'https://github.com/joemarbrillo/Learn-dbt-v2/releases/download/warehouse/prod.duckdb' as jobs;

USE jobs;
SHOW TABLES;
```

> The short link is just a convenience - the database itself lives at the release asset URL, which works in `ATTACH` directly (use)

---

## Docs

Docs are generated with `dbt docs generate` and published to GitHub pages [Click to see the docs site](https://joemarbrillo.github.io/Learn-dbt-v2/):


The site shows:
- The full **lineage graph** (sources -> models -> marts)
- **Model and column descriptions** from YAML
- Which columns carry **tests**

---

## Run it yourself

```bash
uv sync
uv run python scripts/download_data.py
cd analytics && run dbt build
```

Optional docs locally:
```bash
uv run dbt docs generate
uv run dbt docs serve
```
---

## Tools
- [X] VS Code
- [X] Terminal
- [X] Git
- [X] uv
- [X] DuckDB



