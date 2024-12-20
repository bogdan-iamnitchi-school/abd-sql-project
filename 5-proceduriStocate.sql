-- Procedura pentru adăugarea unui doctor
CREATE PROCEDURE AddDoctor
    @id_sectie INT,
    @nume NVARCHAR(100),
    @salariu FLOAT,
    @sex NVARCHAR(10),
    @nr_telefon NVARCHAR(20)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Sectii WHERE id_sectie = @id_sectie)
    BEGIN
        RAISERROR('Secția specificată nu există.', 16, 1);
        RETURN;
    END
    INSERT INTO Doctori (id_sectie, nume, salariu, sex, nr_telefon)
    VALUES (@id_sectie, @nume, @salariu, @sex, @nr_telefon);
    PRINT 'Doctor adăugat cu succes.';
END;

-- Procedura pentru actualizarea informațiilor unui pacient
CREATE PROCEDURE UpdatePatient
    @id_pacient INT,
    @nume NVARCHAR(100),
    @adresa NVARCHAR(100),
    @sex NVARCHAR(10),
    @nr_telefon NVARCHAR(20)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Pacienti WHERE id_pacient = @id_pacient)
    BEGIN
        RAISERROR('Pacientul specificat nu există.', 16, 1);
        RETURN;
    END
    UPDATE Pacienti
    SET nume = @nume, adresa = @adresa, sex = @sex, nr_telefon = @nr_telefon
    WHERE id_pacient = @id_pacient;
    PRINT 'Datele pacientului au fost actualizate.';
END;

-- Procedura pentru ștergerea unei programări
CREATE PROCEDURE DeleteAppointment
    @id_programare INT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Programari WHERE id_programare = @id_programare)
    BEGIN
        RAISERROR('Programarea specificată nu există.', 16, 1);
        RETURN;
    END
    DELETE FROM Programari WHERE id_programare = @id_programare;
    PRINT 'Programarea a fost ștearsă.';
END;

-- Procedura pentru afișarea doctorilor dintr-un spital
CREATE PROCEDURE GetDoctorsByHospital
    @id_spital INT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Spitale WHERE id_spital = @id_spital)
    BEGIN
        RAISERROR('Spitalul specificat nu există.', 16, 1);
        RETURN;
    END
    SELECT 
        d.nume AS DoctorName, 
        d.salariu AS Salary, 
        s.denumire AS SectionName
    FROM 
        Doctori d
    JOIN 
        Sectii s ON d.id_sectie = s.id_sectie
    WHERE 
        s.id_spital = @id_spital;
END;


-- Funcție pentru calcularea salariului mediu al doctorilor dintr-un spital
CREATE FUNCTION GetAverageDoctorSalary(@id_spital INT)
RETURNS FLOAT
AS
BEGIN
    DECLARE @avgSalary FLOAT;
    SELECT @avgSalary = AVG(d.salariu)
    FROM Doctori d
    JOIN Sectii s ON d.id_sectie = s.id_sectie
    WHERE s.id_spital = @id_spital;
    RETURN @avgSalary;
END;

-- Funcție pentru întoarcerea numărului total de programări ale unui doctor
CREATE FUNCTION GetDoctorAppointmentCount(@id_doctor INT)
RETURNS INT
AS
BEGIN
    DECLARE @count INT;
    SELECT @count = COUNT(*)
    FROM Programari
    WHERE id_doctor = @id_doctor;
    RETURN @count;
END;