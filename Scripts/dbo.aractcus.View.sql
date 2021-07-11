USE [GISData]
GO
/****** Object:  View [dbo].[aractcus]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


create view [dbo].[aractcus]
as 
select customer_code, amt_balance
from aractcus_base

GO
