/* 
=================================================================
Create Database Schemas and the bronze
=================================================================
Script purpose:
    This script creates the new schemas (Bronze,Silver & Gold) in the already created database named 'UGACOOQDB'.
    Also creates a table in the bronze layer called 'ugacooq_raw' after checking if the table exists.
    If the table exists in, its dropped and recreated.

Warning:
    Running this script will delete the ugacooq_raw table. Please proceed with caustion or make sure you have abackup
    before runing the script.

*/

---switch to the UGACOOQ Database
USE UGACOOQDB;

---Create schemas
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO

---Drop and recreate the ugacooq_raw table
IF OBJECT_ID('bronze.ugacooq_raw') IS NOT NULL
    DROP TABLE bronze.ugacooq_raw;
GO

CREATE TABLE bronze.ugacooq_raw (
    id INT IDENTITY(1,1) PRIMARY KEY,
    ingested_at DATETIME2 NOT NULL,
    source_sheet NVARCHAR(255),
    source_row INT,
    payload NVARCHAR(MAX),  
    row_hash CHAR(64) NOT NULL,
    ingest_batch_id UNIQUEIDENTIFIER NOT NULL
);

