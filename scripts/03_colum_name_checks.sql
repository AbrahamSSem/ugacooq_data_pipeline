/*
Checking for the columns which i used to create the ugacooq_stg table from the payload
*/

DECLARE @json NVARCHAR(MAX);
DECLARE @column NVARCHAR(MAX) = '';

SELECT TOP 1 @json = payload FROM bronze.ugacooq_raw -- set @json as top row in the payload column.
where payload is not null;

select @column = STRING_AGG('[' + [key] + ']',',') -- set @column as a string aggreagate all the column names 
from openjson(@json)
where [key] is not null AND LTRIM(RTRIM([key])) <> '';

-- check out the columns
select @column;