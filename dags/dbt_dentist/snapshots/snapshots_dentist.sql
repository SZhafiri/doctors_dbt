{% snapshot doctors_snapshot %}

{{
    config(
      target_schema='snapshots',         
      unique_key='no_berkas',            
      strategy='check',               
      check_cols=['nama', 'kualifikasi', 'kualifikasi_tambahan', 
                'no_str', 'status_str']
    )
}}

SELECT * FROM {{ ref('stg_dentist') }}

{% endsnapshot %}