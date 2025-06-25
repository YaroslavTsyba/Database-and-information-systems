--1. Які лікарі є в базі даних?
SELECT id, name, specialization FROM doctor;

--2. Які пацієнти мають найвищі та найнижчі показники здоров'я за останні кілька років?
SELECT p.name, a.health_score, a.visit_date
FROM appointment a
JOIN patient p ON a.patient_id = p.id
WHERE a.visit_date >= CURRENT_DATE - INTERVAL '3 years'
ORDER BY a.health_score DESC
LIMIT 1;

-- Найнижчий:
SELECT p.name, a.health_score, a.visit_date
FROM appointment a
JOIN patient p ON a.patient_id = p.id
WHERE a.visit_date >= CURRENT_DATE - INTERVAL '3 years'
ORDER BY a.health_score ASC
LIMIT 1;
--3. Скільки пацієнтів записалися на прийом до конкретного лікаря?
SELECT COUNT(DISTINCT patient_id) AS total_patients
FROM appointment
WHERE doctor_id = 2;
--4. Які діагнози найчастіше ставляться пацієнтам?
SELECT diagnosis, COUNT(*) AS frequency
FROM appointment
GROUP BY diagnosis
ORDER BY frequency DESC;
--5. Яка середня кількість відвідувань кожного пацієнта?
SELECT AVG(visits_per_patient) AS avg_visits
FROM (
    SELECT COUNT(*) AS visits_per_patient
    FROM appointment
    GROUP BY patient_id
) AS sub;
--6. Скільки операцій було проведено за певний період?
SELECT COUNT(*) AS surgeries_count
FROM surgery
WHERE date >= CURRENT_DATE - INTERVAL '6 months';
--7. Які пацієнти не пройшли обов'язкове обстеження?
SELECT p.name
FROM patient p
WHERE p.id NOT IN (
    SELECT patient_id
    FROM appointment
    WHERE is_checkup = true
);
--8. Яка загальна кількість наданих медичних послуг за місяць?
SELECT COUNT(*) AS total_services
FROM service
WHERE service_date >= date_trunc('month', CURRENT_DATE);
--9. Які записи мають термінові випадки (наприклад, операції, що потрібно провести терміново)?
SELECT a.id, p.name AS patient, d.name AS doctor, a.visit_date
FROM appointment a
JOIN patient p ON a.patient_id = p.id
JOIN doctor d ON a.doctor_id = d.id
WHERE a.is_urgent = true;
--10. Які лікарі мають найменше навантаження на прийомах?
SELECT d.name, COUNT(a.id) AS appointment_count
FROM doctor d
LEFT JOIN appointment a ON d.id = a.doctor_id
GROUP BY d.id
ORDER BY appointment_count ASC;

