DECLARE @json NVARCHAR(MAX);
DECLARE @sql NVARCHAR(MAX) = '';

-- get a sample payload
SELECT TOP 1 @json = payload 
FROM bronze.ugacooq_raw 
WHERE payload IS NOT NULL;

-- build dynamic SQL safely
SELECT @sql = STRING_AGG(
    'JSON_VALUE(payload,''$."' + REPLACE([key],'"','\"') + '"'' ) AS [' + [key] + ']', 
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

-- execute
EXEC sp_executesql @sql;
