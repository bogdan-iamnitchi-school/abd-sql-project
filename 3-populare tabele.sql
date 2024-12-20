-- Popularea tabelului Manageri
INSERT INTO Manageri (nume, salariu, nr_telefon, email) VALUES
('Dr. Popescu', 5000, '0712345678', 'popescu@example.com'),
('Dr. Ionescu', 5200, '0723456789', 'ionescu@example.com'),
('Dr. Georgescu', 5500, '0734567890', 'georgescu@example.com');

-- Popularea tabelului Spitale
INSERT INTO Spitale (denumire, adresa, id_manager) VALUES
('Spitalul Central', 'Strada Principala 10', 1),
('Spitalul Regional', 'Bulevardul Regional 22', 2),
('Spitalul de Urgență', 'Strada Urgenței 5', 3);

-- Popularea tabelului Sectii
INSERT INTO Sectii (id_spital, denumire) VALUES
(1, 'Cardiologie'),
(1, 'Neurologie'),
(2, 'Ortopedie'),
(2, 'Pediatrie'),
(3, 'Urologie');

-- Popularea tabelului Doctori
INSERT INTO Doctori (id_sectie, nume, salariu, sex, nr_telefon) VALUES
(1, 'Ion Popescu', 5000, 'Masculin', '0741234567'),
(2, 'Maria Ionescu', 5200, 'Femin', '0723456789'),
(3, 'Vasile Georgescu', 5500, 'Masculin', '0734567890'),
(4, 'Elena Munteanu', 5800, 'Femin', '0756789012'),
(5, 'Alex Stan', 5000, 'Masculin', '0767890123');

-- Popularea tabelului Pacienti
INSERT INTO Pacienti (nume, adresa, sex, nr_telefon) VALUES
('Ana Mihai', 'Strada Victoriei 15', 'Femin', '0741234567'),
('Ion Popescu', 'Bulevardul Central 22', 'Masculin', '0712345678'),
('Maria Georgescu', 'Strada Verde 10', 'Femin', '0723456789'),
('Alex Stan', 'Strada Nouă 3', 'Masculin', '0734567890'),
('Elena Munteanu', 'Bulevardul Est 5', 'Femin', '0756789012');

-- Popularea tabelului Diagnostice
INSERT INTO Diagnostice (denumire, detalii) VALUES
('Gripa', 'Infecție virală comună'),
('Răceală', 'Infecție de sezon'),
('Fractură', 'Leziune la nivel osos'),
('Anemie', 'Deficiență de fier'),
('Diabet', 'Boală metabolică');

-- Popularea tabelului Programari
INSERT INTO Programari (id_doctor, id_pacient, data_programare) VALUES
(1, 1, '2023-12-15 10:30:00'),
(2, 2, '2023-12-16 11:00:00'),
(3, 3, '2023-12-17 14:00:00'),
(4, 4, '2023-12-18 15:30:00'),
(5, 5, '2023-12-19 09:00:00');

-- Popularea tabelului Pacienti_Diagnostice
INSERT INTO Pacienti_Diagnostice (id_pacient, id_diagnostic) VALUES
(1, 1),
(1, 2),
(2, 3),
(3, 4),
(4, 5),
(5, 1),
(5, 3);
