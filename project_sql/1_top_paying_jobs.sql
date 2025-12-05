/*
Question: What are the top paying analyst jobs in New York City?
- Identify the top 10 highest-paying Data Analyst roles that are available in NYC.
- Return job postings with specified salaries (nulls values not considered).
- Why? To highlight the top-paying opportunities for Data Analysts offering insights into employee compensation rates and a large-scale average for the profession.
*/

SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS company_name
FROM
    job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'New York, NY' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;