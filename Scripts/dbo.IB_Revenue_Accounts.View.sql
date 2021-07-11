USE [GISData]
GO
/****** Object:  View [dbo].[IB_Revenue_Accounts]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE view [dbo].[IB_Revenue_Accounts]

as

SELECT distinct dbo.Charge_GL.GL_Revenue_Account,ltrim(rtrim(glchart_Charge.account_description)) as account_description
FROM   dbo.glchart_base glchart_Charge INNER JOIN
       dbo.Charge_GL ON glchart_Charge.account_code = dbo.Charge_GL.GL_Revenue_Account 
       --AND dbo.Charge_GL.Vehicle_Type_ID = 'Car'

union

SELECT  distinct   dbo.Optional_Extra_GL.GL_Revenue_Account, ltrim(rtrim(glchart_OptionalExtra.account_description)) account_description
FROM         dbo.glchart_base glchart_OptionalExtra INNER JOIN
                      dbo.Optional_Extra_GL ON glchart_OptionalExtra.account_code = dbo.Optional_Extra_GL.GL_Revenue_Account 
                      --AND 
                      --dbo.Optional_Extra_GL.Vehicle_Type_ID = 'Car'
--order by GL_Revenue_Account



GO
