-- SQL_HW_2_Part_2_W_Bonus_RFM_SarpE
-- Analysis Date 2012-01-01

-- Table

CREATE Table RFM_SarpE
(   Customer_ID VARCHAR (50) NULL ,
    Last_Invoice_Date DATETIME NULL,
    First_Invoice_Date DATETIME NULL, 
    Tenure INT NULL,
    Recency INT NULL,
    Recency_Score INT NULL,
    Frequency INT NULL,
    Frequency_Score INT NULL,
    Monetary INT NULL,
    Basket_Size FLOAT NULL,
    Segment VARCHAR (50) NULL);
    

INSERT INTO RFM_SarpE(Customer_ID)
SELECT DISTINCT Customer_ID from onlineretaildb.dbo.retail_II;

UPDATE RFM_SarpE SET Last_Invoice_Date = 
(   SELECT MAX(InvoiceDate) FROM onlineretaildb.dbo.retail_II r
    WHERE r.Customer_ID=RFM_SarpE.Customer_ID);

UPDATE RFM_SarpE SET First_Invoice_Date = 
(   SELECT MIN(InvoiceDate) FROM onlineretaildb.dbo.retail_II r
    WHERE r.Customer_ID=RFM_SarpE.Customer_ID);

UPDATE RFM_SarpE SET Tenure= DATEDIFF(DAY, First_Invoice_Date, '2012-01-01');

UPDATE RFM_SarpE SET Recency=DATEDIFF(DAY, Last_Invoice_Date, '2012-01-01');

UPDATE RFM_SarpE SET Recency_Score= 
(   SELECT RS from
        (SELECT Customer_ID, Recency, NTILE(5) OVER (ORDER BY Recency DESC) RS FROM RFM_SarpE ) T1
    WHERE T1.Customer_ID=RFM_SarpE.Customer_ID);

UPDATE RFM_SarpE SET Frequency=
(   SELECT COUNT(DISTINCT Invoice) FROM onlineretaildb.dbo.retail_II r
    WHERE r.Customer_ID=RFM_SarpE.Customer_ID);

UPDATE RFM_SarpE SET Frequency_Score=
(   SELECT FS FROM 
        (SELECT Customer_ID, Frequency, NTILE(5) OVER (ORDER BY Frequency) FS FROM RFM_SarpE ) T2
    WHERE T2.Customer_ID=RFM_SarpE.Customer_ID);

UPDATE RFM_SarpE SET Monetary=
(   SELECT ROUND(SUM(Quantity*Price),0) FROM onlineretaildb.dbo.retail_II r
    WHERE r.Customer_ID=RFM_SarpE.Customer_ID);

UPDATE RFM_SarpE SET Basket_Size= (Monetary/Frequency) FROM RFM_SarpE;

-- Segments

UPDATE RFM_SarpE SET Segment= 'Hibernating'
WHERE Recency_Score LIKE '[1-2]' AND Frequency_Score LIKE '[1-2]';

UPDATE RFM_SarpE SET Segment= 'At_Risk'
WHERE Recency_Score LIKE '[1-2]' AND Frequency_Score LIKE '[3-4]';

UPDATE RFM_SarpE SET Segment= 'Cant_Lose_Them'
WHERE Recency_Score LIKE '[1-2]' AND Frequency_Score LIKE '[5]';

UPDATE RFM_SarpE SET Segment= 'About_To_Sleep'
WHERE Recency_Score LIKE '[3]' AND Frequency_Score LIKE '[1-2]';

UPDATE RFM_SarpE SET Segment= 'Need_Attention'
WHERE Recency_Score LIKE '[3]' AND Frequency_Score LIKE '[3]';

UPDATE RFM_SarpE SET Segment ='Loyal_Customers'
WHERE Recency_Score LIKE '[3-4]' AND Frequency_Score LIKE '[4-5]';

UPDATE RFM_SarpE SET Segment= 'Promising'
WHERE Recency_Score LIKE '[4]' AND Frequency_Score LIKE '[1]';

UPDATE RFM_SarpE SET Segment= 'New_Customers'
WHERE Recency_Score LIKE '[5]' AND Frequency_Score LIKE '[1]';

UPDATE RFM_SarpE SET Segment = 'Potential_Loyalists'
WHERE Recency_Score LIKE '[4-5]' AND Frequency_Score LIKE '[2-3]';

UPDATE RFM_SarpE SET Segment= 'Champions'
WHERE Recency_Score LIKE '[5]' AND Frequency_Score LIKE '[4-5]';

SELECT * FROM RFM_SarpE
WHERE Segment IS NOT NULL 
ORDER BY Customer_ID DESC

SELECT Segment, Count(Customer_ID) As Müsteri_Adedi from RFM_SarpE
WHERE Segment IS NOT NULL 
GROUP BY Segment;

