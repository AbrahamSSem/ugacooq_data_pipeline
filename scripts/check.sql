DECLARE @json NVARCHAR(MAX); 
DECLARE @columns NVARCHAR(MAX) = ''; --column list varriable
       
-- set a json sample with the first row of the payload column
SELECT TOP 1 @json = payload 
FROM bronze.ugacooq_raw 
WHERE payload IS NOT NULL;

-- create a dynamic column list for for the insert. (just the keys) 
SELECT @columns = STRING_AGG('[' + [key] + ']', ', ') --combines all column headers/keys into a single string.
FROM OPENJSON(@json)
WHERE [key] IS NOT NULL AND LTRIM(RTRIM([key])) <> ''; -- remove all empty header columns 

select *
from string_split(@columns,',');

IF OBJECT_ID('silver.ugacooq_stg') IS NOT NULL
    DROP TABLE silver.ugacooq_stg
GO

CREATE TABLE silver.ugacooq_stg (
    source_row VARCHAR(100),
    row_hash VARCHAR(255),
    ingest_batch_id VARCHAR(255),
    [REG] VARCHAR(100),
    [Email] VARCHAR(255),
    [Full Name] VARCHAR(255),
    [dob] VARCHAR(100),
    [Gender] VARCHAR(100),
    [Place of Birth] VARCHAR(255),
    [Phone number (in Qatar)] VARCHAR(100),
    [Alternative Contact Number] VARCHAR(100),
    [Passport Number] VARCHAR(150),
    [Qatar ID / Visa Number] VARCHAR(150),
    [Date of Entry in Qatar] VARCHAR(100),
    [Visa Status] VARCHAR(150),
    [If selected Other, provide details] VARCHAR(2255),
    [Recruitment Mechanism] VARCHAR(100),
    [If selected Recruitment Agency, provide name of Agency] VARCHAR(2255),
    [Marital Status] VARCHAR(150),
    [Physical Address in Qatar] VARCHAR(1255),
    [Name of Next of Kin] VARCHAR(1255),
    [Phone Number of Next of Kin] VARCHAR(1120),
    [Relatioship with Next of Kin] VARCHAR(1150),
    [Address of Next of Kin] VARCHAR(255),
    [Employment Status] VARCHAR(150),
    [Name of Employer] VARCHAR(255),
    [Address of Employer (Qatar)] VARCHAR(1255),
    [Industry / Sector of Employment] VARCHAR(1100),
    [Job Role / Position] VARCHAR(1100),
    [Employer Phone number] VARCHAR(100),
    [Employer Email Address] VARCHAR(255),
    [Duration of Contract] VARCHAR(150),
    [Talents, Skills, Areas of expertise] VARCHAR(1800),
    [Profile] VARCHAR(255),
    [Status] VARCHAR(150),
    [Confirm] VARCHAR(1255),   
    [UGACOQ ID]VARCHAR(160),
    [NAMES]VARCHAR(160),
    [JOB TYPE]VARCHAR(160),
    [DISCRIPTION]VARCHAR(1000),
    [OTHERS]VARCHAR(100),
    [UGACOQ ID NU]VARCHAR(100),
    [BUSSINESS NAME]VARCHAR(100),
    [LOCATION]VARCHAR(100),
    [OPEN TIME]VARCHAR(100),
    [CLOSE TIME]VARCHAR(100),
    [SHORT DISCRIP]VARCHAR(255),
    [CATEGORIES]VARCHAR(100),
    [CALL NUMBER]VARCHAR(100)
);

