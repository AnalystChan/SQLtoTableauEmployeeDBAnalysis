/* 
Task 1: Create a visualisation that provides a breakdown between the male and female employees 
working in the company each year, starting from 1990.
*/

select STRFTIME('%Y',dep.from_date) as calendar_year, emp.gender, COUNT(emp.emp_no) as number_of_employees
from employees emp
JOIN dept_emp dep ON emp.emp_no = dep.emp_no
group by calendar_year, emp.gender
HAVING calendar_year >= 1990;

/* 
Task 2: Compare the number of male managers to the number of female managers from different departments for each year, starting 1990.
*/

WITH emp AS (SELECT STRFTIME('%Y', hire_date) AS cal_year FROM employees GROUP BY cal_year)
SELECT dep.dept_name, ee.gender, dm.emp_no, dm.from_date, dm.to_date, emp.cal_year,
    CASE WHEN STRFTIME('%Y', dm.to_date) >= emp.cal_year AND STRFTIME('%Y', dm.from_date) <= emp.cal_year THEN 1 ELSE 0
    END AS active
FROM  emp
CROSS JOIN dept_manager dm
JOIN departments dep ON dep.dept_no = dm.dept_no
JOIN employees ee ON dm.emp_no = ee.emp_no
ORDER BY dm.emp_no, emp.cal_year;

/* 
Task 3: Compare the average salary of female versus male employees in the entire company until year 2002, 
and add a filter allowing to see that per each department
*/

SELECT e.gender, d.dept_name, ROUND(AVG(s.salary),2) as salary, STRFTIME('%Y', e.hire_date) AS calendar_year
FROM salaries s
JOIN employees e ON e.emp_no = s.emp_no
JOIN dept_emp de ON de.emp_no = e.emp_no
JOIN departments d ON d.dept_no = de.dept_no
GROUP BY d.dept_no, e.gender, calendar_year
HAVING calendar_year <= '2002'
ORDER BY d.dept_no;

---In the selected time period, the average salaries have been diminishing for any department
---Until 1998 the average salaries for male and female employees were similar, and after that salaries for female employees augmented while salaries for male employees diminished further

/* 
Task 4: Create an SQL query that will allow you to obtain the average male and female salary per department within a certain salary range.
*/

SELECT e.gender, d.dept_name, ROUND(AVG(s.salary),2) AS avg_salary
FROM salaries s
JOIN employees e ON s.emp_no = e.emp_no
JOIN dept_emp de ON de.emp_no = e.emp_no
JOIN departments d ON d.dept_no = de.dept_no
WHERE s.salary BETWEEN 50000 AND 90000
GROUP BY e.gender, d.dept_name;