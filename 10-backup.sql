USE master;
GO

-- Full Backup (zilnic)
BACKUP DATABASE db_management_spitale
TO DISK = 'C:\SQLBackups\db_management_spitale_FullBackup.bak'
WITH FORMAT,
        INIT,
        NAME = 'Full Backup of db_management_spitale',
        STATS = 10; -- Afișează progresul backup-ului


-- Backup Diferential (la fiecare 6 ore)
USE master;
GO

BACKUP DATABASE db_management_spitale
TO DISK = 'C:\SQLBackups\db_management_spitale_DifferentialBackup.bak'
WITH DIFFERENTIAL,
        INIT,
        NAME = 'Differential Backup of db_management_spitale',
        STATS = 10;


-- Backup al jurnalului de tranzactii
USE master;
GO

BACKUP LOG db_management_spitale
TO DISK = 'C:\SQLBackups\db_management_spitale_LogBackup.trn'
WITH INIT,
        NAME = 'Transaction Log Backup of db_management_spitale',
        STATS = 10;