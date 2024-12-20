-- Adăugarea constrângerilor și a indecșilor

-- Relație 1:1 între Spitale și Manageri
ALTER TABLE Spitale
ADD CONSTRAINT FK_Spitale_Manageri FOREIGN KEY (id_manager) REFERENCES Manageri(id_manager) ON DELETE CASCADE,
    CONSTRAINT UQ_Spitale_Manager UNIQUE (id_manager);

-- Relație 1:n între Spitale și Sectii
ALTER TABLE Sectii
ADD CONSTRAINT FK_Sectii_Spitale FOREIGN KEY (id_spital) REFERENCES Spitale(id_spital) ON DELETE CASCADE;

-- Relație 1:n între Sectii și Doctori
ALTER TABLE Doctori
ADD CONSTRAINT FK_Doctori_Sectii FOREIGN KEY (id_sectie) REFERENCES Sectii(id_sectie) ON DELETE CASCADE;

-- Relație n:m între Doctori și Pacienti rezolvata prin adaugarea tabelei de programari si relatiile:
-- Relație 1:n între Doctori și Programari
ALTER TABLE Programari
ADD CONSTRAINT FK_Programari_Doctori FOREIGN KEY (id_doctor) REFERENCES Doctori(id_doctor) ON DELETE CASCADE;
-- Relație 1:n între Pacienti și Programari
ALTER TABLE Programari
ADD CONSTRAINT FK_Programari_Pacienti FOREIGN KEY (id_pacient) REFERENCES Pacienti(id_pacient) ON DELETE CASCADE;

-- Relație n:m între Pacienti și Diagnostice
ALTER TABLE Pacienti_Diagnostice
ADD CONSTRAINT PK_Pacienti_Diagnostice PRIMARY KEY (id_pacient, id_diagnostic),
    CONSTRAINT FK_Pacienti_Diagnostice_Pacienti FOREIGN KEY (id_pacient) REFERENCES Pacienti(id_pacient) ON DELETE CASCADE,
    CONSTRAINT FK_Pacienti_Diagnostice_Diagnostice FOREIGN KEY (id_diagnostic) REFERENCES Diagnostice(id_diagnostic) ON DELETE CASCADE;

-- Adăugarea indecșilor
CREATE UNIQUE INDEX IDX_Spitale_Manager ON Spitale(id_manager);
CREATE UNIQUE INDEX IDX_Email_Manager ON Manageri(email);
CREATE NONCLUSTERED INDEX IDX_Pacienti_Clustered ON Pacienti(nume);
CREATE NONCLUSTERED INDEX IDX_Diagnostice_Denumire ON Diagnostice(denumire);
CREATE INDEX IDX_Sectii_Spitale ON Sectii(id_spital);
CREATE INDEX IDX_Doctori_Sectii ON Doctori(id_sectie);
CREATE INDEX IDX_Programari_Doctori ON Programari(id_doctor);
CREATE INDEX IDX_Programari_Pacienti ON Programari(id_pacient);
CREATE INDEX IDX_Pacienti_Diagnostice_Pacienti ON Pacienti_Diagnostice(id_pacient);
CREATE INDEX IDX_Pacienti_Diagnostice_Diagnostice ON Pacienti_Diagnostice(id_diagnostic);