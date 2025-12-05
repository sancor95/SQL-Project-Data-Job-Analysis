/*
Question: What are the top skills based on salary?
- Looking for average salary associated with each skills for Data Analyst positions
- Focuses on roles with specified salaries in New York City
- Why? It reveals how different skills impact salary levels for Data Analysts and helps identify the most financially rewarding skills to scquire ot improve
*/

SELECT 
    skills,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL AND
    job_location = 'New York, NY'
GROUP BY
    skills
ORDER BY
    avg_salary DESC
LIMIT 25

/*
Quick Insights into High-Paying Data Analyst Trends
1. Specialization in Advanced Data Infrastructure Commands the Highest Salaries

The absolute highest salaries are tied to specialized, complex, and distributed data systems. These skills top the list, showing a premium placed on managing data complexity at scale:

    Non-Relational and Distributed Databases: elasticsearch and neo4j (a graph database) are tied for the highest average salary at $185,000. cassandra (a NoSQL distributed database) is close behind at $175,000.

    Real-time Data Processing: The inclusion of kafka ($135,000) highlights a significant trend toward real-time stream processing, necessary for financial or high-volume data operations.

Trend: To earn the top pay, a data analyst must be proficient in working with, and likely maintaining, non-standard, high-performance data infrastructure.
2. Core Programming and Systems Proficiency is Mandatory

A large segment of the list covers skills traditionally associated with software and systems engineering, pointing to hybrid roles with deep technical depth:

    Legacy/Core Programming: High-performance, lower-level languages like C ($146,500) and Java ($125,147), and even perl ($157,000), suggest roles in established enterprises (like finance) where high-speed code or interfacing with legacy systems is necessary.

    ML & Scientific Computing: dplyr (R package) at $167,500 and scikit-learn at $130,000 confirm that advanced statistical modeling and machine learning implementation are expected.

    DevOps & Automation: Skills like unix ($162,500), linux ($127,500), and shell scripting ($126,250) indicate these analysts are responsible for automating data pipelines, managing execution environments, and integrating with server infrastructure.

Trend: These roles require analysts to be proficient in DevOps practices and lower-level programming to manage data on the server level, not just the application level.
3. Full-Stack and Cloud Capabilities Are Expected

A surprising number of high-paying skills are from the web development and API ecosystem:

    Full-Stack/API Integration: twilio (API for communications) at **$150,000**, and web framework skills like angular ($138,516), spring ($147,500), and express ($126,005) indicate analysts are building production-grade internal tools and data products with front-end or integrated communication features.

    Cloud Orchestration: gcp ($135,294) and azure ($122,692) solidify the necessity of multi-cloud or specialized cloud experience, with GCP offering a slightly higher premium in this list. airflow ($122,500) demonstrates the need for formal workflow orchestration.

Noteworthy
Omission

As an expert who double-checks things, it's worth noting which skills didn't make this list of top-paying skills. Widely adopted foundational tools like SQL, Tableau, and Power BI are noticeably absent from the top 25. This is likely because proficiency in these tools is a minimum requirement for virtually all data analyst positions, and therefore, they do not correlate with the highest average salaries. The skills that command top dollar are the ones that are rare, complex, and allow the analyst to work closer to data science, engineering, or software development.
*/