WITH raw_source AS (
    SELECT * FROM {{ source('project_dentist', 'raw_practice_place')}}
),

cleaned_data AS (
    SELECT
        no_str,
        sip AS no_sip,
        terbit AS tgl_terbit,
        berakhir AS tgl_berakhir,

        -- Regex replace these [.,\-''"] into this ' '
        -- Nuliff convert - value into null
        NULLIF(TRIM(REGEXP_REPLACE(
            REGEXP_REPLACE(tempat, '[.,\-''"]', ' ', 'g'),
            '\s+', ' ', 'g')), '') as tempat_praktek,

        kota,
        provinsi   

    FROM raw_source
)

SELECT DISTINCT ON (no_str, tempat_praktek) -- Remove duplicate on tempat_praktek column
    *
FROM cleaned_data

ORDER BY 
    no_str, 
    tempat_praktek, 
    NULLIF(tgl_terbit, '-') DESC NULLS LAST