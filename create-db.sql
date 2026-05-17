CREATE DATABASE IF NOT EXISTS hotell_db;
USE hotell_db;

CREATE TABLE IF NOT EXISTS kund (
    kundNr BIGINT PRIMARY KEY,
    foretag BOOLEAN,
    personEllerForetagNr VARCHAR(50),
    fornamnEllerForetagsnamn VARCHAR(100),
    efternamn VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS personal (
    anstallningsNr BIGINT PRIMARY KEY,
    roll VARCHAR(50),
    namn VARCHAR(100),
    adress VARCHAR(255),
    mail VARCHAR(100),
    losenord VARCHAR(255),
    lon DECIMAL(10,2),
    kontoNr VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS rum (
    rumNr INT PRIMARY KEY,
    rumTyp ENUM('enkelrum','dubbelrum','familjerum'),
    vaning INT,
    beskrivning VARCHAR(255),
    pris DECIMAL(10,2),
    prisDatum DATETIME
);

CREATE TABLE IF NOT EXISTS erbjudanden (
    ErID BIGINT PRIMARY KEY,
    typ ENUM('rabatt','paket','kampanj'),
    mangd FLOAT,
    beskrivning VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS Transaktioner (
    transID BIGINT PRIMARY KEY,
    ErID BIGINT,
    fakturaID BIGINT,
    datum DATETIME,
    FOREIGN KEY (ErID) REFERENCES erbjudanden(ErID)
);

CREATE TABLE IF NOT EXISTS rumsbokningar (
    RBNr BIGINT PRIMARY KEY,
    rumNr INT,
    kundNr BIGINT,
    transID BIGINT,
    bokningsNr BIGINT,
    startDatum DATE,
    slutDatum DATE,
    FOREIGN KEY (rumNr) REFERENCES rum(rumNr),
    FOREIGN KEY (kundNr) REFERENCES kund(kundNr),
    FOREIGN KEY (transID) REFERENCES Transaktioner(transID)
);

CREATE TABLE IF NOT EXISTS boendeGaster (
    BGNr BIGINT PRIMARY KEY,
    RBNr BIGINT,
    telefonNr VARCHAR(30),
    fornamn VARCHAR(100),
    efternamn VARCHAR(100),
    FOREIGN KEY (RBNr) REFERENCES rumsbokningar(RBNr)
);

CREATE TABLE IF NOT EXISTS middagsbokningar (
    MBNr BIGINT PRIMARY KEY,
    transID BIGINT,
    kundNr BIGINT,
    bokningsNr BIGINT,
    startTid DATETIME,
    slutTid DATETIME,
    antalGaster INT,
    FOREIGN KEY (transID) REFERENCES Transaktioner(transID),
    FOREIGN KEY (kundNr) REFERENCES kund(kundNr)
);

CREATE TABLE IF NOT EXISTS in_utcheckning (
    IID BIGINT PRIMARY KEY,
    BGNr BIGINT,
    anstallningsNr BIGINT,
    inEllerUt ENUM('in','ut'),
    datum DATETIME,
    FOREIGN KEY (BGNr) REFERENCES boendeGaster(BGNr),
    FOREIGN KEY (anstallningsNr) REFERENCES personal(anstallningsNr)
);

CREATE TABLE IF NOT EXISTS artiklar (
    artNr BIGINT PRIMARY KEY,
    kategori VARCHAR(100),
    inkopspris DECIMAL(10,2),
    pris DECIMAL(10,2),
    prisDatum DATETIME,
    status ENUM('aktiv','inaktiv'),
    rumNr INT,
    FOREIGN KEY (rumNr) REFERENCES rum(rumNr)
);

CREATE TABLE IF NOT EXISTS supportarenden (
    arendeNr BIGINT PRIMARY KEY,
    anstallningsNr BIGINT,
    status ENUM('oppen','pagaende','stangd'),
    senastUppdaterad DATETIME,
    beskrivning TEXT,
    atgard TEXT,
    FOREIGN KEY (anstallningsNr) REFERENCES personal(anstallningsNr)
);