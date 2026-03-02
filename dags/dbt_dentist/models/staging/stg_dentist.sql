WITH raw_source AS (
    SELECT * FROM {{ source('project_dentist', 'raw_dentist')}}
)

SELECT
    "No Berkas" AS no_berkas,
    "Nama" AS nama,
    "Jenis Kelamin" AS jenis_kelamin,
    "Universitas" AS universitas,
    "Kualifikasi" AS kualifikasi,
    "Kualifikasi Tambahan" AS kualifikasi_tambahan,
    "Nomor STR" AS no_str,
    "Tgl Penetapan" AS tgl_penetapan,
    "Berlaku Sampai" AS berlaku_sampai,

    CASE
        WHEN "Berlaku Sampai" = 'Seumur Hidup' THEN 'Aktif'
        WHEN "Berlaku Sampai" LIKE '%PPDS/PPDGS%' THEN 'PPDGS'
        WHEN "Berlaku Sampai" LIKE '%internsip%' THEN 'Internsip'
        
        WHEN "Berlaku Sampai" ~ '^\d{2} [A-Za-z]{3} \d{4}$' 
         AND TO_DATE("Berlaku Sampai", 'DD Mon YYYY') >= CURRENT_DATE THEN 'Aktif'

        ELSE 'Tidak Aktif'
    END AS status_str,

    "Status" AS status

FROM raw_source