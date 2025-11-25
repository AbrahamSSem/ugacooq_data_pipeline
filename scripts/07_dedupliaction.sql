/*
==================== PROCEDURE OVERVIEW =======================================

This procedure handles duplicate records in the staging table (silver.ugacooq_stg). 
From data exploration, duplicates exist because users sometimes re-register trying to update 
their details, generating multiple entries per Passport Number. Each new entry 
creates a new REG (registration) ID. 

Key Assumptions:
1. For each Passport Number, the latest entry (highest source_row) contains the most 
   up-to-date information.
2. Some  duplicated Passport Number entries may have more than two entries, but the vast majority of 
   updates are reflected in the two most recent entries. Therefore, the procedure 
   only compares rn = 1 (latest) and rn = 2 (second latest) for deduplication. 
   Some cases (very rare) with more than two entries are assumed to have identical information, 
   so processing beyond the two latest rows is unnecessary.
3. Email cleaning logic is applied to ensure correctness: if two emails differ, 
   but one appears malformed (e.g., missing proper domain like ".com"), only the 
   correct one is retained; otherwise, both are concatenated.
4. Deduplication is based on Passport Number, with additional checks for Full Name, 
   DOB, Place of Birth, and Date of Entry in Qatar.

Procedure Steps:
1. Assign ROW_NUMBER() over each Passport Number ordered by source_row DESC to 
   identify the latest and second latest entries.
2. Identify duplicates by Passport Number.
3. Deduplicate the duplicates by applying the email cleaning logic and other columns
4. Merge the deduplicated results back into the silver staging table.
5. Delete all older duplicate rows, keeping only the latest (rn = 1) record per 
   Passport Number.

The result is a staging table containing only the latest, cleaned, deduplicated 
records for each Passport Number.
*/
 
CREATE OR ALTER PROCEDURE deduplicate_merge_back_to_silver_stg AS
BEGIN
    BEGIN TRY

PRINT'-----------Duplicate check and cleaning process----------------'

        WITH duplicate AS (
            SELECT *,
                   ROW_NUMBER() OVER(PARTITION BY [Passport Number] ORDER BY source_row DESC) AS rn
            FROM silver.ugacooq_stg
            WHERE [Passport Number] IS NOT NULL AND [Passport Number] <> ''
        ), duplicates_rows AS (
            SELECT *
            FROM duplicate
            WHERE [Passport Number] IN (
                SELECT [Passport Number]
                FROM duplicate
                GROUP BY [Passport Number]
                HAVING COUNT([Passport Number]) > 1
            )
        ), duplicated AS (
            SELECT dr1.*,
            --- email checks, some entries have two emails in the first entry and different on the second entry, 
            -- some emails are wrong, since we need personal emails, only .com was take
                CASE
                    WHEN (dr1.Email LIKE '%@%.com') AND (dr2.Email NOT LIKE '%@%.com') THEN LTRIM(RTRIM(dr1.Email)) -- 1st entry email correct, 2nd entry wrong
                    WHEN (dr2.Email LIKE '%@%.com') AND (dr1.Email NOT LIKE '%@%.com') THEN LTRIM(RTRIM(dr2.Email))-- 1st entry email wrong, 2nd entry correct
                    -- if both emails are correct then concat them together
                    WHEN (dr1.Email LIKE '%@%.com') AND (dr2.Email LIKE '%@%.com') AND dr1.Email <> dr2.Email THEN LTRIM(RTRIM(dr1.Email)) + '; ' + LTRIM(RTRIM(dr2.Email))
                    WHEN dr1.Email <> dr2.Email THEN LTRIM(RTRIM(dr1.Email)) + '; ' + LTRIM(RTRIM(dr2.Email))
                    ELSE LTRIM(RTRIM(dr1.Email))
                END AS email_final,
                COALESCE(LTRIM(RTRIM(dr1.[Full Name])), LTRIM(RTRIM(dr2.[Full Name]))) AS full_name,
                CASE
                    WHEN TRY_CAST(dr1.dob AS DATE) < TRY_CAST(dr2.dob AS DATE) THEN dr1.dob 
                    ELSE dr2.dob 
                END AS dob_final,
                CASE
                    WHEN LTRIM(RTRIM(dr1.[Place of Birth])) <> LTRIM(RTRIM(dr2.[Place of Birth])) THEN LTRIM(RTRIM(dr2.[Place of Birth]))
                    ELSE LTRIM(RTRIM(dr1.[Place of Birth]))
                END AS pob,
                CASE
                    WHEN TRY_CAST(dr1.[Date of Entry in Qatar] AS DATE) <> TRY_CAST(dr2.[Date of Entry in Qatar] AS DATE) THEN TRY_CAST(dr1.[Date of Entry in Qatar] AS DATE)
                    ELSE TRY_CAST(dr2.[Date of Entry in Qatar] AS DATE)
                END AS doe
            FROM duplicates_rows dr1
            LEFT JOIN duplicates_rows dr2
                ON dr1.[Passport Number] = dr2.[Passport Number] AND dr1.rn = 1 AND dr2.rn = 2
            WHERE dr1.rn = 1
        )
        SELECT * INTO #DuplicatedDuplicates FROM duplicated; --dedups in the a temp table

PRINT'-----------merged dedups back to stagging table----------------'

        --Merge the dedups back into staging table--
        MERGE INTO silver.ugacooq_stg AS target
        USING #DuplicatedDuplicates AS source --temp table storing the dedups
        ON target.[Passport Number] = source.[Passport Number]
        WHEN MATCHED THEN
            UPDATE SET
                target.[Full Name] = source.full_name,
                target.[dob] = source.dob_final,
                target.[Email] = source.email_final,
                target.[Place of Birth] = source.pob,
                target.[Date of Entry in Qatar] = source.doe
        WHEN NOT MATCHED BY TARGET THEN
            INSERT ([Full Name], [dob], [Email], [Place of Birth],[Date of Entry in Qatar])
            VALUES (source.full_name, source.dob_final, source.email_final, source.pob, source.doe);

PRINT'-------------------removed all duplicates from the stagging table------------'

        --remove all duplicated rows and remain with only cleaned deduplicated rows on the latest etry
        WITH Ranked AS (
            SELECT *,
                   ROW_NUMBER() OVER (
                       PARTITION BY [Passport Number]
                       ORDER BY source_row DESC 
                   ) AS rn
            FROM silver.ugacooq_stg
            WHERE [Passport Number] IS NOT NULL AND [Passport Number] <> ''
        )
        DELETE FROM Ranked
        WHERE rn > 1; 

        DROP TABLE #DuplicatedDuplicates -- drop the temp table
    END TRY
    BEGIN CATCH
    PRINT'============================================================';
    PRINT'ERROR OCURRED DURING EXTRACTION & lOADING STAGING TABLE';
    PRINT'Error message:' + error_message()
    PRINT'Error message number:'+ cast(error_number() as nvarchar(20))
    END CATCH    
END;
