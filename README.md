# SQL Practice with MySQL & Sakila Database

This repository contains my SQL practice using the **Sakila** sample database in **MySQL Workbench**.  
The goal of this task is to learn and apply:

- Basic `SELECT` queries  
- Joins (`INNER`, `LEFT`, `RIGHT`)  
- Subqueries  
- Aggregate functions (`SUM`, `AVG`, etc.)  
- Views for analysis  
- Query optimization using indexes  

---

## 🛠 Prerequisites

- MySQL Server
- MySQL Workbench
- Sakila sample database installed in MySQL (schema + data)

> The main SQL file in this repo assumes the database name is `sakila`.

---

## 📂 Files in This Repository

- `sakila_analysis` – contains all the Data, Schema, SQL queries I wrote for this task:
  - Basic SELECT queries
  - JOIN queries
  - Subqueries
  - Aggregation queries (SUM, AVG, COUNT, etc.)
  - Creating views
  - Creating indexes for optimization

---

## ▶️ How to Run the SQL Script

1. Open **MySQL Workbench**.
2. Connect to your MySQL server.
3. Make sure the **Sakila** database is available:
   ```sql
   USE sakila;

