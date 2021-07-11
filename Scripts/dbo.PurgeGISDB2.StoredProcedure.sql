USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[PurgeGISDB2]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








--=========================================
--Created By Roy He
--Purpose: Archiving DB
--============================================

CREATE Procedure [dbo].[PurgeGISDB2] --'2006-08-01'
   @cutOffDate varchar(30)='01 Aug 2000'

AS

-- Delete Credit Card Key
Delete  Credit_Card_Authorization where contract_number not in (select contract_number from contract)
 

Delete Renter_Primary_Billing where contract_number not in (select contract_number from contract)


Delete
--Select * from 
Credit_Card_Transaction where RBR_Date<='2006-08-01'


Delete 
--Select * from
Credit_Card where  
Credit_Card_Key not in (Select Credit_Card_Key
FROM         
                      dbo.Credit_Card_Authorization 
)
And 

Credit_Card_Key not in
(
SELECT     Credit_Card_Key
FROM         dbo.Credit_Card_Payment
)
And 
Credit_Card_Key not in
(select Guarantee_Credit_Card_Key from reservation where Guarantee_Credit_Card_Key is not null )

And

Credit_Card_Key not in
(Select Credit_Card_Key from reservation_CC_DEP_Payment)
And

Credit_Card_Key not in
(select Credit_Card_Key from Renter_Primary_Billing where  Credit_Card_Key is not null)
And

Credit_Card_Key not in
(select Credit_Card_Key from AR_Transactions where  Credit_Card_Key is not null)
And
Credit_Card_Key not in
(select Credit_Card_Key from Sales_Accessory_CrCard_Payment)
And (Customer_ID IS Null or Customer_ID not in (select Customer_ID from customer where program_Number is not null and program_Number<>'')) 


-- Delete Cusotmer Tables

Print 'Delete Cusotmer Tables'
Delete Frequent_Flyer_Plan_Member
--Select *from Frequent_Flyer_Plan_Member
where FF_Member_Number not in (select FF_Member_Number from contract where FF_Member_Number is not null)


-- Delete Customer Second Time
Delete
--Select * from 
Customer where 
Customer_ID not in 
(select Customer_ID from Credit_card where Customer_ID is not null)
And
Customer_ID not in 
(select Customer_ID from Frequent_Flyer_Plan_Member where Customer_ID is not null)
And
Customer_ID not in 
(select Customer_ID from Contract_Additional_Driver where Customer_ID is not null )
And
Customer_ID not in 
(select Customer_ID from Contract  where Customer_ID is not null)
And
Customer_ID not in 
(select Customer_ID from Reservation  where Customer_ID is not null)


--Delete Vehicle Rate Tables
Select *  Into #Vehicle_Rate
 from
Vehicle_Rate where Rate_ID not in (select rate_ID from Contract where Rate_ID is not null)
and Rate_ID not in (select rate_ID from Reservation where Rate_ID is not null) 

--Delete Vehicle Rate
Delete  Rate_Availability 
--SELECT    Rate_Availability.*
FROM         #Vehicle_Rate INNER JOIN
                      dbo.Rate_Availability ON #Vehicle_Rate.Rate_ID = dbo.Rate_Availability.Rate_ID

Delete Rate_Charge_Amount
--SELECT     *
FROM         #Vehicle_Rate INNER JOIN
                      dbo.Rate_Charge_Amount ON #Vehicle_Rate.Rate_ID = dbo.Rate_Charge_Amount.Rate_ID


Delete Rate_Drop_Off_Location
--SELECT     *
FROM         #Vehicle_Rate INNER JOIN
                      dbo.Rate_Drop_Off_Location ON #Vehicle_Rate.Rate_ID = dbo.Rate_Drop_Off_Location.Rate_ID

Delete Rate_Level
--SELECT     *
FROM         #Vehicle_Rate INNER JOIN
                      dbo.Rate_Level ON #Vehicle_Rate.Rate_ID = dbo.Rate_Level.Rate_ID

Delete Rate_Location_Set_Member
--SELECT     *
FROM         #Vehicle_Rate INNER JOIN
                      dbo.Rate_Location_Set_Member ON #Vehicle_Rate.Rate_ID = dbo.Rate_Location_Set_Member.Rate_ID

Delete Rate_Location_Set
--SELECT     *
FROM         #Vehicle_Rate INNER JOIN
                      dbo.Rate_Location_Set ON #Vehicle_Rate.Rate_ID = dbo.Rate_Location_Set.Rate_ID

Delete Rate_Restriction
--SELECT     *
FROM         #Vehicle_Rate INNER JOIN
                      dbo.Rate_Restriction ON #Vehicle_Rate.Rate_ID = dbo.Rate_Restriction.Rate_ID

Delete Rate_Time_Period
--SELECT     *
FROM         #Vehicle_Rate INNER JOIN
                      dbo.Rate_Time_Period ON #Vehicle_Rate.Rate_ID = dbo.Rate_Time_Period.Rate_ID


Delete Rate_Vehicle_Class
--SELECT     *
FROM         #Vehicle_Rate INNER JOIN
                      dbo.Rate_Vehicle_Class ON #Vehicle_Rate.Rate_ID = dbo.Rate_Vehicle_Class.Rate_ID



Delete  
--Select * from
Vehicle_Rate where Rate_ID  in (select rate_ID from #Vehicle_Rate ) 

GO
