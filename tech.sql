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
('Kayýp Zamanýn Ýzi' , 'M. Proust' , 'roman' , 129.90 , 25 , 1913 , '2025-08-20'),
('Simyacý' , 'P.Coelho' ,'roman' , 89.50 , 40 , 1988 , '2025-08-21' ),
('Sapiens' , 'Y.N.Harari' ,'tarih' , 159.00 , 18 , 2011 , '2025-08-25'),
('Ýnce Memed' , 'Y.Kemal' ,'roman' ,99.90 , 12 , 1955 , '2025-08-22'),
('Körlük' , 'J.Saramag' ,'roman' , 119.90 , 7 , 1995 , '2025-08-28'),
('Dune' , 'F.Herbert' , 'bilim' , 149.90 , 30 , 1965 , '2025-09-01'),
('Hayvan Çiftliði' , 'G.Orwell' ,'roman' , 79.90 , 55 , 1945 , '2025-08-23'),
('1984' , 'G.Orwell' ,'roman' , 99.00 , 35 , 1949 , '2025-08-24'),
('Nutuk' , 'M.K.Atatürk' ,'tarih' , 139.00 , 20 , 1927 , '2025-08-27'),
('Küçük Prens' , 'A. de Saint-Exupéry' ,'çocuk' ,69.90 , 80 , 1943 , '2025-08-26'),
('Baþlangýç' , 'D. Brown' , 'roman' , 109.00 , 22 , 2017 , '2025-09-02'),
('Atomik Alýþkanlýklar' , 'J.Clear' , 'kiþisel geliþim' , 129.00 , 28 , 2018 , '2025-09-03'),
('Zamanýn Kýsa Tarihi' , 'S.Hawking' , 'bilim' , 119.50 , 16 , 1988 , '2025-08-29'),
('Þeker Portakalý' , 'J.M. de Vasconcelos' , 'roman' , 84.90 , 45 , 1968 ,'2025-08-30'),
('Bir Ýdam Mahkûmunun Son Günü' , 'V.Hugo' , 'roman' , 74.90 , 26, 1829 , '2025-08-31');

/* burada kod hata verdi sebebi published year 1829 deðerini almaya çalýþýrken check hata veriyor düzeltmek adýna :*/

ALTER TABLE dbo.books 
DROP COLUMN published_year;

/*burada da drop column diyemedim constraint olduðu için o yüzden araþtýrýp önce bunu çözmem gerektiðini öðrendim.*/

EXEC sp_helpconstraint 'dbo.books';

/*ardýndan constrainti düþürdüm*/

ALTER TABLE dbo.books
DROP CONSTRAINT CK__books__published__2C3393D0;

/*tekrar oluþturdum 1800'ü ekleyerek*/

ALTER TABLE dbo.books
ADD published_year INT CHECK (published_year BETWEEN 1800 AND 2025);

/*1.Tüm kitaplarýn title,author,price alanlarýný fiyatý artan þekilde sýralayarak listele*/

SELECT title,author,price FROM books
ORDER BY price ASC;

/*2.Türü roman olan kitaplarýn A->Z title sýrasýyla göster*/

SELECT *FROM books
WHERE genre='roman'
ORDER BY title;

/*3.Fiyatý 80 ile 120 arasýndaki kitaplarý listele*/

SELECT *FROM books
WHERE price BETWEEN 80 and 120;

/*4.Stok adedi 20'den az olan kitaplarý bul(title,stock_qty)*/

SELECT title,stock as stock_qty FROM books
WHERE stock<=20

/*5.title içinde 'zaman' geçen kitaplarý LIKE ile filtreleyin (büyük/küçük harf durumunu not edin)
SQL büyük küçük harf duyarlýlýðý olan bir dil olmadýðý için herhangi bir þey farketmedi çýktýda*/

SELECT *FROM books 
WHERE title LIKE '%zaman%';

/*6. genre deðeri 'roman' veya 'bilim' olanlarý IN ile listeleyin*/

SELECT *FROM books
WHERE genre IN('roman','bilim');

/*7. published_year deðeri 2000 ve sonrasý olan kitaplarý,en yeni yýldan eskiye doðru sýralayýn*/

SELECT *FROM books
WHERE published_year>=2000
ORDER BY published_year DESC;

/*8. Son 10 gün içinde eklenen kitaplarý bulun(added_at tarihine göre)*/
SELECT *FROM books
WHERE added_at>=DATEADD(DAY,-10,GETDATE());

/*9.En pahalý 5 kitabý price azalan sýrada ekleyin.*/

SELECT TOP 5 *FROM  books
ORDER BY price DESC;

/*Stok adedi 30 ile 60 arasnda olan kitaplarý price artan þekilde sýralayýn*/

SELECT *FROM books
WHERE stock BETWEEN 30 and 60
ORDER BY price ASC;


