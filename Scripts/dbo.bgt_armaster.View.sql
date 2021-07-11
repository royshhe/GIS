USE [GISData]
GO
/****** Object:  View [dbo].[bgt_armaster]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



create view [dbo].[bgt_armaster]
as
select customer_code,ship_to_code, address_type,po_num_reqd_flag, claim_num_reqd_flag
from bgt_armaster_base

GO
