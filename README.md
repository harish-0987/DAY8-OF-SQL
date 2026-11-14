# 📘 Day 8 of SQL: Mastering SQL Joins

Welcome to **Day 8 of SQL**! 🚀

In relational databases, data is split across multiple normalized tables to eliminate redundancy. **SQL Joins** are the fundamental mechanism used to combine and query data from two or more related tables based on a common key.

---

## 📑 Table of Contents
1. [What is an SQL JOIN?](#1-what-is-an-sql-join)
2. [Visual Guide to SQL Joins](#2-visual-guide-to-sql-joins)
3. [Types of SQL Joins](#3-types-of-sql-joins)
   - [1. INNER JOIN](#1-inner-join)
   - [2. LEFT JOIN (LEFT OUTER JOIN)](#2-left-join-left-outer-join)
   - [3. RIGHT JOIN (RIGHT OUTER JOIN)](#3-right-join-right-outer-join)
   - [4. FULL JOIN (FULL OUTER JOIN)](#4-full-join-full-outer-join)
   - [5. CROSS JOIN](#5-cross-join)
   - [6. SELF JOIN](#6-self-join)
4. [Finding Unmatched Records (Anti-Joins)](#4-finding-unmatched-records-anti-joins)
5. [Hands-on Practice Script (A Few Clean Queries)](#5-hands-on-practice-script-a-few-clean-queries)
6. [Summary Cheat Sheet](#6-summary-cheat-sheet)

---

## 1. What is an SQL JOIN?

An **SQL JOIN** is a clause used to query and combine rows from two or more tables based on a related column between them (typically linking a **Foreign Key** in a child table to a **Primary Key** in a parent table).

```
   Employees Table                    Departments Table
┌─────────┬─────────┬─────────┐      ┌─────────┬─────────────┐
│ emp_id  │ name    │ dept_id │      │ dept_id │ dept_name   │
├─────────┼─────────┼─────────┤      ├─────────┼─────────────┤
│ 102     │ Rahul   │ 1       │ ───► │ 1       │ Engineering │
│ 103     │ Priya   │ 2       │ ───► │ 2       │ HR          │
└─────────┴─────────┴─────────┘      └─────────┴─────────────┘
```

---

## 2. Visual Guide to SQL Joins

```
   INNER JOIN               LEFT JOIN               RIGHT JOIN
   Matching only          All Left + Matched      All Right + Matched
   ┌───┐     ┌───┐        ┌───┐     ┌───┐         ┌───┐     ┌───┐
  │     │ █ │     │      │ ███ │ █ │     │       │     │ █ │ ███ │
   └───┘     └───┘        └───┘     └───┘         └───┘     └───┘
   Table A   Table B      Table A   Table B       Table A   Table B

   FULL OUTER JOIN          CROSS JOIN               SELF JOIN
   All from Both Sides    Cartesian Product (N x M)  Table joined with itself
   ┌───┐     ┌───┐        ┌───┐     ┌───┐         ┌───────────┐
  │ ███ │ █ │ ███ │      │ All │ x │ All │       │ Employees │ (Emp -> Mgr)
   └───┘     └───┘        └───┘     └───┘         └───────────┘
```

---

## 3. Types of SQL Joins

### 1. INNER JOIN
Returns **only records that have matching values in both tables**. Any row without a match on either side is excluded.

```sql
SELECT e.emp_name, d.dept_name, e.salary
FROM employees e
INNER JOIN departments d ON e.dept_id = d.dept_id;
```
- **When to use**: When you only want valid, fully related records (e.g., active orders with matching customer profiles).

---

### 2. LEFT JOIN (LEFT OUTER JOIN)
Returns **all records from the left table**, and the matched records from the right table. If there is no match, the right side returns `NULL`.

```sql
SELECT e.emp_name, COALESCE(d.dept_name, 'Unassigned') AS dept_name
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id;
```
- **When to use**: When you want to keep all records from your primary table regardless of whether they have matching foreign references (e.g., all customers, including those who have never placed an order).

---

### 3. RIGHT JOIN (RIGHT OUTER JOIN)
Returns **all records from the right table**, and the matched records from the left table. If there is no match, the left side returns `NULL`.

```sql
SELECT d.dept_name, e.emp_name
FROM employees e
RIGHT JOIN departments d ON e.dept_id = d.dept_id;
```
- **When to use**: When you want all entries from the lookup/parent table, even those without associated child rows (e.g., all product categories, including empty categories).

---

### 4. FULL JOIN (FULL OUTER JOIN)
Returns **all records when there is a match in either left or right table**. Rows without matches on either side will have `NULL` values.

- *PostgreSQL / SQL Server / Oracle*:
  ```sql
  SELECT e.emp_name, d.dept_name
  FROM employees e
  FULL OUTER JOIN departments d ON e.dept_id = d.dept_id;
  ```
- *MySQL (Emulation using UNION)*:
  ```sql
  SELECT e.emp_name, d.dept_name
  FROM employees e
  LEFT JOIN departments d ON e.dept_id = d.dept_id
  UNION
  SELECT e.emp_name, d.dept_name
  FROM employees e
  RIGHT JOIN departments d ON e.dept_id = d.dept_id;
  ```

---

### 5. CROSS JOIN
Produces the **Cartesian product** of both tables — it pairs every single row of Table A with every single row of Table B ($Rows_A \times Rows_B$).

```sql
SELECT e.emp_name, d.dept_name
FROM employees e
CROSS JOIN departments d;
```
- **When to use**: Generating matrix combinations (e.g., all shirt sizes $\times$ all shirt colors).

---

### 6. SELF JOIN
A regular join where **a table is joined with itself**. Useful when a table contains hierarchical or recursive relationships (e.g., employees and their managers stored in the same table).

```sql
SELECT 
    emp.emp_name AS employee,
    COALESCE(mgr.emp_name, 'CEO / Top Level') AS manager
FROM employees emp
LEFT JOIN employees mgr ON emp.manager_id = mgr.emp_id;
```

---

## 4. Finding Unmatched Records (Anti-Joins)

You can easily find orphaned or unlinked records by combining an outer join with `WHERE ... IS NULL`:

```sql
-- Find departments that have NO employees
SELECT d.dept_name
FROM departments d
LEFT JOIN employees e ON d.dept_id = e.dept_id
WHERE e.emp_id IS NULL;
```

---

## 5. Hands-on Practice Script (A Few Clean Queries)

Run the companion SQL practice file [day8_joins.sql](day8_joins.sql) in your database environment (MySQL, PostgreSQL, DBeaver, or CLI).

It contains:
1. Creating `departments` and `employees` tables with realistic sample data
2. Query 1: `INNER JOIN`
3. Query 2: `LEFT JOIN` (with `COALESCE` for NULL handling)
4. Query 3: `RIGHT JOIN`
5. Query 4: `FULL OUTER JOIN` (MySQL-compatible `UNION`)
6. Query 5: `CROSS JOIN`
7. Query 6: `SELF JOIN` (Employee-to-Manager hierarchy)

---

## 6. Summary Cheat Sheet

| Join Type | Left Table Rows | Right Table Rows | Unmatched Handling |
| :--- | :--- | :--- | :--- |
| **INNER JOIN** | Only matches | Only matches | Excluded |
| **LEFT JOIN** | **ALL** rows | Only matches | Right columns filled with `NULL` |
| **RIGHT JOIN** | Only matches | **ALL** rows | Left columns filled with `NULL` |
| **FULL JOIN** | **ALL** rows | **ALL** rows | Missing columns filled with `NULL` |
| **CROSS JOIN** | Every row | Every row | Cartesian Product ($N \times M$) |
| **SELF JOIN** | Joined with itself | Joined with itself | Uses table aliasing (`e1`, `e2`) |

---

⭐ **Stay tuned for Day 9!** Keep practicing and writing queries.
