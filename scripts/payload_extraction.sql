/*
This procedure extracts the payload column along with metadata dynamically.
*/

CREATE PROCEDURE usp_extract_ugacooq_payload
AS
BEGIN
DECLARE @json NVARCHAR(MAX);
DECLARE @sql NVARCHAR(MAX) = '';

SELECT TOP 1 @json = payload 
FROM bronze.ugacooq_raw 
WHERE payload IS NOT NULL;


SELECT @sql = STRING_AGG(
    'JSON_VALUE(payload,''$."' + REPLACE([key],'"','\"') + '"'' ) AS [' + [key] + ']', --cont the json value extraction
    ', '
)
FROM OPENJSON(@json)
WHERE [key] IS NOT NULL AND LTRIM(RTRIM([key])) <> '';

SET @sql = '
SELECT source_row,
       row_hash,
       ingest_batch_id,
       ' + @sql + '
FROM bronze.ugacooq_raw
WHERE payload IS NOT NULL;';

EXEC sp_executesql @sql;
END;