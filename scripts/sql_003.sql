
--AP Invoices with Batch ID where no attachement available
select DISTINCT i.batch_id batch_id, i.invoice_id
from ap_invoices_all i
WHERE NOT EXISTS (select fad.pk1_value
                  from fnd_attached_documents fad
                  where entity_name = 'AP_BATCHES'
                  and fad.pk1_value = i.invoice_id )
                  
select * --fad.pk1_value
from fnd_attached_documents fad
where entity_name IN ( 'AP_BATCHES','AP_INVOICES')
and fad.pk1_value = 2485727           

--AP Batches without Attachmens
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
        (--AP Invoices without Attachmens
            select abv1.BATCH_ID, i1.invoice_id,
                   abv1.BATCH_NAME,
                   TO_CHAR(abv1.BATCH_DATE, 'DD-MON-RRRR') BATCH_DATE, 
                   abv1.CREATED_BY
            from AP_BATCHES_V abv1, --ap_invoices_all i3,
            (--AP Invoices with Batch ID where no attachement available in invoice line
                select DISTINCT i.batch_id batch_id, i.invoice_id
                from ap_invoices_all i
                WHERE NOT EXISTS (select fad.pk1_value
                                  from fnd_attached_documents fad
                                  where entity_name IN ( 'AP_BATCHES','AP_INVOICES')
                                  and fad.pk1_value = i.invoice_id )
                --AND i.batch_id = 1532896
            ) i1
            where i1.batch_id = abv1.batch_id 
            and abv1.BATCH_NAME NOT LIKE 'Receivables:%'
            and (abv1.BATCH_DATE  BETWEEN to_date('2022/03/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS') AND to_date('2022/03/02 23:59:59', 'YYYY/MM/DD HH24:MI:SS'))
            --and abv1.BATCH_NAME = '310BJD030222A'
            --and abv1.batch_id = 1532896 
        ) abv3 
where fu.user_id = abv3.created_by
and i2.batch_id = abv3.batch_id
and i2.invoice_id = abv3.invoice_id
group by abv3.BATCH_ID,
       abv3.BATCH_NAME,
       abv3.BATCH_DATE, abv3.CREATED_BY, fu.user_name
order by  abv3.BATCH_DATE, abv3.BATCH_NAME ;