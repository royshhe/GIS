USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[PurgeCust]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure   [dbo].[PurgeCust]
as
select  * into #Contract_Archive  from contract where pick_up_On<'2013-01-01' and status in ('co', 'op')

SELECT     dbo.Business_Transaction.* into #Business_Transaction_Con_Archive
FROM          #Contract_Archive INNER JOIN
                      dbo.Business_Transaction ON #Contract_Archive.Contract_Number = dbo.Business_Transaction.Contract_Number

Delete AR_Export
--SELECT     dbo.AR_Export.*
FROM         #Contract_Archive   INNER JOIN
                      dbo.AR_Export ON  #Contract_Archive.Contract_Number = dbo.AR_Export.Contract_Number

                      

Delete  dbo.AR_Payment
--SELECT    dbo.AR_Payment.*
FROM         #Contract_Archive  INNER JOIN
                        dbo.AR_Payment ON #Contract_Archive.Contract_Number = dbo.AR_Payment.Contract_Number
                 

delete dbo.AR_Transactions
--SELECT     dbo.AR_Transactions.*
FROM #Business_Transaction_Con_Archive  INNER JOIN
                      dbo.AR_Transactions ON #Business_Transaction_Con_Archive.Business_Transaction_ID = dbo.AR_Transactions.Business_Transaction_ID


delete     dbo.Sales_Journal
--SELECT     dbo.Sales_Journal.*
FROM #Business_Transaction_Con_Archive  INNER JOIN
                      dbo.Sales_Journal ON #Business_Transaction_Con_Archive.Business_Transaction_ID = dbo.Sales_Journal.Business_Transaction_ID


delete   dbo.Override_Check_In  
--SELECT     dbo.Override_Check_In.*
FROM         dbo.Vehicle_On_Contract INNER JOIN
                      dbo.Override_Check_In ON dbo.Vehicle_On_Contract.Contract_Number = dbo.Override_Check_In.Overridden_Contract_Number AND 
                      dbo.Vehicle_On_Contract.Unit_Number = dbo.Override_Check_In.Unit_Number AND 
                      dbo.Vehicle_On_Contract.Checked_Out = dbo.Override_Check_In.Checked_Out INNER JOIN 
              #Contract_Archive ON dbo.Vehicle_On_Contract.Contract_Number = #Contract_Archive.Contract_Number
     

----Vehicle Support

-- To Speed up the delete process
SELECT     dbo.Vehicle_Support_Incident.* into #Vehicle_Support_Incident_VC_Archive
FROM         dbo.Vehicle_On_Contract INNER JOIN
                      dbo.Vehicle_Support_Incident ON dbo.Vehicle_On_Contract.Contract_Number = dbo.Vehicle_Support_Incident.Contract_Number AND 
                      dbo.Vehicle_On_Contract.Unit_Number = dbo.Vehicle_Support_Incident.Unit_Number AND 
                      dbo.Vehicle_On_Contract.Checked_Out = dbo.Vehicle_Support_Incident.Checked_Out INNER JOIN 
                      #Contract_Archive ON dbo.Vehicle_On_Contract.Contract_Number = #Contract_Archive.Contract_Number

delete   dbo.Mechanical_Incident  
--SELECT     dbo.Mechanical_Incident.*
FROM       dbo.Mechanical_Incident INNER JOIN #Vehicle_Support_Incident_VC_Archive on #Vehicle_Support_Incident_VC_Archive.Vehicle_Support_Incident_Seq = dbo.Mechanical_Incident.Vehicle_Support_Incident_Seq
                      
     

delete   dbo.Damage_Incident  
--SELECT     dbo.Damage_Incident.*
FROM         #Vehicle_Support_Incident_VC_Archive INNER JOIN
                      dbo.Damage_Incident ON #Vehicle_Support_Incident_VC_Archive.Vehicle_Support_Incident_Seq = dbo.Damage_Incident.Vehicle_Support_Incident_Seq 

--Seizure_Incident
delete   dbo.Seizure_Incident  
--SELECT     dbo.Seizure_Incident.*
FROM         #Vehicle_Support_Incident_VC_Archive INNER JOIN
                      dbo.Seizure_Incident ON 
                      #Vehicle_Support_Incident_VC_Archive.Vehicle_Support_Incident_Seq = dbo.Seizure_Incident.Vehicle_Support_Incident_Seq 

--Stolen_Incident
delete Stolen_Incident
--SELECT     dbo.Stolen_Incident.*
FROM         #Vehicle_Support_Incident_VC_Archive INNER JOIN
                      dbo.Stolen_Incident ON #Vehicle_Support_Incident_VC_Archive.Vehicle_Support_Incident_Seq = dbo.Stolen_Incident.Vehicle_Support_Incident_Seq 

delete   dbo.Vehicle_Support_Comment  
--SELECT     dbo.Vehicle_Support_Comment.*
FROM         #Vehicle_Support_Incident_VC_Archive INNER JOIN
                      dbo.Vehicle_Support_Comment ON 
                      #Vehicle_Support_Incident_VC_Archive.Vehicle_Support_Incident_Seq = dbo.Vehicle_Support_Comment.Vehicle_Support_Incident_Seq 

Delete dbo.Vehicle_Support_Action_Log 
--SELECT     dbo.Vehicle_Support_Action_Log.*
FROM         #Vehicle_Support_Incident_VC_Archive INNER JOIN
                      dbo.Vehicle_Support_Action_Log ON 
                      #Vehicle_Support_Incident_VC_Archive.Vehicle_Support_Incident_Seq = dbo.Vehicle_Support_Action_Log.Vehicle_Support_Incident_Seq 

delete Vehicle_Support_Purchase_Order
--SELECT     dbo.Vehicle_Support_Purchase_Order.*
FROM         #Vehicle_Support_Incident_VC_Archive INNER JOIN
                      dbo.Vehicle_Support_Purchase_Order ON 
                      #Vehicle_Support_Incident_VC_Archive.Vehicle_Support_Incident_Seq = dbo.Vehicle_Support_Purchase_Order.Vehicle_Support_Incident_Seq 

delete Contract_Charge_Item
--SELECT     dbo.Contract_Charge_Item.*
FROM        #Vehicle_Support_Incident_VC_Archive INNER JOIN
                      dbo.Contract_Charge_Item ON 
                      #Vehicle_Support_Incident_VC_Archive.Vehicle_Support_Incident_Seq = dbo.Contract_Charge_Item.Vehicle_Support_Incident_Seq 


delete Contract_Charge_Item_Audit
--SELECT     dbo.Contract_Charge_Item_Audit.*
FROM         #Vehicle_Support_Incident_VC_Archive INNER JOIN
                      dbo.Contract_Charge_Item_Audit ON 
                      #Vehicle_Support_Incident_VC_Archive.Vehicle_Support_Incident_Seq = dbo.Contract_Charge_Item_Audit.Vehicle_Support_Incident_Seq 

delete Contract_Reimbur_and_Discount
--SELECT     dbo.Contract_Reimbur_and_Discount.*
FROM        #Vehicle_Support_Incident_VC_Archive INNER JOIN
                      dbo.Contract_Reimbur_and_Discount ON 
                      #Vehicle_Support_Incident_VC_Archive.Vehicle_Support_Incident_Seq = dbo.Contract_Reimbur_and_Discount.Vehicle_Support_Incident_Seq 

Delete  dbo.Vehicle_Support_Incident  
--Select dbo.Vehicle_Support_Incident.*  
FROM   dbo.Vehicle_Support_Incident INNER JOIN #Vehicle_Support_Incident_VC_Archive 
 on dbo.Vehicle_Support_Incident.Vehicle_Support_Incident_Seq= #Vehicle_Support_Incident_VC_Archive.Vehicle_Support_Incident_Seq

delete   dbo.Vehicle_On_Contract  
--SELECT     dbo.Vehicle_On_Contract.*
FROM         dbo.Vehicle_On_Contract INNER JOIN 
                      #Contract_Archive ON dbo.Vehicle_On_Contract.Contract_Number = #Contract_Archive.Contract_Number


delete Contract_Payment_Item
--select Contract_Payment_Item.* 
FROM       dbo.Contract_Payment_Item INNER JOIN            
	    #Contract_Archive ON dbo.Contract_Payment_Item.Contract_Number = #Contract_Archive.Contract_Number


delete Contract_Charge_Item
--SELECT     dbo.Contract_Charge_Item.*
FROM         #Contract_Archive INNER JOIN
                      dbo.Contract_Charge_Item ON #Contract_Archive.Contract_Number = dbo.Contract_Charge_Item.Contract_Number

Delete Contract_Charge_Item_Audit
--SELECT     dbo.Contract_Charge_Item_Audit.*
FROM         #Contract_Archive INNER JOIN
dbo.Contract_Charge_Item_Audit ON #Contract_Archive.Contract_Number = dbo.Contract_Charge_Item_Audit.Contract_Number


Delete Contract_Optional_Extra
--SELECT     dbo.Contract_Optional_Extra.*
FROM        #Contract_Archive  INNER JOIN
                      dbo.Contract_Optional_Extra ON #Contract_Archive.Contract_Number = dbo.Contract_Optional_Extra.Contract_Number

delete Contract_Additional_Driver
--SELECT     dbo.Contract_Additional_Driver.*
FROM         #Contract_Archive INNER JOIN
                      dbo.Contract_Additional_Driver ON #Contract_Archive.Contract_Number = dbo.Contract_Additional_Driver.Contract_Number

delete Contract_Billing_Party
--SELECT     dbo.Contract_Billing_Party.*
FROM         #Contract_Archive INNER JOIN
                      dbo.Contract_Billing_Party ON #Contract_Archive.Contract_Number = dbo.Contract_Billing_Party.Contract_Number

delete Contract_Internal_Comment
--SELECT     dbo.Contract_Internal_Comment.*
FROM         #Contract_Archive INNER JOIN
                      dbo.Contract_Internal_Comment ON #Contract_Archive.Contract_Number = dbo.Contract_Internal_Comment.Contract_Number

delete Contract_Print
--SELECT     Contract_Print.*
FROM         #Contract_Archive INNER JOIN
                      dbo.Contract_Print ON #Contract_Archive.Contract_Number = dbo.Contract_Print.Contract_Number

delete      Contract_Print_Comment
--select Contract_Print_Comment.*
FROM         #Contract_Archive INNER JOIN
                      dbo.Contract_Print_Comment ON #Contract_Archive.Contract_Number = dbo.Contract_Print_Comment.Contract_Number


delete Contract_Sales_Accessory
--SELECT    Contract_Sales_Accessory.* 
FROM         #Contract_Archive INNER JOIN
                      dbo.Contract_Sales_Accessory ON #Contract_Archive.Contract_Number = dbo.Contract_Sales_Accessory.Contract_Number

delete Contract_Reimbur_and_Discount
--SELECT  *   
FROM         dbo.Contract_Reimbur_and_Discount INNER JOIN
                     #Contract_Archive ON dbo.Contract_Reimbur_and_Discount.Contract_Number = #Contract_Archive.Contract_Number 

delete  Renter_Driver_Licence
--SELECT    Renter_Driver_Licence.* 
FROM         #Contract_Archive INNER JOIN
                      dbo.Renter_Driver_Licence ON #Contract_Archive.Contract_Number = dbo.Renter_Driver_Licence.Contract_Number


delete Drop_Off_History
--SELECT    Drop_Off_History.* 
FROM        #Contract_Archive INNER JOIN
                      dbo.Drop_Off_History ON #Contract_Archive.Contract_Number = dbo.Drop_Off_History.Contract_Number

delete Non_Driving_Renter_ID
--SELECT     dbo.Non_Driving_Renter_ID.*
FROM         #Contract_Archive INNER JOIN
                      dbo.Non_Driving_Renter_ID ON #Contract_Archive.Contract_Number = dbo.Non_Driving_Renter_ID.Contract_Number


Delete dbo.Credit_Card_Transaction
--SELECT     dbo.Credit_Card_Transaction.*
FROM         #Contract_Archive INNER JOIN
                      dbo.Credit_Card_Transaction ON #Contract_Archive.Contract_Number = dbo.Credit_Card_Transaction.Contract_Number

delete Override_Movement_Completion
--SELECT     dbo.Override_Movement_Completion.*
FROM         #Contract_Archive INNER JOIN
                      dbo.Override_Movement_Completion ON #Contract_Archive.Contract_Number = dbo.Override_Movement_Completion.Override_Contract_Number


Delete Override_Check_In
--SELECT Override_Check_In.*    
FROM         #Contract_Archive INNER JOIN
                      dbo.Override_Check_In ON #Contract_Archive.Contract_Number = dbo.Override_Check_In.Override_Contract_Number


Delete Insurance_Transfer
--SELECT     dbo.Insurance_Transfer.*
FROM         #Contract_Archive INNER JOIN
                      dbo.Insurance_Transfer ON #Contract_Archive.Contract_Number = dbo.Insurance_Transfer.Contract_Number


Delete  dbo.Business_Transaction
--SELECT     Business_Transaction.*
FROM         dbo.Business_Transaction INNER JOIN #Contract_Archive
ON #Contract_Archive.Contract_Number = dbo.Business_Transaction.Contract_Number
                      

Delete Contract
--SELECT    contract.* 
FROM         dbo.Contract INNER JOIN
#Contract_Archive ON dbo.Contract.Contract_Number =#Contract_Archive.Contract_Number

-- Foreign Contract related data

SELECT   distinct dbo.Quoted_Vehicle_Rate.* into  #Foreign_Con_QVR_Archive
FROM         #Contract_Archive INNER JOIN
                      dbo.Quoted_Vehicle_Rate ON #Contract_Archive.Quoted_Rate_ID = dbo.Quoted_Vehicle_Rate.Quoted_Rate_ID
where  (#Contract_Archive.Foreign_Contract_Number is not null) and (#Contract_Archive.Confirmation_Number is null)


Delete Quoted_Included_Optional_Extra
--SELECT     dbo.Quoted_Included_Optional_Extra.*
FROM         #Foreign_Con_QVR_Archive INNER JOIN
                      dbo.Quoted_Included_Optional_Extra ON #Foreign_Con_QVR_Archive.Quoted_Rate_ID = dbo.Quoted_Included_Optional_Extra.Quoted_Rate_ID

Delete Quoted_Rate_Category
--SELECT     dbo.Quoted_Rate_Category.*
FROM         #Foreign_Con_QVR_Archive INNER JOIN
                      dbo.Quoted_Rate_Category ON #Foreign_Con_QVR_Archive.Quoted_Rate_ID = dbo.Quoted_Rate_Category.Quoted_Rate_ID

Delete Quoted_Rate_Restriction
--SELECT     dbo.Quoted_Rate_Restriction.*
FROM         #Foreign_Con_QVR_Archive INNER JOIN
                      dbo.Quoted_Rate_Restriction ON #Foreign_Con_QVR_Archive.Quoted_Rate_ID = dbo.Quoted_Rate_Restriction.Quoted_Rate_ID

Delete Quoted_Time_Period_Rate
--SELECT     dbo.Quoted_Time_Period_Rate.*
FROM         #Foreign_Con_QVR_Archive INNER JOIN
                      dbo.Quoted_Time_Period_Rate ON #Foreign_Con_QVR_Archive.Quoted_Rate_ID = dbo.Quoted_Time_Period_Rate.Quoted_Rate_ID

Delete Quoted_Vehicle_Rate
--SELECT     dbo.Quoted_Vehicle_Rate.*
FROM         #Foreign_Con_QVR_Archive INNER JOIN
                      dbo.Quoted_Vehicle_Rate ON #Foreign_Con_QVR_Archive.Quoted_Rate_ID = dbo.Quoted_Vehicle_Rate.Quoted_Rate_ID
 
-- Delete CC & Cust
 
-- Delete Credit Card Key
delete [Credit_Card_Payment] where contract_number not in (

select contract_number from contract 
)

Delete  Credit_Card_Authorization where contract_number not in (select contract_number from contract)
 

Delete Renter_Primary_Billing where contract_number not in (select contract_number from contract)


Delete	--Select * from 
Sales_Accessory_CrCard_Payment   
where sales_contract_number not in
(

 select sales_contract_number from Sales_Accessory_Sale_Contract
 )


delete 
--select * from 
reservation_CC_DEP_Payment where confirmation_number not in (select confirmation_number from reservation)

Delete
--Select * from 
Credit_Card_Transaction where RBR_Date<='2014-01-01'

Select * into #CustArchive from 	  
Customer where 
--Customer_ID not in 
--(select Customer_ID from Credit_card where Customer_ID is not null)
--And
 
Customer_ID not in 
(
	(select Customer_ID from Frequent_Flyer_Plan_Member where Customer_ID is not null)
	union

	(select Customer_ID from Contract_Additional_Driver where Customer_ID is not null )
	union
	(select Customer_ID from Contract  where Customer_ID is not null)
	union
	(select Customer_ID from Reservation  where Customer_ID is not null)
)
 And Do_Not_rent=0
 

	  
--Delete 
Select * into #CCArchive from
--select count(*) from 
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
And	 ( Customer_ID IS Null or (Customer_ID In 
(Select Customer_ID from  #CustArchive)))

delete Credit_card from Credit_Card cc inner join #CCArchive cca on cc.Credit_Card_Key=cca.Credit_Card_Key
-- Delete Cusotmer Tables

Print 'Delete Cusotmer Tables'
Delete Frequent_Flyer_Plan_Member
--Select *from Frequent_Flyer_Plan_Member
where FF_Member_Number not in (select FF_Member_Number from contract where FF_Member_Number is not null)

 
Delete	  
Customer where Customer_ID  in (Select Customer_ID from  #CustArchive)	and 
Customer_ID not in (Select customer_id from Credit_Card  where customer_id is not null)




 
GO
