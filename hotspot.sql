WITH infected_patients AS (
	SELECT Per.email, Per.name, Per.borough
	FROM person Per JOIN patient Pat 
	ON Per.email = Pat.email
	WHERE Pat.patient_status = 'infected'
)

SELECT B.b_name as borough, COUNT(Inf.email) as infected
FROM infected_patients Inf JOIN borough B
ON Inf.borough = B.b_name
GROUP BY B.b_name
ORDER BY  
	COUNT(Inf.email) DESC,
	B.b_name ASC;