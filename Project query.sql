-- Create database
CREATE DATABASE elearning_platform;
USE elearning_platform;

-- Table 1: Learners
CREATE TABLE learners (
    learner_id INT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    country VARCHAR(50) NOT NULL
);

-- Table 2: Courses
CREATE TABLE courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL
);

-- Table 3: Purchases
CREATE TABLE purchases (
    purchase_id INT PRIMARY KEY,
    learner_id INT,
    course_id INT,
    quantity INT NOT NULL,
    purchase_date DATE NOT NULL,
    FOREIGN KEY (learner_id) REFERENCES learners(learner_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

-- Inserting sample datas

INSERT INTO learners VALUES
(1,'John Smith','USA'),
(2,'Priya Sharma','India'),
(3,'Ahmed Ali','UAE'),
(4,'Sarah Johnson','Canada'),
(5,'David Miller','UK');

INSERT INTO courses VALUES
(101,'SQL for Beginners','Data Science',120.00),
(102,'Python Programming','Programming',150.00),
(103,'Digital Marketing Masterclass','Marketing',100.00),
(104,'Power BI Analytics','Data Science',180.00),
(105,'Web Development Bootcamp','Programming',200.00);

INSERT INTO purchases VALUES
(1001,1,101,1,'2025-01-10'),
(1002,1,102,2,'2025-01-15'),
(1003,2,103,1,'2025-02-01'),
(1004,2,104,1,'2025-02-05'),
(1005,3,101,3,'2025-02-10'),
(1006,4,105,1,'2025-03-01'),
(1007,5,102,1,'2025-03-10'),
(1008,5,103,2,'2025-03-15');

-- Combine learner, course, and purchase data.
SELECT
	l.learner_id, l.full_name AS learner_name, l.country AS learner_country,
    c.course_id, c.course_name, c.category, c.unit_price AS course_price,
    p.purchase_id, p.quantity,
    FORMAT(p.quantity * c.unit_price, 2) AS total_amount,
    p.purchase_date
FROM purchases p
INNER JOIN learners l
    ON p.learner_id = l.learner_id
INNER JOIN courses c
    ON p.course_id = c.course_id
ORDER BY total_amount DESC;

-- Display each learner’s purchase details (course name, category, quantity, total amount, and purchase date).
SELECT
    c.course_name AS course_name,
    c.category AS course_category,
    p.quantity AS quantity_purchased,
    FORMAT(p.quantity * c.unit_price, 2) AS total_amount,
    p.purchase_date AS purchase_date
FROM purchases p
JOIN learners l
    ON p.learner_id = l.learner_id
JOIN courses c
    ON p.course_id = c.course_id
ORDER BY p.purchase_date DESC;

-- Analytical Queries
-- Q1. Display each learner’s total spending (quantity × unit_price) along with their country
SELECT
    l.full_name AS learner_name,
    l.country AS learner_country,
    FORMAT(SUM(p.quantity * c.unit_price), 2) AS total_spending
FROM learners l
JOIN purchases p
    ON l.learner_id = p.learner_id
JOIN courses c
    ON p.course_id = c.course_id
GROUP BY l.learner_id, l.full_name, l.country
ORDER BY SUM(p.quantity * c.unit_price) DESC;

-- Q2. Find the top 3 most purchased courses based on total quantity sold
SELECT
    c.course_name,
    SUM(p.quantity) AS total_quantity_sold
FROM courses c
JOIN purchases p
    ON c.course_id = p.course_id
GROUP BY c.course_id, c.course_name
ORDER BY total_quantity_sold DESC
LIMIT 3;

-- Q3. Show each course category’s total revenue and the number of unique learners who purchased from that category.
SELECT
    c.category AS course_category,
    FORMAT(SUM(p.quantity * c.unit_price), 2) AS total_revenue,
    COUNT(DISTINCT p.learner_id) AS unique_learners
FROM courses c
JOIN purchases p
    ON c.course_id = p.course_id
GROUP BY c.category
ORDER BY SUM(p.quantity * c.unit_price) DESC;

-- Q4. List all learners who have purchased courses from more than one category.
SELECT
    l.full_name AS learner_name,
    COUNT(DISTINCT c.category) AS categories_purchased
FROM learners l
JOIN purchases p
    ON l.learner_id = p.learner_id
JOIN courses c
    ON p.course_id = c.course_id
GROUP BY l.learner_id, l.full_name
HAVING COUNT(DISTINCT c.category) > 1
ORDER BY categories_purchased DESC,
         learner_name;
         
-- Q5. Identify courses that have not been purchased at all.
SELECT
    c.course_id,
    c.course_name,
    c.category AS course_category,
    FORMAT(c.unit_price, 2) AS unit_price
FROM courses c
LEFT JOIN purchases p
    ON c.course_id = p.course_id
WHERE p.purchase_id IS NULL
ORDER BY c.course_name;

select * from courses;
select * from purchases;
select * from learners;      


