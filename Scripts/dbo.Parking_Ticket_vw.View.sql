USE [GISData]
GO
/****** Object:  View [dbo].[Parking_Ticket_vw]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Parking_Ticket_vw]
AS

SELECT     dbo.Contract.Contract_Number, dbo.Contract.First_Name, dbo.Contract.Last_Name, Gender, dbo.Contract.Address_1, dbo.Contract.Address_2, dbo.Contract.City, 
                      dbo.Contract.Province_State, dbo.Contract.Postal_Code, lookup_table.Value as Country, 
                      sum(
				Case when charge_type=16 then dbo.Contract_Charge_Item.Amount
				     Else 0
				End
			  ) ViolationCharge,
			sum(
				Case when charge_type=17 then dbo.Contract_Charge_Item.Amount
				     Else 0
				End
			  ) AdminCharge,

max(dbo.Contract_Charge_Item.Ticket_Number) as TicketNumber, max(dbo.Contract_Charge_Item.Issuer) as Issuer, max(dbo.Contract_Charge_Item.Issuing_Date) as Issue_Date, Max(License_Number) as License_Number,
dbo.Business_Transaction.RBR_Date,  dbo.Business_Transaction.Business_Transaction_ID,
case when Customer_Code='Renter' 
		then 'Renter' 
		else dbo.Contract_Billing_Party.Billing_Method
  end  as Billing_Method
FROM         dbo.Contract INNER JOIN
                      dbo.Contract_Charge_Item ON dbo.Contract.Contract_Number = dbo.Contract_Charge_Item.Contract_Number INNER JOIN
                      dbo.Business_Transaction ON 
                      dbo.Contract_Charge_Item.Business_Transaction_ID = dbo.Business_Transaction.Business_Transaction_ID INNER JOIN
                      dbo.Contract_Billing_Party ON dbo.Contract_Charge_Item.Contract_Number = dbo.Contract_Billing_Party.Contract_Number AND 
                      dbo.Contract_Charge_Item.Contract_Billing_Party_ID = dbo.Contract_Billing_Party.Contract_Billing_Party_ID
            Left Join Toll_Charge TC on dbo.Business_Transaction.Business_Transaction_ID=TC.Business_Transaction_ID          
	        Left Join lookup_table on dbo.Contract.Country=lookup_table .Code and  category ='Country' 

where charge_type in (16,17)  --And dbo.Business_Transaction.RBR_Date between '2008-01-01' and '2008-02-05' 
	  And	(TC.Email_Sent=0 or TC.Email_Sent is Null)
--And Amount>0
Group by  dbo.Contract.Contract_Number, dbo.Contract.First_Name, dbo.Contract.Last_Name, Gender,dbo.Contract.Address_1, dbo.Contract.Address_2, dbo.Contract.City, 
                      dbo.Contract.Province_State, dbo.Contract.Postal_Code, lookup_table.Value, dbo.Business_Transaction.RBR_Date,  dbo.Business_Transaction.Business_Transaction_ID,dbo.Contract_Billing_Party.Billing_Method,Customer_Code
                      --,dbo.Contract_Charge_Item.Ticket_Number
GO
