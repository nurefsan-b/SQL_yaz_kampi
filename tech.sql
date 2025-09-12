CREATE DATABASE TechSQL;

CREATE TABLE books(
book_id INT PRIMARY KEY IDENTITY(1,1),
title NVARCHAR(100) NOT NULL,
author NVARCHAR(100) NOT NULL,
genre NVARCHAR(100) NOT NULL,
price DECIMAL(10,2) CHECK(price>0),
stock INT CHECK(stock>=0),
published_year INT CHECK (published_year BETWEEN 1900 and 2025),
added_at DATE,
);

INSERT INTO books(title,author,genre,price,stock,published_year,added_at)
VALUES 
('Kay�p Zaman�n �zi' , 'M. Proust' , 'roman' , 129.90 , 25 , 1913 , '2025-08-20'),
('Simyac�' , 'P.Coelho' ,'roman' , 89.50 , 40 , 1988 , '2025-08-21' ),
('Sapiens' , 'Y.N.Harari' ,'tarih' , 159.00 , 18 , 2011 , '2025-08-25'),
('�nce Memed' , 'Y.Kemal' ,'roman' ,99.90 , 12 , 1955 , '2025-08-22'),
('K�rl�k' , 'J.Saramag' ,'roman' , 119.90 , 7 , 1995 , '2025-08-28'),
('Dune' , 'F.Herbert' , 'bilim' , 149.90 , 30 , 1965 , '2025-09-01'),
('Hayvan �iftli�i' , 'G.Orwell' ,'roman' , 79.90 , 55 , 1945 , '2025-08-23'),
('1984' , 'G.Orwell' ,'roman' , 99.00 , 35 , 1949 , '2025-08-24'),
('Nutuk' , 'M.K.Atat�rk' ,'tarih' , 139.00 , 20 , 1927 , '2025-08-27'),
('K���k Prens' , 'A. de Saint-Exup�ry' ,'�ocuk' ,69.90 , 80 , 1943 , '2025-08-26'),
('Ba�lang��' , 'D. Brown' , 'roman' , 109.00 , 22 , 2017 , '2025-09-02'),
('Atomik Al��kanl�klar' , 'J.Clear' , 'ki�isel geli�im' , 129.00 , 28 , 2018 , '2025-09-03'),
('Zaman�n K�sa Tarihi' , 'S.Hawking' , 'bilim' , 119.50 , 16 , 1988 , '2025-08-29'),
('�eker Portakal�' , 'J.M. de Vasconcelos' , 'roman' , 84.90 , 45 , 1968 ,'2025-08-30'),
('Bir �dam Mahk�munun Son G�n�' , 'V.Hugo' , 'roman' , 74.90 , 26, 1829 , '2025-08-31');

/* burada kod hata verdi sebebi published year 1829 de�erini almaya �al���rken check hata veriyor d�zeltmek ad�na :*/

ALTER TABLE dbo.books 
DROP COLUMN published_year;

/*burada da drop column diyemedim constraint oldu�u i�in o y�zden ara�t�r�p �nce bunu ��zmem gerekti�ini ��rendim.*/

EXEC sp_helpconstraint 'dbo.books';

/*ard�ndan constrainti d���rd�m*/

ALTER TABLE dbo.books
DROP CONSTRAINT CK__books__published__2C3393D0;

/*tekrar olu�turdum 1800'� ekleyerek*/

ALTER TABLE dbo.books
ADD published_year INT CHECK (published_year BETWEEN 1800 AND 2025);

/*1.T�m kitaplar�n title,author,price alanlar�n� fiyat� artan �ekilde s�ralayarak listele*/

SELECT title,author,price FROM books
ORDER BY price ASC;

/*2.T�r� roman olan kitaplar�n A->Z title s�ras�yla g�ster*/

SELECT *FROM books
WHERE genre='roman'
ORDER BY title;

/*3.Fiyat� 80 ile 120 aras�ndaki kitaplar� listele*/

SELECT *FROM books
WHERE price BETWEEN 80 and 120;

/*4.Stok adedi 20'den az olan kitaplar� bul(title,stock_qty)*/

SELECT title,stock as stock_qty FROM books
WHERE stock<=20

/*5.title i�inde 'zaman' ge�en kitaplar� LIKE ile filtreleyin (b�y�k/k���k harf durumunu not edin)
SQL b�y�k k���k harf duyarl�l��� olan bir dil olmad��� i�in herhangi bir �ey farketmedi ��kt�da*/

SELECT *FROM books 
WHERE title LIKE '%zaman%';

/*6. genre de�eri 'roman' veya 'bilim' olanlar� IN ile listeleyin*/

SELECT *FROM books
WHERE genre IN('roman','bilim');

/*7. published_year de�eri 2000 ve sonras� olan kitaplar�,en yeni y�ldan eskiye do�ru s�ralay�n*/

SELECT *FROM books
WHERE published_year>=2000
ORDER BY published_year DESC;

/*8. Son 10 g�n i�inde eklenen kitaplar� bulun(added_at tarihine g�re)*/
SELECT *FROM books
WHERE added_at>=DATEADD(DAY,-10,GETDATE());

/*9.En pahal� 5 kitab� price azalan s�rada ekleyin.*/

SELECT TOP 5 *FROM  books
ORDER BY price DESC;

/*Stok adedi 30 ile 60 arasnda olan kitaplar� price artan �ekilde s�ralay�n*/

SELECT *FROM books
WHERE stock BETWEEN 30 and 60
ORDER BY price ASC;


