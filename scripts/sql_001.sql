
SELECT ROW_ID,
ATTRIBUTE1,
ATTRIBUTE2,
ATTRIBUTE3,
ATTRIBUTE4,
ATTRIBUTE5,
ATTRIBUTE6,
ATTRIBUTE7,
ATTRIBUTE8,
ATTRIBUTE9,
ATTRIBUTE10,
ATTRIBUTE11,
ATTRIBUTE12,
ATTRIBUTE13,
ATTRIBUTE14,
ATTRIBUTE15,
ATTRIBUTE_CATEGORY,
BATCH_CODE_COMBINATION_ID,
BATCH_ID,
BATCH_NAME,
BATCH_DATE,
CONTROL_INVOICE_COUNT,
CONTROL_INVOICE_TOTAL,
ACTUAL_INVOICE_COUNT,
ACTUAL_INVOICE_TOTAL,
INVOICE_CURRENCY_CODE,
PAYMENT_TERMS_NAME,
INVOICE_TYPE_LOOKUP_CODE,
PAY_GROUP_LOOKUP_CODE,
PAYMENT_PRIORITY,
DOCUMENT_CATEGORY,
GL_DATE,
PAYMENT_CURRENCY_CODE,
HOLD_NAME,
HOLD_REASON,
CREATED_BY,
CREATION_DATE,
DOC_CATEGORY_CODE,
HOLD_LOOKUP_CODE,
LAST_UPDATED_BY,
LAST_UPDATE_DATE,
LAST_UPDATE_LOGIN,
ORG_ID,
TERMS_ID 
FROM AP_BATCHES_V 
WHERE (BATCH_DATE  BETWEEN to_date('2022/03/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS') AND to_date('2022/03/02 23:59:59', 'YYYY/MM/DD HH24:MI:SS')) 
order by BATCH_NAME

select *
FROM AP_BATCHES_V 
where BATCH_NAME = '310BJD030122'

UNION
select *
FROM AP_BATCHES_V 
where BATCH_NAME = 'Receivables:494168'
AND BATCH_NAME NOT LIKE 'Receivables:%'


select ab.*, i.*
FROM AP_BATCHES_V ab, ap_invoices_all i
where BATCH_NAME ='310KAR030222' --'310BJD030122' -- '310DJS030222'   --
AND i.batch_id = ab.batch_id     
--65510457
select *
from fnd_attached_documents fad
where fad.pk1_value = 1533128
and entity_name = 'AP_BATCHES'
union

select *
from fnd_attached_documents fad
where fad.pk1_value = 2486140 --1533096 --2486143   --
and entity_name = 'AP_BATCHES'

select * from fnd_user fu where user_id = 2422


select *
from ap_invoices_all i
Where batch_id = 1533136

select abv.BATCH_ID,
       abv.BATCH_NAME,
       abv.BATCH_DATE, abv.CREATED_BY, fu.user_name, i.invoice_num
       --COUNT(i.invoice_num) invoice_num
FROM AP_BATCHES_V abv, fnd_user fu, ap_invoices_all i
WHERE NOT EXISTS (select fad.pk1_value
                  from fnd_attached_documents fad
                  where entity_name = 'AP_BATCHES'
                  and fad.pk1_value = abv.batch_id)
and (abv.BATCH_DATE  BETWEEN to_date('2022/03/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS') AND to_date('2022/03/02 23:59:59', 'YYYY/MM/DD HH24:MI:SS'))
and fu.user_id = abv.CREATED_BY
and i.batch_id = abv.batch_id  
and abv.BATCH_NAME = '310BJD030122' --'310DJS030222' --310KAR030222
/*group by abv.BATCH_ID,
       abv.BATCH_NAME,
       abv.BATCH_DATE, abv.CREATED_BY, fu.user_name
*/order by abv.BATCH_DATE, abv.BATCH_NAME


select abv.BATCH_ID,
       abv.BATCH_NAME,
       abv.BATCH_DATE, abv.CREATED_BY, fu.user_name, i.invoice_num
FROM AP_BATCHES_V abv, fnd_user fu, ap_invoices_all i
WHERE NOT EXISTS (select fad.pk1_value
                  from fnd_attached_documents fad
                  where entity_name = 'AP_BATCHES'
                  and fad.pk1_value = I.INVOICE_ID)
and (abv.BATCH_DATE  BETWEEN to_date('2022/03/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS') AND to_date('2022/03/02 23:59:59', 'YYYY/MM/DD HH24:MI:SS')) 
and fu.user_id = abv.CREATED_BY
AND i.batch_id = abv.batch_id    
AND abv.BATCH_NAME = '310BJD030122'         -- '310DJS030222'   --'310KAR030222' --
 