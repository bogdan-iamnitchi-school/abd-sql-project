-- TRIGGERE DML
-- 1. trg_ValidateInsertPatient
CREATE TRIGGER trg_ValidateInsertPatient
ON Pacienti
FOR INSERT
AS
BEGIN
    DECLARE @PacientName VARCHAR(45), @Phone VARCHAR(45);

    -- Obținem numele și numărul de telefon al pacientului introdus
    SELECT @PacientName = nume, @Phone = nr_telefon
    FROM inserted;

    -- Validăm că numele nu este gol și numărul de telefon este valid
    IF (@PacientName IS NULL OR @PacientName = '' OR LEN(@Phone) < 10)
    BEGIN
        RAISERROR('Date invalide! Numele nu poate fi gol și numărul de telefon trebuie să aibă cel puțin 10 caractere.', 16, 1);
        ROLLBACK TRANSACTION;  -- Anulează inserarea
    END
END;

-- Încearcă să inserezi un pacient cu date invalide
INSERT INTO Pacienti (nume, adresa, sex, nr_telefon)
VALUES ('', 'Strada Exemplu', 'Masculin', '12345');  -- Numele este gol și numărul de telefon nu are 10 caractere
-- Va genera eroarea: "Date invalide! Numele nu poate fi gol și numărul de telefon trebuie să aibă cel puțin 10 caractere."

-- 2. trg_ValidateUpdateDoctorSalary
CREATE TRIGGER trg_ValidateUpdateDoctorSalary
ON Doctori
FOR UPDATE
AS
BEGIN
    DECLARE @OldSalary FLOAT, @NewSalary FLOAT, @DoctorID INT;

    -- Obținem vechiul salariu, noul salariu și ID-ul doctorului
    SELECT @OldSalary = salariu, @NewSalary = salariu, @DoctorID = id_doctor
    FROM inserted;

    -- Verificăm dacă salariul a fost redus la o valoare mai mică decât salariul minim permis
    IF (@NewSalary < 3000)
    BEGIN
        RAISERROR('Salariul doctorului nu poate fi mai mic de 3000!', 16, 1);
        ROLLBACK TRANSACTION;  -- Anulează actualizarea
    END
END;

-- Încearcă să actualizezi salariul unui doctor la o valoare mai mică decât 3000
UPDATE Doctori
SET salariu = 2500
WHERE id_doctor = 1;  -- Presupunând că doctorul cu ID 1 există
-- Va genera eroarea: "Salariul doctorului nu poate fi mai mic de 3000!"

-- TRIGGERE DDL
-- 1. trg_AuditDDLChanges
CREATE TABLE Logs (
    LogID INT IDENTITY(1,1) PRIMARY KEY CLUSTERED,
    TableName NVARCHAR(100) NOT NULL,
    Action NVARCHAR(50) NOT NULL,
    PerformedBy NVARCHAR(50) NOT NULL,
    Timestamp DATETIME DEFAULT GETDATE() NOT NULL
);

CREATE TRIGGER trg_AuditDDLChanges
ON DATABASE
FOR CREATE_TABLE, ALTER_TABLE, DROP_TABLE
AS
BEGIN
    DECLARE @TableName NVARCHAR(100), @Action NVARCHAR(50), @Timestamp DATETIME;

    -- Obținem numele tabelului și tipul de acțiune
    SET @TableName = EVENTDATA().value('(/EVENT_INSTANCE/ObjectName)[1]', 'NVARCHAR(100)');
    SET @Action = EVENTDATA().value('(/EVENT_INSTANCE/EventType)[1]', 'NVARCHAR(50)');
    SET @Timestamp = GETDATE();

    -- Înregistrăm schimbările DDL într-un tabel de loguri
    INSERT INTO Logs (TableName, Action, PerformedBy, Timestamp)
    VALUES (@TableName, @Action, SYSTEM_USER, @Timestamp);
END;

-- Crează un nou tabel, ceea ce va activa trigger-ul DDL
CREATE TABLE TestTable (
    TestID INT PRIMARY KEY,
    TestValue NVARCHAR(50)
);
-- Verifică tabelul Logs pentru înregistrarea acțiunii CREATE
SELECT * FROM Logs WHERE TableName = 'TestTable' AND Action = 'CREATE_TABLE';
-- Va trebui să vezi o înregistrare în Logs, care confirmă că trigger-ul a fost activat


-- 2. trg_PreventDropSpitaleDoctori
CREATE TRIGGER trg_PreventDropSpitaleDoctori
ON DATABASE
FOR DROP_TABLE
AS
BEGIN
    DECLARE @TableName NVARCHAR(100);

    -- Obținem numele tabelului care se încearcă a fi șters
    SET @TableName = EVENTDATA().value('(/EVENT_INSTANCE/ObjectName)[1]', 'NVARCHAR(100)');

    -- Verificăm dacă tabelul care se încearcă ștergerea este unul dintre tabelele sensibile
    IF @TableName IN ('Spitale', 'Doctori')
    BEGIN
        RAISERROR('Nu se poate șterge tabelul %s! Este un tabel critic.', 16, 1, @TableName);
        ROLLBACK;  -- Anulează acțiunea de ștergere
    END
END;

-- Șterge un tabel existent
DROP TABLE Spitale;
