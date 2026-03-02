WITH doctors AS (
    SELECT * FROM {{ ref('stg_dentist') }}
),

practices AS (
    SELECT * FROM {{ ref('stg_practice_place') }}
)

SELECT
    d.no_berkas,
    d.nama,
    d.kualifikasi,
    d.kualifikasi_tambahan,
    p.tempat_praktek,
    p.kota,
    p.provinsi

FROM doctors d

LEFT JOIN practices p
    ON d.no_str = p.no_str

WHERE d.kualifikasi LIKE '%Spesialis%'