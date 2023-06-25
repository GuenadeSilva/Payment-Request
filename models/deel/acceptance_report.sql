-- Transformation Model
WITH
acceptance as (
    select 
    r.*,
    CASE WHEN
        currency = 'USD' THEN amount
        ELSE amount * CAST(JSON_VALUE(rates,'$.USD') AS FLOAT64) END AS amount_usd

    from {{ ref('stg_acceptance_report') }} r
),

charge_back as (
    select 
    external_ref,
    chargeback
from {{ ref('stg_chargeback') }}
)

SELECT
    date_trunc(date_time,month) as month,
    a.*,
    c.chargeback
from acceptance a
JOIN charge_back c ON a.external_ref = c.external_ref


