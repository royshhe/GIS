USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetSAIDForSelfStorage]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[GetSAIDForSelfStorage]   
	@LocationID	Varchar(20)
as

Declare @SAID int
--DECLARE @dCurrDate Datetime
--DECLARE @dLastDatetime Datetime
--Select @dCurrDate=getdate()
--SELECT 	@dCurrDate = Convert(Datetime, NULLIF(getdate(), "")),
		--@dLastDatetime = Convert(Datetime, "31 Dec 2078 11:59PM")

Select @SAID=Code  from Lookup_Table where Category ='Self Storage'
SELECT SA.Sales_Accessory_ID,       
      SA.GL_Revenue_Account, 
      SA.Sell_on_contract, 
      SAP.Price, 
      SAP.GST_Exempt, 
      SAP.PST_Exempt,
     -- convert(varchar(30), SAP.Sales_Accessory_Valid_From,113),
      convert(varchar(30),LSA.Valid_From,113),
      
      SA.Unit_Description, 
      SA.Sales_Accessory  

FROM  Sales_Accessory AS SA
INNER JOIN 	Location_Sales_Accessory LSA
ON SA.Sales_Accessory_ID = LSA.Sales_Accessory_ID
 INNER JOIN
               Sales_Accessory_Price AS SAP ON SA.Sales_Accessory_ID = SAP.Sales_Accessory_ID
Where SA.Sales_Accessory_ID=@SAID  and (SAP.Valid_To>GETDATE() or SAP.Valid_To is null)
AND SAP.Sales_Accessory_Valid_From<GETDATE()
AND LSA.Location_ID= @LocationID
AND  SA.Delete_Flag=0

--select  Convert(Datetime, NULLIF('10/02/2017', ''))





 
GO
