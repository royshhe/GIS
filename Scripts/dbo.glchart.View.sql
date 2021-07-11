USE [GISData]
GO
/****** Object:  View [dbo].[glchart]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[glchart]
as 
select account_code, account_description
from glchart_base
union
select account_code, account_description
from glchart_platinum where account_code not in (select account_code from glchart_base)
GO
