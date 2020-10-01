WITH patientsDrugged AS (
	WITH testedDrugs AS (
		SELECT D.d_name, A.patient_id
		FROM drug D JOIN admin_on A
		ON D.d_name = A.d_name
	)
	SELECT T.d_name, T.patient_id, P.patient_status
	FROM testedDrugs T JOIN patient P
	ON T.patient_id = P.patient_id
)

SELECT d_name as DRUGNAME,
	SUM(CASE WHEN patient_status = 'recovered' then 1 else 0 end) as Recovered,
	SUM(CASE WHEN (patient_status = 'infected' OR patient_status = 'deceased') then 1 else 0 end) as Notrecovered 
FROM patientsDrugged
GROUP BY d_name;