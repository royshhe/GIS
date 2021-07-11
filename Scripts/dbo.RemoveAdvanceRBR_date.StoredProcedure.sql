USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RemoveAdvanceRBR_date]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Procedure  [dbo].[RemoveAdvanceRBR_date]  --'2008-07-17'
(
	@paramDate varchar(20)
	
)
AS


/*
UPdate all the following Tables
Business_Transaction
Business_Transaction_Export
Contract_Payment_Item
Reservation_Dep_Payment
Sales_Accessory_Sale_Payment
Credit_Card_Transaction
RBR_Date

*/


Declare @AdvancedRBRDate DateTime

SELECT	@AdvancedRBRDate	= CONVERT(datetime, @paramDate)

Update Business_Transaction set RBR_Date=@AdvancedRBRDate-1 where RBR_Date=@AdvancedRBRDate
Update Business_Transaction_Export set RBR_Date=@AdvancedRBRDate-1 where RBR_Date=@AdvancedRBRDate
Update Contract_Payment_Item set RBR_Date=@AdvancedRBRDate-1 where RBR_Date=@AdvancedRBRDate
Update Reservation_Dep_Payment set RBR_Date=@AdvancedRBRDate-1 where RBR_Date=@AdvancedRBRDate
Update Sales_Accessory_Sale_Payment set RBR_Date=@AdvancedRBRDate-1 where RBR_Date=@AdvancedRBRDate
Update Credit_Card_Transaction set RBR_Date=@AdvancedRBRDate-1 where RBR_Date=@AdvancedRBRDate

Update RBR_Date 
Set Budget_Close_Datetime=NULL,
	Closed_By=NULL,
	Date_GL_Generated=NULL,
	Date_AR_Generated=NULL,
	Date_AMEFT_Submitted=NULL,
	Date_CRTrans_Loaded=NULL,
	Date_IRACS_Submitted=NULL
 where RBR_Date=@AdvancedRBRDate-1

Delete RBR_Date  where RBR_Date=@AdvancedRBRDate
GO
