select
    job_id,
    job_title,
    company_name,
    job_location,
    job_via,
    job_schedule_type,
    search_date,
    search_term
from'../data/raw/raw_job_postings_*.parquet'
where error is null;