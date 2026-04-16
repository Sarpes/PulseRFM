-- SQL Ödev 2 Part 1

USE northwinddb
GO 

-- Soru 1 : "Geciken Urunler" ortalama kaç gün geciktiğini bulan sorguyu yazınız.

SELECT AVG(Gecikme_Gün) AS Ortalama_Gecikme_Gün FROM

(SELECT OrderID, RequiredDate, ShippedDate, DATEDIFF(DAY,RequiredDate,ShippedDate) AS Gecikme_Gün FROM orders
WHERE RequiredDate IS NOT NULL AND ShippedDate IS NOT NULL AND DATEDIFF(DAY,RequiredDate,ShippedDate) > 0) TG;

-- Soru 2 : "Erken Giden Urunler" in ortalama kaç gün erken gittiğini bulan sorguyu yazınız

SELECT AVG(Erken_Gün) AS Ortalama_Erken_Gün FROM

(SELECT OrderID, RequiredDate, ShippedDate, DATEDIFF(DAY,ShippedDate,RequiredDate) AS Erken_Gün FROM orders
WHERE RequiredDate IS NOT NULL AND ShippedDate IS NOT NULL AND DATEDIFF(DAY,ShippedDate,RequiredDate) > 0) TE;
-- -----------------------------------------------------
USE onlineretaildb
GO 

-- Soru 3 : CustomerID bazında Toplam Ne Kadar Gelir elde edildiğini gösteren tabloyu getiren sorguyu yazınız. - Monetary

SELECT DISTINCT Customer_ID, ROUND(SUM(Quantity*Price),0) AS Toplam_Gelir_Monetary FROM retail_II
WHERE Customer_ID IS NOT NULL GROUP BY Customer_ID  ORDER BY Toplam_Gelir_Monetary DESC;

-- Soru 4 : CustomerID bazında 2011.12.30 tarihine göre Recency değerlerini gösteren tabloyu oluşturacak sorguyu yazınız.

SELECT DISTINCT Customer_ID, MAX(InvoiceDate) AS Son_Alisveris_Tarihi, DATEDIFF(DAY,MAX(InvoiceDate),'2011-12-30') AS Recency FROM retail_II 
WHERE Customer_ID IS NOT NULL GROUP BY Customer_ID ORDER BY Recency ASC;

-- Soru 5 : Ülke bazında en fazla satın alınan ürünlerin Toplam Cirosu nu gösteren tabloyu oluşturacak sorguyu yazınız

SELECT Country,[Description],Toplam_Satis_Adedi, Toplam_Ciro FROM

(SELECT Country, [Description], SUM(Quantity) AS Toplam_Satis_Adedi, ROUND(SUM(Quantity*Price),0) AS Toplam_Ciro,
ROW_NUMBER() OVER (PARTITION BY Country ORDER BY SUM(Quantity) DESC) AS RN FROM retail_II
GROUP BY Country, [Description]) T1

WHERE RN = 1 ORDER BY Country
