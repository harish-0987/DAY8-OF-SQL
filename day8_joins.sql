-- ====================================================================
-- DAY 8 OF SQL: SQL JOINS - HANDS-ON PRACTICE
-- Topic: INNER, LEFT, RIGHT, FULL, CROSS & SELF JOINS (Few Clean Queries)
-- ====================================================================

-- 1. Setup Database & Sample Tables
CREATE DATABASE IF NOT EXISTS day8_db;
USE day8_db;

DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS departments;

-- Parent Table: Departments
CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50) NOT NULL
);

-- Child Table: Employees (Includes manager_id for SELF JOIN)
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50) NOT NULL,
    salary DECIMAL(10, 2) NOT NULL,
    dept_id INT,
    manager_id INT
);

-- 2. Insert Sample Records
-- Notice: Marketing has no employees; Harish has no department (dept_id = NULL)
INSERT INTO departments (dept_id, dept_name) VALUES
(1, 'Engineering'),
(2, 'Human Resources'),
(3, 'Finance'),
(4, 'Marketing');       -- Department with NO employees

INSERT INTO employees (emp_id, emp_name, salary, dept_id, manager_id) VALUES
(101, 'Harish',  95000.00, NULL, NULL),   -- Employee with NO department (CEO)
(102, 'Rahul',   80000.00, 1,    101),    -- Reports to Harish
(103, 'Priya',   60000.00, 2,    101),    -- Reports to Harish
(104, 'Amit',    75000.00, 1,    102),    -- Reports to Rahul
(105, 'Sneha',   70000.00, 3,    101);    -- Reports to Harish

-- --------------------------------------------------------------------
-- QUERY 1: INNER JOIN (Only Matching Records in Both Tables)
-- --------------------------------------------------------------------
-- Returns only employees assigned to an existing department
SELECT 
    e.emp_id,
    e.emp_name,
    d.dept_name,
    e.salary
FROM employees e
INNER JOIN departments d ON e.dept_id = d.dept_id;

-- --------------------------------------------------------------------
-- QUERY 2: LEFT JOIN (All Left Records + Matching Right Records)
-- --------------------------------------------------------------------
-- Returns ALL employees, even if they have no department (dept_name will be NULL)
SELECT 
    e.emp_id,
    e.emp_name,
    COALESCE(d.dept_name, 'No Department Assigned') AS dept_name,
    e.salary
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id;

-- --------------------------------------------------------------------
-- QUERY 3: RIGHT JOIN (All Right Records + Matching Left Records)
-- --------------------------------------------------------------------
-- Returns ALL departments, even if no employee works in them (Marketing appears with NULL)
SELECT 
    d.dept_id,
    d.dept_name,
    e.emp_name,
    e.salary
FROM employees e
RIGHT JOIN departments d ON e.dept_id = d.dept_id;

-- --------------------------------------------------------------------
-- QUERY 4: FULL OUTER JOIN (All Records from Both Tables)
-- --------------------------------------------------------------------
-- In MySQL, emulate FULL OUTER JOIN by combining LEFT JOIN and RIGHT JOIN with UNION:
SELECT e.emp_id, e.emp_name, d.dept_name
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id
UNION
SELECT e.emp_id, e.emp_name, d.dept_name
FROM employees e
RIGHT JOIN departments d ON e.dept_id = d.dept_id;

-- --------------------------------------------------------------------
-- QUERY 5: CROSS JOIN (Cartesian Product - All Combinations)
-- --------------------------------------------------------------------
-- Pairs every employee with every department
SELECT e.emp_name, d.dept_name
FROM employees e
CROSS JOIN departments d;

-- --------------------------------------------------------------------
-- QUERY 6: SELF JOIN (Joining a Table with Itself)
-- --------------------------------------------------------------------
-- Display each employee alongside their manager's name
SELECT 
    emp.emp_name AS employee,
    COALESCE(mgr.emp_name, 'Top Level (No Manager)') AS manager
FROM employees emp
LEFT JOIN employees mgr ON emp.manager_id = mgr.emp_id;
