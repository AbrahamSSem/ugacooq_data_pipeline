CREATE SCHEMA bronze;
GO


CREATE TABLE bronze.members_raw (
    id INT IDENTITY(1,1) PRIMARY KEY,
    ingested_at DATETIME2 NOT NULL,
    source_sheet NVARCHAR(255),
    source_row INT,
    payload NVARCHAR(MAX),  
    row_hash CHAR(64) NOT NULL,
    ingest_batch_id UNIQUEIDENTIFIER NOT NULL
);
GO


