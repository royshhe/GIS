USE [GISData]
GO
/****** Object:  View [dbo].[IB_ARAP_Detail_vw]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*
VIEW NAME: IB_Contract_Revenue_vw
PURPOSE: Determin AR or AP accorrding to the Revenue ownership
	 
AUTHOR:	
DATE CREATED:
USED BY:
MOD HISTORY:
Name 		Date		Comments
*/


CREATE VIEW [dbo].[IB_ARAP_Detail_vw]
AS
SELECT 
			IB_Contract_Reveune.RBR_Date,
			IB_Contract_Reveune.Contract_number,
			IB_Contract_Reveune.Revenue_Account, 
			IB_Contract_Reveune.Amount, 
			IB_Contract_Reveune.Commission_Rate, 
			IB_Contract_Reveune.Vehicle_Ownership_Vendor_Code, 
			IB_Contract_Reveune.Vehicle_Ownership_Customer_code, 
			IB_Contract_Reveune.Renting_Compay_Vendor_Code, 
			IB_Contract_Reveune.Renting_Compay_Customer_Code, 
			IB_Contract_Reveune.Receiving_Company_Vendor_Code, 
			IB_Contract_Reveune.Receiving_Company_Customer_Code, 
			dbo.IB_Revenue_Ownership.Subleger, 
			Customer_Type,
			Vendor_Type,
			case when Customer_Type='Renting'
			   then Renting_Compay_Customer_Code
				   when dbo.IB_Revenue_Ownership.Customer_Type='Owning'
			   then Vehicle_Ownership_Customer_code
				   when dbo.IB_Revenue_Ownership.Customer_Type='Receiving'
			   then Receiving_Company_Customer_Code
			   else 'NA'
				
			end as Customer_code, 
			case when dbo.IB_Revenue_Ownership.Vendor_Type='Renting'
			   then Renting_Compay_Vendor_Code
				   when dbo.IB_Revenue_Ownership.Vendor_Type='Owning'
			   then Vehicle_Ownership_Vendor_Code
				   when dbo.IB_Revenue_Ownership.Vendor_Type='Receiving'
			   then Receiving_Company_Vendor_Code
			   else 'NA'
				
			end as Vendor_code,
			IB_Contract_Reveune.IB_Zone,
			IB_Contract_Reveune.Contract_Currency_ID		      
                      
FROM         dbo.IB_Revenue_Ownership INNER JOIN
                      dbo.IB_Contract_Revenue_Split_vw IB_Contract_Reveune ON dbo.IB_Revenue_Ownership.Owned_By_Me = IB_Contract_Reveune.Owned_By_Me AND 
                      dbo.IB_Revenue_Ownership.Rented_By_Me = IB_Contract_Reveune.Rented_By_Me AND 
                      dbo.IB_Revenue_Ownership.Received_By_Me = IB_Contract_Reveune.Received_By_Me AND 
                      dbo.IB_Revenue_Ownership.Revenue_Owner_Ship = IB_Contract_Reveune.Revenue_Ownership
--where IB_Transaction_Detail.contract_number=855075
WHERE  not (( IB_Contract_Reveune.Owned_By_Me = 1) AND ( IB_Contract_Reveune.Rented_By_Me = 0) AND ( IB_Contract_Reveune.Received_By_Me = 0) AND ( IB_Contract_Reveune.Revenue_Ownership = 'Receiving') and Renting_Compay=Receiving_Company)






GO
