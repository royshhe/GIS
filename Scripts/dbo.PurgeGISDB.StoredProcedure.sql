USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[PurgeGISDB]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








--=========================================
--Created By Roy He
--Purpose: Archiving DB
--============================================

CREATE Procedure [dbo].[PurgeGISDB] --'2013-08-01'
   @cutOffDate varchar(30)='01 Aug 2000'

AS
-- Archiving GIS Database

--BEGIN TRANSACTION

--***************************************************************DELETE SALES ACCESSORY **************************************************************************

SELECT DISTINCT dbo.Sales_Accessory_Sale_Contract.*
INTO            #Sales_Accessory_Sale_Contract_Archive
FROM         dbo.Business_Transaction INNER JOIN
                      dbo.Sales_Accessory_Sale_Contract ON 
                      dbo.Business_Transaction.Sales_Contract_Number = dbo.Sales_Accessory_Sale_Contract.Sales_Contract_Number
WHERE     (dbo.Business_Transaction.Transaction_Type = 'sls') AND (dbo.Business_Transaction.RBR_Date < @cutOffDate)

 
SELECT DISTINCT dbo.Sales_Accessory_Sale_Contract.*
   INTO            #SA_Refunded_Contract_Archive
FROM  dbo.Sales_Accessory_Sale_Contract INNER JOIN
               #Sales_Accessory_Sale_Contract_Archive   ON 
               dbo.Sales_Accessory_Sale_Contract.Refunded_Contract_No = #Sales_Accessory_Sale_Contract_Archive.Sales_Contract_Number
               
               
Insert into	#Sales_Accessory_Sale_Contract_Archive
Select * from	#SA_Refunded_Contract_Archive



select dbo.Business_Transaction.*  into #Sls_BT_Archive
FROM         dbo.Business_Transaction INNER JOIN
                      #Sales_Accessory_Sale_Contract_Archive ON 
                      dbo.Business_Transaction.Sales_Contract_Number = #Sales_Accessory_Sale_Contract_Archive.Sales_Contract_Number

Delete AR_Transactions
--SELECT     dbo.AR_Transactions.*  
FROM         #Sls_BT_Archive INNER JOIN
                      dbo.AR_Transactions ON #Sls_BT_Archive.Business_Transaction_ID = dbo.AR_Transactions.Business_Transaction_ID

Delete dbo.Sales_Journal
--SELECT    dbo.Sales_Journal.* 
FROM         #Sls_BT_Archive INNER JOIN
                      dbo.Sales_Journal ON #Sls_BT_Archive.Business_Transaction_ID = dbo.Sales_Journal.Business_Transaction_ID

DELETE dbo.Sales_Accessory_Sale_Item
--SELECT     dbo.Sales_Accessory_Sale_Item.*
FROM         #Sales_Accessory_Sale_Contract_Archive INNER JOIN
                      dbo.Sales_Accessory_Sale_Item ON 
                      #Sales_Accessory_Sale_Contract_Archive.Sales_Contract_Number = dbo.Sales_Accessory_Sale_Item.Sales_Contract_Number

delete  dbo.Sales_Accessory_CrCard_Payment
--SELECT     dbo.Sales_Accessory_CrCard_Payment.*
FROM       #Sales_Accessory_Sale_Contract_Archive inner join  dbo.Sales_Accessory_Sale_Payment ON 
                     dbo.Sales_Accessory_Sale_Payment.Sales_Contract_Number = #Sales_Accessory_Sale_Contract_Archive.Sales_Contract_Number INNER JOIN
                      dbo.Sales_Accessory_CrCard_Payment ON 
                      dbo.Sales_Accessory_CrCard_Payment.Sales_Contract_Number = dbo.Sales_Accessory_Sale_Payment.Sales_Contract_Number


delete  dbo.Sales_Accessory_Cash_Payment
--SELECT     dbo.Sales_Accessory_Cash_Payment.*
FROM         dbo.Sales_Accessory_Sale_Payment INNER JOIN
                      dbo.Sales_Accessory_Cash_Payment ON 
                      dbo.Sales_Accessory_Sale_Payment.Sales_Contract_Number = dbo.Sales_Accessory_Cash_Payment.Sales_Contract_Number INNER JOIN
                      #Sales_Accessory_Sale_Contract_Archive ON 
                      dbo.Sales_Accessory_Sale_Payment.Sales_Contract_Number = #Sales_Accessory_Sale_Contract_Archive.Sales_Contract_Number 


delete   dbo.Sales_Accessory_Sale_Payment  
--SELECT     dbo.Sales_Accessory_Sale_Payment.*
FROM         dbo.Sales_Accessory_Sale_Payment  INNER JOIN
                      #Sales_Accessory_Sale_Contract_Archive ON 
                      dbo.Sales_Accessory_Sale_Payment.Sales_Contract_Number = #Sales_Accessory_Sale_Contract_Archive.Sales_Contract_Number 


delete   dbo.AR_Export  
--SELECT     dbo.AR_Export.*
FROM         dbo.AR_Export  INNER JOIN
                      #Sales_Accessory_Sale_Contract_Archive ON 
                      dbo.AR_Export.Sales_Contract_Number = #Sales_Accessory_Sale_Contract_Archive.Sales_Contract_Number 


DELETE dbo.Business_Transaction 
--select dbo.Business_Transaction .*
FROM         dbo.Business_Transaction INNER JOIN
             #Sls_BT_Archive ON 
                     dbo.Business_Transaction.Business_Transaction_ID = #Sls_BT_Archive.Business_Transaction_ID 

--Delete Sales_Accessory_Sale_Item
--FROM         #Sales_Accessory_Sale_Contract_Archive INNER JOIN
--                      dbo.Sales_Accessory_Sale_Item ON #Sales_Accessory_Sale_Contract_Archive.Sales_Contract_Number = dbo.Sales_Accessory_Sale_Item.Sales_Contract_Number

DELETE Sales_Accessory_Sale_Contract
--SELECT     Sales_Accessory_Sale_Contract.*
FROM         #SA_Refunded_Contract_Archive INNER JOIN
                      dbo.Sales_Accessory_Sale_Contract ON 
                      #SA_Refunded_Contract_Archive.Sales_Contract_Number = dbo.Sales_Accessory_Sale_Contract.Sales_Contract_Number


 

DELETE Sales_Accessory_Sale_Contract
--SELECT     Sales_Accessory_Sale_Contract.*
FROM         #Sales_Accessory_Sale_Contract_Archive INNER JOIN
                      dbo.Sales_Accessory_Sale_Contract ON 
                      #Sales_Accessory_Sale_Contract_Archive.Sales_Contract_Number = dbo.Sales_Accessory_Sale_Contract.Sales_Contract_Number
                      and dbo.Sales_Accessory_Sale_Contract.Refunded_Contract_No is null


--********************************************************END OF DELETING SALES ACCESSORY CONTRAT**************************************************************

--*********************************************************CONTRACT RELATED TABLES ****************************************************************************

SELECT    distinct  dbo.Contract.* into #Contract_Archive 
FROM         dbo.Contract INNER JOIN
                      dbo.Business_Transaction ON dbo.Contract.Contract_Number = dbo.Business_Transaction.Contract_Number
WHERE     (dbo.Business_Transaction.Transaction_Type = 'Con') AND (dbo.Business_Transaction.Transaction_Description IN ('Check In', 'Foreign Check In')) AND
                       (dbo.Business_Transaction.RBR_Date < @cutOffDate)

--Delete all Cancel or Void Contracts
INSERT into #Contract_Archive select * from contract where (status='CA' or status='VD') and pick_up_on<@cutOffDate


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


--*******************************************************************END OF CONTRACT RELATED TABLES*************************************************************

--*******************************************************************Purge Reservation Related Tables *********************************************************

SELECT distinct confirmation_number into #Reservation_Temp  
FROM dbo.Reservation
WHERE	( 
	      (Confirmation_Number NOT IN
	                          (SELECT     confirmation_number
	                            FROM          contract
	                            WHERE      confirmation_number IS NOT NULL)
	       ) 
	       AND (Status <> 'A') 
	       AND (Pick_Up_On <  @cutOffDate)
)

SELECT distinct * into #Reservation_Archive
FROM dbo.Reservation
WHERE	( 
	      (Confirmation_Number  IN (SELECT confirmation_number FROM #Reservation_Temp)
	       ) 
	       
      	)
        OR
        (
		(confirmation_number in (select Confirmation_number from #Contract_Archive)) 
		AND (Confirmation_number not in (select #Reservation_Temp.confirmation_number from #Reservation_Temp)) 
        )       


SELECT   dbo.Reservation.* into #MaestroRes_Archive 
FROM         dbo.Reservation
WHERE     (Pick_Up_On < @cutOffDate) AND (Source_Code = 'Maestro' or dbo.Reservation.Quoted_Rate_ID is not null) AND (Status <> 'A') AND (Confirmation_Number NOT IN
                          (SELECT     Confirmation_Number
                            FROM          contract
                            WHERE      Confirmation_Number IS NOT NULL))

Delete AR_Export
--SELECT     dbo.AR_Export.*
FROM #Reservation_Archive  INNER JOIN
                      dbo.AR_Export ON #Reservation_Archive.Confirmation_Number = dbo.AR_Export.Confirmation_Number

delete AR_Transactions
--SELECT     dbo.AR_Transactions.* 
FROM         #Reservation_Archive INNER JOIN
                      dbo.Business_Transaction ON #Reservation_Archive.Confirmation_Number = dbo.Business_Transaction.Confirmation_Number INNER JOIN
                      dbo.AR_Transactions ON dbo.Business_Transaction.Business_Transaction_ID = dbo.AR_Transactions.Business_Transaction_ID

delete Sales_Journal
--SELECT      dbo.Sales_Journal.*
FROM         #Reservation_Archive  INNER JOIN
                      dbo.Business_Transaction ON #Reservation_Archive .Confirmation_Number = dbo.Business_Transaction.Confirmation_Number INNER JOIN
                      dbo.Sales_Journal ON dbo.Business_Transaction.Business_Transaction_ID = dbo.Sales_Journal.Business_Transaction_ID

delete Reservation_Change_History
--SELECT     Reservation_Change_History.*
FROM         #Reservation_Archive  INNER JOIN
                      dbo.Reservation_Change_History ON #Reservation_Archive.Confirmation_Number  = dbo.Reservation_Change_History.Confirmation_Number

delete dbo.Reservation_CC_Dep_Payment
--SELECT    dbo.Reservation_CC_Dep_Payment.*  
FROM         #Reservation_Archive  INNER JOIN
                      dbo.Reservation_CC_Dep_Payment ON #Reservation_Archive.Confirmation_Number  = dbo.Reservation_CC_Dep_Payment.Confirmation_Number

delete  dbo.Reservation_Cash_Dep_Payment
--SELECT    Reservation_Cash_Dep_Payment.* 
FROM         #Reservation_Archive  INNER JOIN
                      dbo.Reservation_Cash_Dep_Payment ON 
                      #Reservation_Archive.Confirmation_Number  = dbo.Reservation_Cash_Dep_Payment.Confirmation_Number


delete dbo.Reservation_Dep_Payment
--SELECT    Reservation_Dep_Payment.* 
FROM         #Reservation_Archive  INNER JOIN
                      dbo.Reservation_Dep_Payment ON #Reservation_Archive.Confirmation_Number  = dbo.Reservation_Dep_Payment.Confirmation_Number


delete Reserved_Rental_Accessory
--SELECT     Reserved_Rental_Accessory.*
FROM         #Reservation_Archive  INNER JOIN
                      dbo.Reserved_Rental_Accessory ON #Reservation_Archive.Confirmation_Number  = dbo.Reserved_Rental_Accessory.Confirmation_Number

delete Reserved_Sales_Accessory
--SELECT     Reserved_Sales_Accessory.*
FROM         #Reservation_Archive  INNER JOIN
                      dbo.Reserved_Sales_Accessory ON #Reservation_Archive.Confirmation_Number  = dbo.Reserved_Sales_Accessory.Confirmation_Number

Delete Business_Transaction
--SELECT     Business_Transaction.*  
FROM         #Reservation_Archive  INNER JOIN
                      dbo.Business_Transaction ON #Reservation_Archive.Confirmation_Number  = dbo.Business_Transaction.Confirmation_Number


Delete dbo.Reservation
--SELECT    dbo.Reservation.* 
FROM         dbo.Reservation  INNER join #Reservation_Archive on dbo.Reservation.Confirmation_Number = #Reservation_Archive.Confirmation_Number  


delete Quoted_Rate_Category
--SELECT     dbo.Quoted_Vehicle_Rate.*
FROM          #MaestroRes_Archive  INNER JOIN
                      dbo.Quoted_Vehicle_Rate ON #MaestroRes_Archive.Quoted_Rate_ID = dbo.Quoted_Vehicle_Rate.Quoted_Rate_ID INNER JOIN
                      dbo.Quoted_Rate_Category ON dbo.Quoted_Vehicle_Rate.Quoted_Rate_ID = dbo.Quoted_Rate_Category.Quoted_Rate_ID

Delete Quoted_Rate_Restriction
--SELECT     dbo.Quoted_Vehicle_Rate.*
FROM         #MaestroRes_Archive INNER JOIN
                      dbo.Quoted_Vehicle_Rate ON #MaestroRes_Archive.Quoted_Rate_ID = dbo.Quoted_Vehicle_Rate.Quoted_Rate_ID INNER JOIN
                      dbo.Quoted_Rate_Restriction ON dbo.Quoted_Vehicle_Rate.Quoted_Rate_ID = dbo.Quoted_Rate_Restriction.Quoted_Rate_ID


Delete     Quoted_Time_Period_Rate
--select Quoted_Time_Period_Rate.*
FROM         #MaestroRes_Archive INNER JOIN
                      dbo.Quoted_Vehicle_Rate ON #MaestroRes_Archive.Quoted_Rate_ID = dbo.Quoted_Vehicle_Rate.Quoted_Rate_ID INNER JOIN
                      dbo.Quoted_Time_Period_Rate ON dbo.Quoted_Vehicle_Rate.Quoted_Rate_ID = dbo.Quoted_Time_Period_Rate.Quoted_Rate_ID

Delete dbo.Quoted_Vehicle_Rate
--SELECT     dbo.Quoted_Vehicle_Rate.*
FROM         #MaestroRes_Archive INNER JOIN
                      dbo.Quoted_Vehicle_Rate ON #MaestroRes_Archive.Quoted_Rate_ID = dbo.Quoted_Vehicle_Rate.Quoted_Rate_ID 
where dbo.Quoted_Vehicle_Rate.Quoted_Rate_ID  not in (select Quoted_Rate_ID from contract)

/*select * from reservation where Quoted_Rate_ID in (SELECT  dbo.Quoted_Vehicle_Rate.Quoted_Rate_ID   
FROM         #Contract_Archive INNER JOIN
                      dbo.Quoted_Vehicle_Rate ON #Contract_Archive.Quoted_Rate_ID = dbo.Quoted_Vehicle_Rate.Quoted_Rate_ID)

select * from  #Contract_Archive where confirmation_number in (select confirmation_number from reservation where Quoted_Rate_ID in (SELECT  dbo.Quoted_Vehicle_Rate.Quoted_Rate_ID   
FROM         #Contract_Archive INNER JOIN
                      dbo.Quoted_Vehicle_Rate ON #Contract_Archive.Quoted_Rate_ID = dbo.Quoted_Vehicle_Rate.Quoted_Rate_ID))

*/



--******************************************************************************************************************************************************
-- Purge Rats
exec PurgeGISRATETABLES

--********************************************************************************************************************************************************
--**********************************Purge Vehicle Related Tables************************************************************

SELECT * into #Vehicle_Archive
FROM         dbo.Vehicle v
WHERE     (v.unit_number NOT IN
           (SELECT     unit_number FROM          vehicle_on_contract)
) 
and (v.Current_Vehicle_Status = 'i')  and ( v.Vehicle_Status_Effective_On<@cutOffDate )

-----------------------------------------Delete Movement Related Vehicle Support Incicent-------------------------------------------------

-- To Speed up the delete process

SELECT     dbo.Vehicle_Support_Incident.* INTO #Vehicle_Support_Incident_MV_Archive
FROM         dbo.Vehicle_Support_Incident INNER JOIN
                      dbo.Vehicle_Movement ON dbo.Vehicle_Support_Incident.Unit_Number = dbo.Vehicle_Movement.Unit_Number AND 
                      dbo.Vehicle_Support_Incident.Movement_Out = dbo.Vehicle_Movement.Movement_Out INNER JOIN
                      #Vehicle_Archive ON dbo.Vehicle_Movement.Unit_Number = #Vehicle_Archive.Unit_Number



delete   dbo.Mechanical_Incident  
--SELECT     dbo.Mechanical_Incident.*
FROM       dbo.Mechanical_Incident INNER JOIN #Vehicle_Support_Incident_MV_Archive on #Vehicle_Support_Incident_MV_Archive.Vehicle_Support_Incident_Seq = dbo.Mechanical_Incident.Vehicle_Support_Incident_Seq
                      
     

delete   dbo.Damage_Incident  
--SELECT     dbo.Damage_Incident.*
FROM         #Vehicle_Support_Incident_MV_Archive INNER JOIN
                      dbo.Damage_Incident ON #Vehicle_Support_Incident_MV_Archive.Vehicle_Support_Incident_Seq = dbo.Damage_Incident.Vehicle_Support_Incident_Seq 

--Seizure_Incident
delete   dbo.Seizure_Incident  
--SELECT     dbo.Seizure_Incident.*
FROM         #Vehicle_Support_Incident_MV_Archive INNER JOIN
                      dbo.Seizure_Incident ON 
                      #Vehicle_Support_Incident_MV_Archive.Vehicle_Support_Incident_Seq = dbo.Seizure_Incident.Vehicle_Support_Incident_Seq 

--Stolen_Incident
delete Stolen_Incident
--SELECT     dbo.Stolen_Incident.*
FROM         #Vehicle_Support_Incident_MV_Archive INNER JOIN
                      dbo.Stolen_Incident ON #Vehicle_Support_Incident_MV_Archive.Vehicle_Support_Incident_Seq = dbo.Stolen_Incident.Vehicle_Support_Incident_Seq 

delete   dbo.Vehicle_Support_Comment  
--SELECT     dbo.Vehicle_Support_Comment.*
FROM         #Vehicle_Support_Incident_MV_Archive INNER JOIN
                      dbo.Vehicle_Support_Comment ON 
                      #Vehicle_Support_Incident_MV_Archive.Vehicle_Support_Incident_Seq = dbo.Vehicle_Support_Comment.Vehicle_Support_Incident_Seq 

Delete dbo.Vehicle_Support_Action_Log 
--SELECT     dbo.Vehicle_Support_Action_Log.*
FROM         #Vehicle_Support_Incident_MV_Archive INNER JOIN
                      dbo.Vehicle_Support_Action_Log ON 
                      #Vehicle_Support_Incident_MV_Archive.Vehicle_Support_Incident_Seq = dbo.Vehicle_Support_Action_Log.Vehicle_Support_Incident_Seq 

delete Vehicle_Support_Purchase_Order
--SELECT     dbo.Vehicle_Support_Purchase_Order.*
FROM         #Vehicle_Support_Incident_MV_Archive INNER JOIN
                      dbo.Vehicle_Support_Purchase_Order ON 
                      #Vehicle_Support_Incident_MV_Archive.Vehicle_Support_Incident_Seq = dbo.Vehicle_Support_Purchase_Order.Vehicle_Support_Incident_Seq 

delete Contract_Charge_Item
--SELECT     dbo.Contract_Charge_Item.*
FROM        #Vehicle_Support_Incident_MV_Archive INNER JOIN
                      dbo.Contract_Charge_Item ON 
                      #Vehicle_Support_Incident_MV_Archive.Vehicle_Support_Incident_Seq = dbo.Contract_Charge_Item.Vehicle_Support_Incident_Seq 


delete Contract_Charge_Item_Audit
--SELECT     dbo.Contract_Charge_Item_Audit.*
FROM         #Vehicle_Support_Incident_MV_Archive INNER JOIN
                      dbo.Contract_Charge_Item_Audit ON 
                      #Vehicle_Support_Incident_MV_Archive.Vehicle_Support_Incident_Seq = dbo.Contract_Charge_Item_Audit.Vehicle_Support_Incident_Seq 

delete Contract_Reimbur_and_Discount
--SELECT     dbo.Contract_Reimbur_and_Discount.*
FROM        #Vehicle_Support_Incident_MV_Archive INNER JOIN
                      dbo.Contract_Reimbur_and_Discount ON 
                      #Vehicle_Support_Incident_MV_Archive.Vehicle_Support_Incident_Seq = dbo.Contract_Reimbur_and_Discount.Vehicle_Support_Incident_Seq 

Delete  dbo.Vehicle_Support_Incident  
--Select dbo.Vehicle_Support_Incident.*  
FROM   dbo.Vehicle_Support_Incident INNER JOIN #Vehicle_Support_Incident_MV_Archive 
 on dbo.Vehicle_Support_Incident.Vehicle_Support_Incident_Seq= #Vehicle_Support_Incident_MV_Archive.Vehicle_Support_Incident_Seq

---------------------------------------------end of Movement Rated Vehicle Support Incicent-------------------------------------------------------------

Delete Vehicle_Location_Restriction
--SELECT  Vehicle_Location_Restriction.*    
FROM         #Vehicle_Archive INNER JOIN
                      dbo.Vehicle_Location_Restriction ON #Vehicle_Archive.Unit_Number = dbo.Vehicle_Location_Restriction.Unit_Number

Delete Vehicle_History
--SELECT  Vehicle_History.*   
FROM         #Vehicle_Archive INNER JOIN
             dbo.Vehicle_History ON #Vehicle_Archive.Unit_Number = dbo.Vehicle_History.Unit_Number

Delete dbo.Vehicle_Installed_Option
--SELECT   dbo.Vehicle_Installed_Option.*  
FROM         #Vehicle_Archive INNER JOIN
                      dbo.Vehicle_Installed_Option ON #Vehicle_Archive.Unit_Number = dbo.Vehicle_Installed_Option.Unit_Number

Delete dbo.Vehicle_Licence_History
--SELECT     dbo.Vehicle_Licence_History.*
FROM         #Vehicle_Archive INNER JOIN
                      dbo.Vehicle_Licence_History ON #Vehicle_Archive.Unit_Number = dbo.Vehicle_Licence_History.Unit_Number

Delete dbo.Override_Movement_Completion
--SELECT     dbo.Override_Movement_Completion.*
FROM         #Vehicle_Archive INNER JOIN
                      dbo.Vehicle_Movement ON #Vehicle_Archive.Unit_Number = dbo.Vehicle_Movement.Unit_Number INNER JOIN
                      dbo.Override_Movement_Completion ON dbo.Vehicle_Movement.Unit_Number = dbo.Override_Movement_Completion.Unit_Number AND 
                      dbo.Vehicle_Movement.Movement_Out = dbo.Override_Movement_Completion.Movement_Out

Delete dbo.Vehicle_Movement
--SELECT    dbo.Vehicle_Movement.* 
FROM        #Vehicle_Archive INNER JOIN
                      dbo.Vehicle_Movement ON #Vehicle_Archive.Unit_Number = dbo.Vehicle_Movement.Unit_Number

Delete Condition_History
--SELECT Condition_History.*     
FROM         #Vehicle_Archive INNER JOIN
                      dbo.Condition_History ON #Vehicle_Archive.Unit_Number = dbo.Condition_History.Unit_Number


Delete  dbo.Vehicle_Location_Restriction
--SELECT  dbo.Vehicle_Location_Restriction.*    
FROM         #Vehicle_Archive INNER JOIN
                      dbo.Vehicle_Location_Restriction ON #Vehicle_Archive.Unit_Number = dbo.Vehicle_Location_Restriction.Unit_Number

Delete dbo.Vehicle_Service 
--SELECT  dbo.Vehicle_Service.*   
FROM         dbo.Vehicle_Service INNER JOIN
                      #Vehicle_Archive ON dbo.Vehicle_Service.Unit_Number = #Vehicle_Archive.Unit_Number
                      
                      
-- Fleet Accounting

Delete FA_Lease_Amortization
--SELECT dbo.FA_Lease_Amortization.*
FROM  dbo.FA_Lease_Amortization INNER JOIN
               #Vehicle_Archive ON dbo.FA_Lease_Amortization.Unit_number = #Vehicle_Archive.Unit_Number
               
Delete	FA_Loan_Amortization
--SELECT dbo.FA_Loan_Amortization.*
FROM  dbo.FA_Loan_Amortization INNER JOIN
                #Vehicle_Archive ON dbo.FA_Loan_Amortization.Unit_Number = #Vehicle_Archive.Unit_Number
                
Delete   FA_Vehicle_Amortization              
--SELECT dbo.FA_Vehicle_Amortization.*
FROM  dbo.FA_Vehicle_Amortization INNER JOIN
               #Vehicle_Archive ON dbo.FA_Vehicle_Amortization.Unit_Number = #Vehicle_Archive.Unit_Number                

Delete FA_Vehicle_Depreciation_History 
--SELECT dbo.FA_Vehicle_Depreciation_History.*
FROM  dbo.FA_Vehicle_Depreciation_History INNER JOIN
               #Vehicle_Archive ON dbo.FA_Vehicle_Depreciation_History.Unit_Number = #Vehicle_Archive.Unit_Number               
               
Delete  FA_Vehicle_Lease_History             
--SELECT dbo.FA_Vehicle_Lease_History.*
FROM  dbo.FA_Vehicle_Lease_History INNER JOIN
              #Vehicle_Archive ON dbo.FA_Vehicle_Lease_History.Unit_Number = #Vehicle_Archive.Unit_Number
                                                    

Delete vehicle from Vehicle Inner Join  #Vehicle_Archive ON dbo.Vehicle.Unit_Number = #Vehicle_Archive.Unit_Number


--Purge License Plate

Delete  Vehicle_Licence_History
--SELECT    dbo.Vehicle_Licence_History.*  
FROM         #Vehicle_Archive INNER JOIN
                      dbo.Vehicle_Licence_History ON #Vehicle_Archive.Unit_Number = dbo.Vehicle_Licence_History.Unit_Number

Delete Vehicle_Licence
--SELECT     Licence_Plate_Number
FROM         Vehicle_Licence where (Licence_Plate_Number not In (select Current_Licence_Plate from vehicle)) and (Licence_Plate_Number not in (select Licence_Plate_Number from Vehicle_Licence_History))


--Purge Any misc data

Delete maestro where maestro.Transaction_Date<GETDATE() - 365

delete Batch_Error_Log
where [Process_Date]< @cutOffDate

DELETE FROM RP_Acc_7_CSR_Performance_Contract_Rates

delete    RP_Acc_7_CSR_Performance_Reservation_Rates

Delete dbo.Location_Vehicle_Rate_Level
--SELECT     dbo.Location_Vehicle_Class.Valid_From, dbo.Location_Vehicle_Class.Valid_To
FROM         dbo.Location_Vehicle_Rate_Level INNER JOIN
                      dbo.Location_Vehicle_Class ON 
                      dbo.Location_Vehicle_Rate_Level.Location_Vehicle_Class_ID = dbo.Location_Vehicle_Class.Location_Vehicle_Class_ID
where dbo.Location_Vehicle_Class.Valid_To<@cutOffDate

Delete dbo.Location_Vehicle_Class
--SELECT     Location_Vehicle_Class.*
where dbo.Location_Vehicle_Class.Valid_To<@cutOffDate
 
Delete 
--select * from
dbo.Location_Vehicle_Rate_Level 
where Valid_To<@cutOffDate




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

And (
Customer_ID IS Null 
)
   --or 
   --Customer_ID not in (select Customer_ID from customer where program_Number is not null and program_Number<>'')) 


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



return 1

 

GO
