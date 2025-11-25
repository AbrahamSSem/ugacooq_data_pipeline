/*
Procedure loads the bronzeRaw_metadata table.
*/

CREATE OR ALTER PROCEDURE load_bronzeRaw_metadata
AS
BEGIN
    BEGIN TRY
        INSERT INTO bronze.ugacooqRaw_metadata (batch_id, ingested_at, number_of_rows, first_row, last_row)
        SELECT 
            r.ingest_batch_id AS batch_id,
            r.ingested_at AS ingested_at,
            COUNT(r.source_row) AS number_of_rows,
            MIN(r.source_row) AS first_row,
            MAX(r.source_row) AS last_row
        FROM bronze.ugacooq_raw r
        --only load the batches that havent been loaded.
        LEFT JOIN bronze.ugacooqRaw_metadata m
            ON r.ingest_batch_id = m.batch_id
        WHERE m.batch_id IS NULL
        GROUP BY r.ingest_batch_id, r.ingested_at;

        PRINT 'Bronze raw metadata loaded successfully for new batches only.';
    END TRY
    BEGIN CATCH
        PRINT '============================================================';
        PRINT 'ERROR OCCURRED DURING BRONZE RAW METADATA LOAD';
        PRINT 'Error message: ' + ERROR_MESSAGE();
        PRINT 'Error number: ' + CAST(ERROR_NUMBER() AS NVARCHAR(20));
    END CATCH
END;



  EXEC load_bronzeRaw_metadata

