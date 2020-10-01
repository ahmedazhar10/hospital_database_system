WITH staff_for_observations AS (
	WITH found_observations AS (
		WITH patients_observations AS (
			SELECT R.patient_id, O.obv_id, O.time, O.date, O.text  
			FROM	receive_observation R JOIN observation O
			ON R.obv_id = O.obv_id
			WHERE R.patient_id = (SELECT patient_id 
							  	FROM patient
							  	WHERE email = (SELECT email 
									FROM person
									WHERE name = 'Samantha Adam'
									)
							  	)
		)

		SELECT * 
		FROM patients_observations
		WHERE text LIKE '%breathing%'
	)
	SELECT M.hospital_id, F.obv_id, F.time, F.date, F.text  
	From found_observations F JOIN make_observation M
	ON F.obv_id = M.obv_id
)

SELECT H.name, S.time, S.date, S.text
FROM health_professional H, staff_for_observations S
WHERE H.hospital_id = S.hospital_id
ORDER BY (S.date, S.time) DESC;

