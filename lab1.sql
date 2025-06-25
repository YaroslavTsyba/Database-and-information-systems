INSERT INTO medicine (name, describes)
VALUES 
('Нітрогліцерін', 'Антиангіальний засіб'),
('Но-шпа', 'Знеболююче'),
('Валеріана', 'Седативний препарат');

SELECT * FROM medicine;

UPDATE medicine 
SET name = 'Ібупрофен'
WHERE id = 2


SELECT * FROM medicine;