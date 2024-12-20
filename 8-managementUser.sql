-- Create login for admin
CREATE LOGIN admin WITH PASSWORD = 'admin@123';
USE db_management_spitale;
CREATE USER admin FOR LOGIN admin;
GRANT CONTROL ON DATABASE::db_management_spitale TO admin;

-- Create login for pacient
CREATE LOGIN pacient WITH PASSWORD = 'pacient@123';
USE db_management_spitale;
CREATE USER pacient FOR LOGIN pacient;
GRANT EXECUTE ON OBJECT::pacient_make_appointment TO pacient;
GRANT EXECUTE ON OBJECT::pacient_view_appointments TO pacient;
GRANT EXECUTE ON OBJECT::pacient_view_diagnostics TO pacient;


-- pacient_make_appointment
CREATE PROCEDURE pacient_make_appointment
    @patient_name VARCHAR(45),
    @doctor_name VARCHAR(45),
    @appointment_date DATETIME
AS
BEGIN
    -- Check if the patient exists
    IF NOT EXISTS (SELECT 1 FROM Pacienti WHERE nume = @patient_name)
    BEGIN
        RAISERROR('Pacientul specificat nu există.', 16, 1);
        RETURN;
    END

    -- Check if the doctor exists
    IF NOT EXISTS (SELECT 1 FROM Doctori WHERE nume = @doctor_name)
    BEGIN
        RAISERROR('Doctorul specificat nu există.', 16, 1);
        RETURN;
    END

    -- Get the patient ID and doctor ID
    DECLARE @patient_id INT, @doctor_id INT;
    SELECT @patient_id = id_pacient FROM Pacienti WHERE nume = @patient_name;
    SELECT @doctor_id = id_doctor FROM Doctori WHERE nume = @doctor_name;

    -- Insert the appointment
    INSERT INTO Programari (id_doctor, id_pacient, data_programare)
    VALUES (@doctor_id, @patient_id, @appointment_date);

    PRINT 'Programare realizată cu succes.';
END;

EXEC pacient_make_appointment 
    @patient_name = 'Ana Ionescu', 
    @doctor_name = 'Ion Popescu', 
    @appointment_date = '2024-12-20 10:00:00';

-- pacient_view_appointments
CREATE PROCEDURE pacient_view_appointments
    @patient_name VARCHAR(45)
AS
BEGIN
    -- Check if the patient exists
    IF NOT EXISTS (SELECT 1 FROM Pacienti WHERE nume = @patient_name)
    BEGIN
        RAISERROR('Pacientul specificat nu există.', 16, 1);
        RETURN;
    END

    -- Get the patient ID
    DECLARE @patient_id INT;
    SELECT @patient_id = id_pacient FROM Pacienti WHERE nume = @patient_name;

    -- Retrieve the patient's appointment history
    SELECT 
        D.nume AS Doctor,
        P.data_programare AS DataProgramare
    FROM Programari P
    JOIN Doctori D ON P.id_doctor = D.id_doctor
    WHERE P.id_pacient = @patient_id;
END;

EXEC pacient_view_appointments 
    @patient_name = 'Ana Ionescu';


-- pacient_view_diagnostics
CREATE PROCEDURE pacient_view_diagnostics
    @patient_name VARCHAR(45)
AS
BEGIN
    -- Check if the patient exists
    IF NOT EXISTS (SELECT 1 FROM Pacienti WHERE nume = @patient_name)
    BEGIN
        RAISERROR('Pacientul specificat nu există.', 16, 1);
        RETURN;
    END

    -- Get the patient ID
    DECLARE @patient_id INT;
    SELECT @patient_id = id_pacient FROM Pacienti WHERE nume = @patient_name;

    -- Retrieve the patient's diagnostics
    SELECT 
        D.denumire AS Diagnostic,
        D.detalii AS Detalii
    FROM Diagnostice D
    JOIN Pacienti_Diagnostice PD ON D.id_diagnostic = PD.id_diagnostic
    WHERE PD.id_pacient = @patient_id;
END;

EXEC pacient_view_diagnostics 
    @patient_name = 'Ana Ionescu';



