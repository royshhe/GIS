USE [GISData]
GO
/****** Object:  View [dbo].[handheld_missing_hst]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[handheld_missing_hst] as
select c.contract_number, c.charge_description, c.amount, c.gst_amount, b.transaction_description, b.entered_on_handheld, b.rbr_date
from contract_charge_item c inner join business_transaction b
on c.business_transaction_id=b.business_transaction_id
where c.optional_extra_id in 
(	select optional_extra_id
	from optional_extra
	where type in ('LDW', 'BUYDOWN', 'PAI', 'PEC', 'ELI','PAE','RSN')
) and c.gst_amount=0 and (b.rbr_date between '2010/07/29' and '2010/07/31') and b.entered_on_handheld=1  and b.transaction_description='check in'
--order by b
GO
