USE [GISData]
GO
/****** Object:  View [dbo].[RP_Acc_24_CSR_SalesAcc_Inventory]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*
VIEW NAME: RP_Acc_5_CSR_Summary_Activity_Main_L1
PURPOSE: Select only the core records for the CSR Summary Activity Report.
	 Data for the 6 subreports is retrieved
	 in the separate views named "RP_Acc_5_CSR_Summary_subreport_name_SB_Base_1"
		
AUTHOR:	Nenad Ukropina
DATE CREATED: 1999/01/01
USED BY: CSR Summary Activity Report
MOD HISTORY:
Name 		Date		Comments
*/
CREATE VIEW [dbo].[RP_Acc_24_CSR_SalesAcc_Inventory]
AS
--From Sales_accessory
SELECT	distinct	dbo.Sales_Accessory_Sale_Item.Sales_Accessory_ID, 
			dbo.Sales_Accessory.Sales_Accessory, 
			dbo.Sales_Accessory_Sale_Item.Sales_Contract_Number, 
			dbo.Sales_Accessory_Sale_Contract.Refunded_Contract_No, 
            dbo.Sales_Accessory_Sale_Item.Quantity, 
			dbo.Sales_Accessory_Price.Price, 
			dbo.Sales_Accessory_Sale_Item.Amount, 
            dbo.Sales_Accessory_Sale_Payment.Payment_Type, 
			dbo.Sales_Accessory_Sale_Contract.Sold_At_Location_ID, 
			dbo.Location.Location, 
            dbo.Sales_Accessory_Sale_Contract.Sold_By, 
			dbo.Sales_Accessory_Sale_Contract.Refund_Reason, 
            dbo.Business_Transaction.RBR_Date
FROM         dbo.Sales_Accessory_Sale_Item INNER JOIN
                      dbo.Sales_Accessory_Sale_Contract ON 
                      dbo.Sales_Accessory_Sale_Item.Sales_Contract_Number = dbo.Sales_Accessory_Sale_Contract.Sales_Contract_Number INNER JOIN
                      dbo.Sales_Accessory_Sale_Payment ON 
                      dbo.Sales_Accessory_Sale_Contract.Sales_Contract_Number = dbo.Sales_Accessory_Sale_Payment.Sales_Contract_Number INNER JOIN
                      dbo.Sales_Accessory ON dbo.Sales_Accessory_Sale_Item.Sales_Accessory_ID = dbo.Sales_Accessory.Sales_Accessory_ID INNER JOIN
                      dbo.Sales_Accessory_Price ON dbo.Sales_Accessory.Sales_Accessory_ID = dbo.Sales_Accessory_Price.Sales_Accessory_ID INNER JOIN
                      dbo.Location ON dbo.Sales_Accessory_Sale_Contract.Sold_At_Location_ID = dbo.Location.Location_ID INNER JOIN
                      dbo.Business_Transaction ON dbo.Sales_Accessory_Sale_Item.Business_Transaction_ID = dbo.Business_Transaction.Business_Transaction_ID
where  dbo.Business_Transaction.Rbr_date between  dbo.Sales_Accessory_Price.Sales_Accessory_Valid_From and  isnull(dbo.Sales_Accessory_Price.valid_to,'2078-12-31 23:59')
union
--From Contract_sales_accessory
SELECT	distinct	dbo.Contract_Sales_Accessory.Sales_Accessory_ID,
			dbo.Sales_Accessory.Sales_Accessory,
			dbo.Contract_Sales_Accessory.Contract_Number, 
			'', 
			dbo.Contract_Sales_Accessory.Quantity, 
			case when dbo.Contract_Sales_Accessory.Quantity<>0 
					then CONVERT(decimal(9,2),dbo.Contract_Sales_Accessory.Price/dbo.Contract_Sales_Accessory.Quantity)
				else CONVERT(decimal(9,2),dbo.Contract_Sales_Accessory.Price)
			end	 as Price,  --dbo.Sales_Accessory_Price.Price, 
			dbo.Contract_Sales_Accessory.Price AS amount, 
            dbo.Contract_Payment_Item.Payment_Type,
			dbo.Contract_Sales_Accessory.Sold_At_Location_ID, 
			dbo.Location.Location, 
			dbo.RP__CSR_Who_Opened_The_Contract.User_ID, 
			'',
            dbo.Business_Transaction.Rbr_date
			
--select *
FROM         dbo.Contract_Sales_Accessory INNER JOIN
					dbo.contract on dbo.contract.contract_number=dbo.Contract_Sales_Accessory.contract_number	INNER JOIN
                      dbo.Sales_Accessory ON dbo.Contract_Sales_Accessory.Sales_Accessory_ID = dbo.Sales_Accessory.Sales_Accessory_ID INNER JOIN
                      dbo.Contract_Payment_Item ON dbo.Contract_Sales_Accessory.Contract_Number = dbo.Contract_Payment_Item.Contract_Number INNER JOIN
                      --dbo.Sales_Accessory_Price ON dbo.Sales_Accessory.Sales_Accessory_ID = dbo.Sales_Accessory_Price.Sales_Accessory_ID INNER JOIN
                      dbo.RP__CSR_Who_Opened_The_Contract ON 
                      dbo.Contract_Sales_Accessory.Contract_Number = dbo.RP__CSR_Who_Opened_The_Contract.Contract_Number INNER JOIN
                      dbo.Location ON dbo.Contract_Sales_Accessory.Sold_At_Location_ID = dbo.Location.Location_ID INNER JOIN
                      dbo.Business_Transaction ON dbo.Contract_Sales_Accessory.Contract_Number = dbo.Business_Transaction.Contract_Number
where  --dbo.RP__CSR_Who_Opened_The_Contract.Rbr_date between  dbo.Sales_Accessory_Price.Sales_Accessory_Valid_From and  isnull(dbo.Sales_Accessory_Price.valid_to,'2078-12-31 23:59')
	( dbo.Business_Transaction.Transaction_Type = 'con') 
	AND 
    	( dbo.Business_Transaction.Transaction_Description = 'check out') 
    	AND 
	dbo.contract.Status not in ('vd', 'ca')
GO
