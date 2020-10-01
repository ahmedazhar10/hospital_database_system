WITH susPatients AS (
	WITH susObservations AS (
		WITH susObvIDs AS (
			WITH tociPatients AS (
				SELECT D.d_name, A.patient_id, A.date AS dosage_date
				FROM drug D JOIN admin_on A
				ON D.d_name = A.d_name
				WHERE D.d_name = 'tocilizumab'
			)

			SELECT T.d_name, T.patient_id, T.dosage_date, R.obv_id
			FROM tociPatients T JOIN receive_observation R
			ON T.patient_id = R.patient_id
		)

		SELECT S.d_name, S.patient_id, S.dosage_date, S.obv_id, O.date AS obv_date
		FROM susObvIDs S JOIN observation O
		ON S.obv_id = O.obv_id
		WHERE S.dosage_date < O.date
		AND O.text LIKE '%dizz%'
	)

	SELECT DISTINCT patient_id 
	FROM susObservations
)
SELECT COUNT(patient_id) AS Num_of_Dizzy_Patients 
FROM susPatients;




