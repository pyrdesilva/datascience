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

--------------------------------------------------------------------------------


select abv3.BATCH_ID,
       abv3.BATCH_NAME,
       abv3.BATCH_DATE, 
       abv3.CREATED_BY, 
       fu.user_name, 
       COUNT(i2.invoice_num) inv_count, 
       --LISTAGG(i2.invoice_num, ', ') WITHIN GROUP (ORDER BY i2.invoice_num) invoices_in_batch
       rtrim (xmlagg (xmlelement (e, i2.invoice_num|| '/'||CHR(10)) ORDER BY i2.invoice_num).extract ('//text()').getClobVal(), '/'||CHR(10)) as invoices_in_batch
from fnd_user fu, ap_invoices_all i2,
        (--AP Batches without Attachmens
        select abv.BATCH_ID,
               abv.BATCH_NAME,
               TO_CHAR(abv.BATCH_DATE,'DD-MON-RRRR') BATCH_DATE, 
               abv.CREATED_BY
        FROM AP_BATCHES_V abv
        WHERE NOT EXISTS (select fad.pk1_value
                          from fnd_attached_documents fad
                          where entity_name = 'AP_BATCHES'
                          and fad.pk1_value = abv.batch_id)
        AND abv.BATCH_NAME NOT LIKE 'Receivables:%'
        and (abv.BATCH_DATE  BETWEEN to_date('2022/03/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS') AND to_date('2022/03/02 23:59:59', 'YYYY/MM/DD HH24:MI:SS'))
        
        UNION
        --AP Invoices without Attachmens
        select abv1.BATCH_ID,
               abv1.BATCH_NAME,
               TO_CHAR(abv1.BATCH_DATE, 'DD-MON-RRRR') BATCH_DATE, 
               abv1.CREATED_BY
        from AP_BATCHES_V abv1, 
        (--AP Invoices with Batch ID
        select DISTINCT i.batch_id batch_id
        from ap_invoices_all i
        WHERE NOT EXISTS (select fad.pk1_value
                          from fnd_attached_documents fad
                          where entity_name = 'AP_BATCHES'
                          and (fad.pk1_value = i.batch_id OR fad.pk1_value = i.invoice_id) )) i1
        where i1.batch_id = abv1.batch_id
        AND abv1.BATCH_NAME NOT LIKE 'Receivables:%'
        and (abv1.BATCH_DATE  BETWEEN to_date('2022/03/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS') AND to_date('2022/03/02 23:59:59', 'YYYY/MM/DD HH24:MI:SS'))
        --AND abv1.batch_id = 1533096 
        ) abv3 
where fu.user_id = abv3.created_by
and i2.batch_id = abv3.batch_id    
--AND abv3.BATCH_NAME = '310KAR030222'    --'310BJD030122'  --
group by abv3.BATCH_ID,
       abv3.BATCH_NAME,
       abv3.BATCH_DATE, abv3.CREATED_BY, fu.user_name;