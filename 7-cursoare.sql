-- 1. Procedura stocată pentru mărirea salariilor doctorilor
CREATE PROCEDURE sp_UpdateDoctorSalaries
    @Procent FLOAT
AS
BEGIN
    DECLARE @DoctorID INT, @SalariuActual FLOAT, @SalariuNou FLOAT;

    DECLARE SalaryCursor CURSOR FOR
    SELECT id_doctor, salariu
    FROM Doctori;

    OPEN SalaryCursor;
    FETCH NEXT FROM SalaryCursor INTO @DoctorID, @SalariuActual;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Calculăm noul salariu
        SET @SalariuNou = @SalariuActual + (@SalariuActual * @Procent);

        -- Actualizăm salariul în tabelul Doctori
        UPDATE Doctori
        SET salariu = @SalariuNou
        WHERE id_doctor = @DoctorID;

        FETCH NEXT FROM SalaryCursor INTO @DoctorID, @SalariuActual;
    END;

    CLOSE SalaryCursor;
    DEALLOCATE SalaryCursor;
END;


-- 2. Procedura pentru concatenarea numerelor de telefon ale doctorilor
CREATE PROCEDURE sp_GetDoctorPhoneNumbers
AS
BEGIN
    DECLARE @PhoneNumber VARCHAR(255) = ''; -- Variabilă pentru stocarea rezultatului concatenat
    DECLARE @Phone VARCHAR(45);

    -- Cursorul selectează numerele de telefon ale doctorilor
    DECLARE PhoneCursor CURSOR FOR
    SELECT nr_telefon
    FROM Doctori
    WHERE nr_telefon IS NOT NULL;

    OPEN PhoneCursor;
    FETCH NEXT FROM PhoneCursor INTO @Phone;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Concatenează numărul de telefon la rezultatul existent
        SET @PhoneNumber = @PhoneNumber + @Phone + ', ';

        FETCH NEXT FROM PhoneCursor INTO @Phone;
    END;

    CLOSE PhoneCursor;
    DEALLOCATE PhoneCursor;

    -- Înlăturăm ultima virgulă și spațiu
    SET @PhoneNumber = LEFT(@PhoneNumber, LEN(@PhoneNumber) - 2);

    -- Returnăm rezultatul concatenat
    SELECT @PhoneNumber AS DoctorPhoneNumbers;
END;

-- Testarea procedurii pentru a obține toate numerele de telefon ale doctorilor
EXEC sp_GetDoctorPhoneNumbers;

-- 3. Procedura pentru numărarea pacientelor de sex feminin
CREATE PROCEDURE sp_CountFemalePatients
AS
BEGIN
    DECLARE @PatientCount INT = 0; -- Contor pentru numărul pacientelor
    DECLARE @Sex VARCHAR(45);

    -- Cursorul selectează sexul pacienților
    DECLARE PatientCursor CURSOR FOR
    SELECT sex
    FROM Pacienti;

    OPEN PatientCursor;
    FETCH NEXT FROM PatientCursor INTO @Sex;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Incrementăm contorul dacă pacientul este de sex feminin
        IF @Sex = 'Feminin'
        BEGIN
            SET @PatientCount = @PatientCount + 1;
        END;

        FETCH NEXT FROM PatientCursor INTO @Sex;
    END;

    CLOSE PatientCursor;
    DEALLOCATE PatientCursor;

    -- Returnăm numărul pacientelor de sex feminin
    SELECT @PatientCount AS FemalePatientCount;
END;

-- Testarea procedurii pentru a număra pacientele de sex feminin
EXEC sp_CountFemalePatients;