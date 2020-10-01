select distinct name, email, phone
from person
WHERE email IN (
	select C.email 
	from patient P, contacts C
	WHERE P.patient_id = 
	(select patient_id from patient where email = 'dub.vizer@br.com')
	AND P.patient_id = C.patient_id
);

