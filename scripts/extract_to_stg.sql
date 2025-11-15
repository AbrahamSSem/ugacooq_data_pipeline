/*
This procedure script, extracts the payload json column from the bronze layer table and loads the contents into a silver layer temp
table.

Its accounts for the errors should any arise by printing out the error message and number. The extraction and insertion is dynamic.
Only 47 columns are extracted from the payload plus and additional 3 of metadata from the orginal table.
*/

CREATE OR ALTER PROCEDURE silver.load_staging_temp_table
AS
BEGIN
    BEGIN TRY
        DECLARE @json NVARCHAR(MAX); 
        DECLARE @columns NVARCHAR(MAX) = ''; --column list varriable
        DECLARE @select NVARCHAR(MAX) = ''; --seslct variable for dynamic extraction
        DECLARE @sql NVARCHAR(MAX) = '';

        -- set a json sample with the first row of the payload column
        SELECT TOP 1 @json = payload 
        FROM bronze.ugacooq_raw 
        WHERE payload IS NOT NULL;

        -- create a dynamic column list for for the insert. (just the keys) 
        SELECT @columns = STRING_AGG('[' + [key] + ']', ', ') --combines all column headers/keys into a single string.
        FROM OPENJSON(@json)
        WHERE [key] IS NOT NULL AND LTRIM(RTRIM([key])) <> ''; -- remove all empty header columns 

    
        PRINT'>> Extracts the payload column from: bronze.ugacooq_raw <<';
    
        SELECT @select = STRING_AGG(
            'JSON_VALUE(payload,''$."' + REPLACE([key],'"','\"') + '"'' ) AS [' + [key] + ']', -- replace the single quotes for the keys and concat them.
            ', '
        )
        FROM OPENJSON(@json)
        WHERE [key] IS NOT NULL AND LTRIM(RTRIM([key])) <> ''; 


        PRINT'>> Inserts the extracted keys info into: silver.ugacooq_stg <<';
  
        SET @sql = '
        INSERT INTO silver.ugacooq_stg (source_row,row_hash,ingest_batch_id,' + @columns + ') 
        SELECT
            source_row,
            row_hash,
            ingest_batch_id,
            ' + @select + '
        FROM bronze.ugacooq_raw
        WHERE payload IS NOT NULL;';

        -- excute the query to laod into the silver staging table
        EXEC sp_executesql @sql;
    END TRY
    BEGIN CATCH
    PRINT'============================================================';
    PRINT'ERROR OCURRED DURING EXTRACTION & lOADING STAGING TABLE';
    PRINT'Error message:' + error_message()
    PRINT'Error message number:'+ cast(error_number() as nvarchar(20))
    END CATCH
END;

