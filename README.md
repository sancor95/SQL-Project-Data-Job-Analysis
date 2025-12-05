# Introduction
This project is a comprehensive analysis of Data Analyst jobs in New York City, with a specific focus on understanding current market trends in required skills, average salaries, and overall industry demand for data professionals. The primary goal is to uncover the key factors that drive high compensation within the data analysis field.

Looking for the SQL queries? Click Here: [project_sql folder](/project_sql/)

# Background
The analysis leverages a rich dataset containing information on top-paying SQL data job postings. This data, sourced from a Luke Barousse SQL course, provided essential details on job titles, salaries, geographic locations, and the critical technical skills demanded by employers. The project utilizes this real-world job market data to derive actionable career insights.

# Tools I Used
For this analysis into the Data Analyst job market, I leveraged the power of several key tools: 
- **SQL**: The primary coding language behind my analysis, used to write quieries to return critical insights. 
- **PostgreSQL**: My chosen database management system that holds all the data used in this project. 
- **Visual Studio Code**: All data manipulation was performed by writing and executing SQL queries against the dataset within VS Code.
- **Git & Github**: Maintained version controls and helped me share my SQL scripts and analysis. 

# The Analysis
The analysis was structured around answering five key business questions to fully explore the data job market:

### 1: Top-Paying Jobs: 
What are the highest-paying data analyst job titles?

This query identifies the top 10 highest-paying Data Analyst roles based on average yearly salary.

```sql
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
```
💡 **Insights:**

The highest-paying roles are rarely titled simply "Data Analyst." The top of the salary distribution is dominated by senior, principal, or director-level titles, often coupled with specialized domains like "Lead Data Analyst," "Associate Director," or roles in high-value industries like Finance or Big Tech. This indicates that top pay correlates with leadership, experience, and domain expertise, not just technical skills alone.

### 2: Required Skills: 
What specific skills are required for these top-paying roles?

This query isolates the top 5 most frequently required skills among the top 10 highest-paying jobs identified in the previous step.

```sql
WITH top_paying_jobs AS (
    -- CTE to find the IDs of the top 10 paying Data Analyst jobs
    SELECT job_id
    FROM job_postings_fact
    WHERE
        job_title_short = 'Data Analyst' AND
        salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)

SELECT
    skills_dim.skills,
    COUNT(tpdj.job_id) AS skill_count
FROM
    top_paying_jobs AS tpdj
INNER JOIN skills_job_dim ON tpdj.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
GROUP BY
    skills_dim.skills
ORDER BY
    skill_count DESC
LIMIT 5;
```
💡 **Insights:**

Beyond foundational skills like SQL and Python, high-paying jobs show a strong bias toward Data Engineering, Cloud Computing, and DevOps tools (e.g., Databricks, AWS, Git, Snowflake). This confirms that top-tier "data analyst" roles are actually hybrid roles requiring the ability to manage, pipeline, and build scalable solutions, rather than just querying and visualizing data.

### 3: In-Demand Skills: 
What skills are most frequently requested (highest demand) for all data analyst jobs?

```sql
SELECT
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM
    job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_postings_fact.job_title_short = 'Data Analyst'
GROUP BY
    skills_dim.skills
ORDER BY
    demand_count DESC
LIMIT 10;
```

💡 **Insights:**

SQL, Python, and Excel consistently rank as the top three most-demanded skills. This highlights that while advanced technologies drive higher salaries (Q2), the basic foundation of database querying, scripting, and basic reporting remains the most ubiquitous requirement for entry and mid-level roles across the entire industry. Visualization tools like Tableau and Power BI are also core demands.

### 4: Skill Value: 
Which skills are uniquely associated with higher average salaries?
```sql
SELECT
    skills_dim.skills,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM
    job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_postings_fact.job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL
GROUP BY
    skills_dim.skills
HAVING
    COUNT(skills_job_dim.job_id) > 5 -- Filter for skills with at least 5 jobs for reliable average
ORDER BY
    avg_salary DESC
LIMIT 10;
```

💡 **Insights:**

The skills commanding the highest average pay are often niche, specialized, or Big Data technologies (e.g., PySpark, Scala, specific NoSQL databases). These skills typically have a lower demand count but are critical for specific, high-value projects, leading to a significant salary premium. Analysts should look to acquire these specialized skills to reach the upper end of the salary band.

### 5: Optimal Skills: 
What are the most optimal skills for a data analyst to learn or improve upon, based on a combination of high demand and good salary?

```sql
WITH skills_demand AS (
    -- Get demand count for all relevant skills
    SELECT 
        sjd.skill_id,
        COUNT(sjd.job_id) AS demand_count
    FROM job_postings_fact AS jpf
    INNER JOIN skills_job_dim AS sjd ON jpf.job_id = sjd.job_id
    WHERE jpf.job_title_short = 'Data Analyst'
    GROUP BY sjd.skill_id
), average_salary AS(
    -- Get average salary for all relevant skills
    SELECT 
        sjd.skill_id,
        ROUND(AVG(jpf.salary_year_avg), 0) AS avg_salary
    FROM job_postings_fact AS jpf
    INNER JOIN skills_job_dim AS sjd ON jpf.job_id = sjd.job_id
    WHERE 
        jpf.job_title_short = 'Data Analyst' AND 
        jpf.salary_year_avg IS NOT NULL
    GROUP BY sjd.skill_id
)

SELECT
    sd.skills,
    dd.demand_count,
    av.avg_salary,
    -- Calculate an 'Optimal Score' (Demand * Avg Salary)
    (av.avg_salary * dd.demand_count) AS optimal_score
FROM
    skills_demand AS dd
INNER JOIN average_salary AS av ON dd.skill_id = av.skill_id
INNER JOIN skills_dim AS sd ON dd.skill_id = sd.skill_id
ORDER BY
    optimal_score DESC
LIMIT 10;
```
💡 **Insights:**

The most optimal skills are those that land in the "sweet spot" on the scatter plot—high on the demand axis and high on the salary axis. Skills like Python, R, and key Cloud technologies (e.g., Azure, GCP) typically fall here. These skills provide the best return on investment for a data analyst's time, offering broad market access while still securing an above-average salary. Focusing on these ensures both competitive pay and job security.

# What I Learned
The analysis yielded several key insights into the modern data job market:

- **Big Data and Cloud Technologies**: The highest-paying individual skill was PySpark ($208,172/year), indicating a strong premium on big data processing and distributed computing. Databricks and GCP skills also commanded high salaries, emphasizing the importance of cloud and analytics platform expertise.

- **Engineering & Collaboration**: Skills like Bitbucket and GitLab were highly valued, reflecting the increased expectation for data analysts to follow software development practices (version control, collaboration).

- **Machine Learning and Data Science**: Libraries like Pandas, Numpy, and Scikit-learn underscored the requirement for strong data manipulation and machine learning implementation skills in high-level roles.

- **Specialized Technologies**: Proficiency in versatile programming languages like Swift and Golang also correlated with high salaries, as did specialized database skills like Couchbase and Elasticsearch.

# Conclusions
The overall conclusion is that data analysts who blend traditional analysis skills with data engineering and DevOps capabilities are the most competitive and highly compensated.

- Python and R are both highly demanded and offer substantial salaries, making them optimal skills for analysts to focus on for career growth.

- SQL remains the single most demanded skill overall and is essential for any role, though its competitive salary is more foundational compared to specialized Big Data skills.