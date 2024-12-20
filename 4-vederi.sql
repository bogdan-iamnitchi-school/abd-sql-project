CREATE VIEW Vedere_Doctori_Sectii AS
SELECT 
    d.id_doctor,
    d.nume AS nume_doctor,
    d.salariu AS salariu_doctor,
    d.sex AS sex_doctor,
    d.nr_telefon AS telefon_doctor,
    s.denumire AS denumire_sectie,
    sp.denumire AS denumire_spital,
    sp.adresa AS adresa_spital
FROM 
    Doctori d
JOIN 
    Sectii s ON d.id_sectie = s.id_sectie
JOIN 
    Spitale sp ON s.id_spital = sp.id_spital;


CREATE VIEW Vedere_Programari AS
SELECT 
    pr.id_programare,
    pac.nume AS nume_pacient,
    pac.nr_telefon AS telefon_pacient,
    d.nume AS nume_doctor,
    d.nr_telefon AS telefon_doctor,
    d.salariu AS salariu_doctor,
    pr.data_programare
FROM 
    Programari pr
JOIN 
    Pacienti pac ON pr.id_pacient = pac.id_pacient
JOIN 
    Doctori d ON pr.id_doctor = d.id_doctor;


CREATE VIEW Vedere_Diagnostice_Pacienti AS
SELECT 
    pac.nume AS nume_pacient,
    pac.sex AS sex_pacient,
    pac.nr_telefon AS telefon_pacient,
    diag.denumire AS diagnostic,
    diag.detalii AS detalii_diagnostic
FROM 
    Pacienti_Diagnostice pd
JOIN 
    Pacienti pac ON pd.id_pacient = pac.id_pacient
JOIN 
    Diagnostice diag ON pd.id_diagnostic = diag.id_diagnostic;


