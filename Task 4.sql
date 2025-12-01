-- Table
CREATE TABLE rental_date (
MOVIE_ID int,
CUSTOMER_ID int,
GENRE VARCHAR(255),
RENTAL_DATE DATE,
RETURN_DATE DATE,
RENTAL_FEE numeric
);
INSERT INTO rental_date (MOVIE_ID, CUSTOMER_ID, GENRE, RENTAL_DATE, RETURN_DATE, RENTAL_FEE) VALUES
(101, 5001, 'Drama', '2025-01-10', '2025-01-13', 120),
(102, 5002, 'Action', '2025-01-12', '2025-01-15', 150),
(103, 5003, 'Romance', '2025-01-14', '2025-01-16', 100),
(104, 5004, 'Thriller', '2025-01-16', '2025-01-18', 130),
(105, 5005, 'Comedy', '2025-01-18', '2025-01-21', 110),
(106, 5006, 'Drama', '2025-01-19', '2025-01-22', 125),
(107, 5007, 'Action', '2025-01-20', '2025-01-23', 150),
(108, 5008, 'Historical', '2025-01-21', '2025-01-25', 160),
(109, 5009, 'Sci-Fi', '2025-01-22', '2025-01-24', 140),
(110, 5010, 'Family', '2025-01-23', '2025-01-26', 115);

--OLAP Operations
-- a, Drill Down:Analyze rentals from genre to individual movie level
SELECT GENRE,COUNT(*) AS total_rentals,SUM(RENTAL_FEE) AS total_revenue
FROM rental_date GROUP BY GENRE ORDER BY total_rentals DESC;

--b,Roll up
SELECT 
    GENRE,
    SUM(RENTAL_FEE) AS total_rental_fee
FROM rental_date
GROUP BY ROLLUP (GENRE) ;

--c,Cube
SELECT GENRE,RENTAL_DATE, CUSTOMER_ID,
SUM(RENTAL_FEE) AS total_rental_fee FROM rental_date
GROUP BY CUBE (GENRE, RENTAL_DATE, CUSTOMER_ID)
ORDER BYCASE WHEN GENRE IS NULL AND RENTAL_DATE IS NULL AND CUSTOMER_ID IS NULL THEN 2 ELSE 1 END,
GENRE,RENTAL_DATE,CUSTOMER_ID;

--d, slice
SELECT * FROM rental_date
WHERE GENRE = 'Action';

--e, dice
SELECT * FROM rental_date
WHERE GENRE IN ('Action', 'Drama')
AND RENTAL_DATE >= CURRENT_DATE - INTERVAL '3 MONTH';