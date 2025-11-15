declare @json nvarchar(max);

select TOP 10 @json = payload from bronze.ugacooq_raw

select *
from openjson(@json)



select *
from bronze.ugacooq_raw