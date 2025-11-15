/*
----------Silver layer Schema tables' creation script.---------------
One staging table > Ugacooq_stg
Four other tables > ugacooq_members, ugacooq_contact_info, ugacooq_employment and ugacooq_next_of_kin

Note:
    Script will delete all the tables and re create them if run, Please run only after backup.
*/


--- staging table creation
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

--- members table creation
IF OBJECT_ID('silver.ugacooq_members') IS NOT NULL
    DROP TABLE silver.ugacooq_members
GO

CREATE TABLE silver.ugacooq_members(
    row_hash VARCHAR(255),
    ugacoq_id VARCHAR(50),
    full_name VARCHAR(100),
    dob DATE,
    gender VARCHAR(10),
    place_of_birth VARCHAR(50),
    marital_status VARCHAR(50),
    recruitment_mechanism VARCHAR(50),
    recruitment_agency VARCHAR(50),
    talent_or_skill VARCHAR(225)
);

--- contact_info table creation
IF OBJECT_ID('silver.ugacooq_contact_info') IS NOT NULL
    DROP TABLE silver.ugacooq_contact_info
GO

CREATE TABLE silver.ugacooq_contact_info(
    row_hash VARCHAR(255),
    email VARCHAR(100),
    qatar_phone VARCHAR(100),
    alt_phone VARCHAR(100),
    qid_or_visa_number VARCHAR(50),
    visa_status VARCHAR(50),
    physical_address VARCHAR(50),
    date_of_entry DATE
);

--- employment table creation
IF OBJECT_ID('silver.ugacooq_employment') IS NOT NULL
    DROP TABLE silver.ugacooq_employment
GO

CREATE TABLE silver.ugacooq_employment(
    row_hash VARCHAR(255),
    employment_status BIT,
    employer_name VARCHAR(100),
    employer_address VARCHAR(100),
    industry VARCHAR(50),
    job_role VARCHAR(50),
    employer_phone VARCHAR(50),
    employer_email VARCHAR(50),
    contract_duration INT
);

--- next_of_kin table creation
IF OBJECT_ID('silver.next_of_kin') IS NOT NULL
    DROP TABLE silver.ugacooq_next_of_kin
GO

CREATE TABLE silver.ugacooq_next_of_kin(
row_hash VARCHAR(255),
name VARCHAR(100),
phone VARCHAR(100),
relatioship VARCHAR(100),
address VARCHAR(50)
);
