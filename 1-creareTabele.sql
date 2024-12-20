-- Creare tabele fără constrângeri
CREATE TABLE Manageri (
    id_manager INT PRIMARY KEY IDENTITY(1,1),
    nume VARCHAR(45) NOT NULL,
    salariu FLOAT NOT NULL,
    nr_telefon VARCHAR(45),
    email VARCHAR(45)
);

CREATE TABLE Spitale (
    id_spital INT PRIMARY KEY IDENTITY(1,1),
    denumire VARCHAR(45) NOT NULL,
    adresa VARCHAR(45) NOT NULL,
    id_manager INT
);

CREATE TABLE Sectii (
    id_sectie INT PRIMARY KEY IDENTITY(1,1),
    id_spital INT,
    denumire VARCHAR(45) NOT NULL
);

CREATE TABLE Doctori (
    id_doctor INT PRIMARY KEY IDENTITY(1,1),
    id_sectie INT,
    nume VARCHAR(45) NOT NULL,
    salariu FLOAT NOT NULL,
    sex VARCHAR(45),
    nr_telefon VARCHAR(45)
);

CREATE TABLE Pacienti (
    id_pacient INT PRIMARY KEY IDENTITY(1,1),
    nume VARCHAR(45) NOT NULL,
    adresa VARCHAR(45),
    sex VARCHAR(45),
    nr_telefon VARCHAR(45)
);

CREATE TABLE Diagnostice (
    id_diagnostic INT PRIMARY KEY IDENTITY(1,1),
    denumire VARCHAR(45) NOT NULL,
    detalii VARCHAR(45)
);

CREATE TABLE Programari (
    id_programare INT PRIMARY KEY IDENTITY(1,1),
    id_doctor INT,
    id_pacient INT,
    data_programare DATETIME NOT NULL
);

CREATE TABLE Pacienti_Diagnostice (
    id_pacient INT NOT NULL,
    id_diagnostic INT NOT NULL,
);

CREATE TABLE Logs (
    LogID INT IDENTITY(1,1) PRIMARY KEY CLUSTERED,
    TableName NVARCHAR(100) NOT NULL,
    Action NVARCHAR(50) NOT NULL,
    PerformedBy NVARCHAR(50) NOT NULL,
    Timestamp DATETIME DEFAULT GETDATE() NOT NULL
);