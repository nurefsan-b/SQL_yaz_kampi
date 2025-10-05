-- =========================
-- 1. TABLOLAR
-- =========================

CREATE TABLE Musteri (
    id INT IDENTITY(1,1) PRIMARY KEY,
    ad NVARCHAR(50) NOT NULL,
    soyad NVARCHAR(50) NOT NULL,
    email NVARCHAR(100) UNIQUE,
    sehir NVARCHAR(50),
    kayit_tarihi DATE DEFAULT GETDATE()
);

CREATE TABLE Kategori (
    id INT IDENTITY(1,1) PRIMARY KEY,
    ad NVARCHAR(50) NOT NULL
);

CREATE TABLE Satici (
    id INT IDENTITY(1,1) PRIMARY KEY,
    ad NVARCHAR(100) NOT NULL,
    adres NVARCHAR(200)
);

CREATE TABLE Urun (
    id INT IDENTITY(1,1) PRIMARY KEY,
    ad NVARCHAR(100) NOT NULL,
    fiyat DECIMAL(10,2) NOT NULL,
    stok INT NOT NULL,
    kategori_id INT FOREIGN KEY REFERENCES Kategori(id),
    satici_id INT FOREIGN KEY REFERENCES Satici(id)
);

CREATE TABLE Siparis (
    id INT IDENTITY(1,1) PRIMARY KEY,
    musteri_id INT FOREIGN KEY REFERENCES Musteri(id),
    tarih DATETIME DEFAULT GETDATE(),
    toplam_tutar DECIMAL(10,2),
    odeme_turu NVARCHAR(20)
);

CREATE TABLE Siparis_Detay (
    id INT IDENTITY(1,1) PRIMARY KEY,
    siparis_id INT FOREIGN KEY REFERENCES Siparis(id),
    urun_id INT FOREIGN KEY REFERENCES Urun(id),
    adet INT NOT NULL,
    fiyat DECIMAL(10,2) NOT NULL
);

-- =========================
-- 2. �RNEK VER�LER
-- =========================

INSERT INTO Musteri (ad, soyad, email, sehir) VALUES
('Ali', 'Y�lmaz', 'ali@email.com', '�stanbul'),
('Ay�e', 'Demir', 'ayse@email.com', 'Ankara'),
('Mehmet', 'Kaya', 'mehmet@email.com', '�zmir');

INSERT INTO Kategori (ad) VALUES ('Elektronik'), ('Kitap'), ('Moda');

INSERT INTO Satici (ad, adres) VALUES
('TeknolojiMarket', '�stanbul'),
('Kitap�� D�nyas�', 'Ankara'),
('ModaEv', '�zmir');

INSERT INTO Urun (ad, fiyat, stok, kategori_id, satici_id) VALUES
('Laptop', 15000, 10, 1, 1),
('Telefon', 8000, 20, 1, 1),
('Roman Kitap', 120, 100, 2, 2),
('Ti��rt', 250, 50, 3, 3);

-- Sipari� ve detay ekleme
INSERT INTO Siparis (musteri_id, toplam_tutar, odeme_turu)
VALUES (1, 15120, 'Kredi Kart�');

INSERT INTO Siparis_Detay (siparis_id, urun_id, adet, fiyat)
VALUES (1, 1, 1, 15000), (1, 3, 1, 120);

-- =========================
-- 3. DML �RNEKLER�
-- =========================

-- UPDATE: Stok azalt
UPDATE Urun SET stok = stok - 1 WHERE id = 1;

-- DELETE: Bir �r�n� sil
DELETE FROM Urun WHERE id = 4;

-- TRUNCATE: Ge�ici tabloyu temizle (�rnek)
-- TRUNCATE TABLE GeciciLog;

-- =========================
-- 4. RAPORLAR
-- =========================

-- En �ok sipari� veren 5 m��teri
SELECT TOP 5 m.ad, m.soyad, COUNT(s.id) AS siparis_sayisi
FROM Musteri m
JOIN Siparis s ON m.id = s.musteri_id
GROUP BY m.ad, m.soyad
ORDER BY siparis_sayisi DESC;

-- En �ok sat�lan �r�nler
SELECT u.ad, SUM(sd.adet) AS toplam_adet
FROM Urun u
JOIN Siparis_Detay sd ON u.id = sd.urun_id
GROUP BY u.ad
ORDER BY toplam_adet DESC;

-- En y�ksek cirolu sat�c�lar
SELECT sa.ad, SUM(sd.adet * sd.fiyat) AS toplam_ciro
FROM Satici sa
JOIN Urun u ON sa.id = u.satici_id
JOIN Siparis_Detay sd ON u.id = sd.urun_id
GROUP BY sa.ad
ORDER BY toplam_ciro DESC;

-- �ehirlere g�re m��teri say�s�
SELECT sehir, COUNT(*) AS musteri_sayisi
FROM Musteri
GROUP BY sehir;

-- Kategori bazl� toplam sat��
SELECT k.ad, SUM(sd.adet * sd.fiyat) AS toplam_satis
FROM Kategori k
JOIN Urun u ON k.id = u.kategori_id
JOIN Siparis_Detay sd ON u.id = sd.urun_id
GROUP BY k.ad;

-- Aylara g�re sipari� say�s�
SELECT DATENAME(MONTH, tarih) AS ay, COUNT(*) AS siparis_sayisi
FROM Siparis
GROUP BY DATENAME(MONTH, tarih);

-- Hi� sipari� vermemi� m��teriler
SELECT m.ad, m.soyad
FROM Musteri m
LEFT JOIN Siparis s ON m.id = s.musteri_id
WHERE s.id IS NULL;

-- Hi� sat�lmam�� �r�nler
SELECT u.ad
FROM Urun u
LEFT JOIN Siparis_Detay sd ON u.id = sd.urun_id
WHERE sd.id IS NULL;

-- =========================
-- 5. OPS�YONEL RAPORLAR
-- =========================

-- En �ok kazan� sa�layan ilk 3 kategori
SELECT TOP 3 k.ad, SUM(sd.adet * sd.fiyat) AS toplam_ciro
FROM Kategori k
JOIN Urun u ON k.id = u.kategori_id
JOIN Siparis_Detay sd ON u.id = sd.urun_id
GROUP BY k.ad
ORDER BY toplam_ciro DESC;

-- Ortalama sipari� tutar�n� ge�en sipari�ler
SELECT id, toplam_tutar
FROM Siparis
WHERE toplam_tutar > (SELECT AVG(toplam_tutar) FROM Siparis);

-- En az bir kez elektronik �r�n alan m��teriler
SELECT DISTINCT m.ad, m.soyad
FROM Musteri m
JOIN Siparis s ON m.id = s.musteri_id
JOIN Siparis_Detay sd ON s.id = sd.siparis_id
JOIN Urun u ON sd.urun_id = u.id
JOIN Kategori k ON u.kategori_id = k.id
WHERE k.ad = 'Elektronik';
