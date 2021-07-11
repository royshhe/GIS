USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctTrxHistory]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[GetCtrctTrxHistory]  --3000048
		@CtrctNum	VarChar(10)
AS

DECLARE @iCtrctNum Int
SELECT	@iCtrctNum = Convert(Int, NULLIF(@CtrctNum,''))


SELECT    dbo.Business_Transaction.Transaction_Date,dbo.Business_Transaction.User_ID, dbo.Business_Transaction.Transaction_Description, dbo.Location.Location
--, 
--                       dbo.Business_Transaction.RBR_Date, dbo.Business_Transaction.Entered_On_Handheld, dbo.Business_Transaction.Signature_Required
FROM         dbo.Business_Transaction WITH(NOLOCK) INNER JOIN
                      dbo.Location ON dbo.Business_Transaction.Location_ID = dbo.Location.Location_ID
where contract_number=@iCtrctNum
order by    dbo.Business_Transaction.Transaction_Date                   
                      
                      --exec GetCtrctTrxHistory '1358974'
                      
                      
                      
                --Drop procedure      [BUDGETBC\rhe].GetCtrctTrxHistory 3000048

GO
