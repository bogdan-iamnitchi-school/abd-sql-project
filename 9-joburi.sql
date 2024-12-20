USE db_management_spitale;
GO

CREATE TABLE DailyDoctorPatientStats (
    StatID INT IDENTITY PRIMARY KEY,
    StatDate DATE,
    TotalDoctors INT,
    TotalPatients INT
);

USE msdb;
GO

-- Creare job
EXEC sp_add_job 
    @job_name = 'Calculate Doctor and Patient Stats', 
    @enabled = 1, 
    @description = 'Job care calculează numărul de doctori și pacienți tratați zilnic și le inserează în tabelă.';
    
-- Creare pas de job
EXEC sp_add_jobstep 
    @job_name = 'Calculate Doctor and Patient Stats', 
    @step_name = 'Calculate Stats Step', 
    @subsystem = 'TSQL', 
    @command = '
        USE showroomDB;
        
        DECLARE @TotalDoctors INT, @TotalPatients INT;

        -- Număr total de doctori
        SELECT @TotalDoctors = COUNT(*) 
        FROM Doctori;

        -- Număr total de pacienți tratați (adăugați condițiile pentru a selecta doar pacienții tratați)
        SELECT @TotalPatients = COUNT(DISTINCT P.id_pacient)
        FROM Programari P
        JOIN Pacienti D ON P.id_pacient = D.id_pacient
        WHERE P.data_programare <= GETDATE(); -- Pacienți care au fost tratați până azi

        -- Inserare statistici în tabelă
        INSERT INTO DailyDoctorPatientStats (StatDate, TotalDoctors, TotalPatients)
        VALUES (CAST(GETDATE() AS DATE), @TotalDoctors, @TotalPatients);
    ', 
    @database_name = 'db_management_spitale';

-- Creare programare job
EXEC sp_add_jobschedule 
    @job_name = 'Calculate Doctor and Patient Stats', 
    @name = 'Daily at 23:59', 
    @enabled = 1, 
    @freq_type = 4,  -- Daily
    @freq_interval = 1, 
    @active_start_time = 235900;  -- 23:59:00
GO