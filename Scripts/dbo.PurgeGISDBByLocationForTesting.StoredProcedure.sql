USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[PurgeGISDBByLocationForTesting]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


Create Procedure [dbo].[PurgeGISDBByLocationForTesting]
as
--***************************************************************DELETE SALES ACCESSORY **************************************************************************

SELECT DISTINCT dbo.Sales_Accessory_Sale_Contract.*
INTO            #Sales_Accessory_Sale_Contract_Org_Archive
from  dbo.Sales_Accessory_Sale_Contract where Sold_At_Location_ID in (16,13,168,26,31,43,57,99,59,150,151,154,156,157,158,159,161,169,188,187,189,62,164)


SELECT dbo.Sales_Accessory_Sale_Contract.*  into #Sales_Accessory_Sale_Contract_Refund_Archive    
--delete dbo.Sales_Accessory_Sale_Contract 
FROM         dbo.Sales_Accessory_Sale_Contract INNER JOIN
                      #Sales_Accessory_Sale_Contract_Org_Archive ON 
                      dbo.Sales_Accessory_Sale_Contract.Refunded_Contract_No = #Sales_Accessory_Sale_Contract_Org_Archive.Sales_Contract_Number

--Insert Into   #Sales_Accessory_Sale_Contract_Archive 

select distinct s.* Into   #Sales_Accessory_Sale_Contract_Archive from (
select * from #Sales_Accessory_Sale_Contract_Org_Archive
union
select * from  #Sales_Accessory_Sale_Contract_Refund_Archive
)s


/*FROM         dbo.Business_Transaction INNER JOIN
                      dbo.Sales_Accessory_Sale_Contract ON 
                      dbo.Business_Transaction.Sales_Contract_Number = dbo.Sales_Accessory_Sale_Contract.Sales_Contract_Number
WHERE     (dbo.Business_Transaction.Transaction_Type = 'sls') AND (dbo.Business_Transaction.Location_ID in (16,13,168,26,31,43,57,99,59,150,151,154,156,157,158,159,161,169,188,187,189,62,164))
*/


select dbo.Business_Transaction.*  into #Sls_BT_Archive
FROM         dbo.Business_Transaction INNER JOIN
                      #Sales_Accessory_Sale_Contract_Archive ON 
                      dbo.Business_Transaction.Sales_Contract_Number = #Sales_Accessory_Sale_Contract_Archive.Sales_Contract_Number

/*
insert into #Sls_BT_Archive select dbo.Business_Transaction.*  
FROM         dbo.Business_Transaction INNER JOIN
                      #Sales_Accessory_Sale_Contract_Refund_Archive   ON 
                      dbo.Business_Transaction.Sales_Contract_Number = #Sales_Accessory_Sale_Contract_Refund_Archive.Sales_Contract_Number

*/
--select * from #Sales_Accessory_Sale_Contract_Refund_Archive

--select * from #Sls_BT_Archive where Sales_Contract_Number=9212 

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



--SELECT     
/*delete dbo.Sales_Accessory_Sale_Contract 
FROM         dbo.Sales_Accessory_Sale_Contract INNER JOIN
                      #Sales_Accessory_Sale_Contract_Archive ON 
                      dbo.Sales_Accessory_Sale_Contract.Refunded_Contract_No = #Sales_Accessory_Sale_Contract_Archive.Sales_Contract_Number
*/

DELETE Sales_Accessory_Sale_Contract
--SELECT     Sales_Accessory_Sale_Contract.*
FROM         #Sales_Accessory_Sale_Contract_Refund_Archive INNER JOIN
                      dbo.Sales_Accessory_Sale_Contract ON 
                      #Sales_Accessory_Sale_Contract_Refund_Archive.Sales_Contract_Number = dbo.Sales_Accessory_Sale_Contract.Sales_Contract_Number

--select * from #Sales_Accessory_Sale_Contract_Refund_Archive


DELETE Sales_Accessory_Sale_Contract
--SELECT     Sales_Accessory_Sale_Contract.*
FROM         #Sales_Accessory_Sale_Contract_Archive INNER JOIN
                      dbo.Sales_Accessory_Sale_Contract ON 
                      #Sales_Accessory_Sale_Contract_Archive.Sales_Contract_Number = dbo.Sales_Accessory_Sale_Contract.Sales_Contract_Number



--********************************************************END OF DELETING SALES ACCESSORY CONTRAT**************************************************************

--*********************************************************CONTRACT RELATED TABLES ****************************************************************************

/*SELECT    distinct  dbo.Contract.* into #Contract_Archive 
FROM         dbo.Contract INNER JOIN
                      dbo.Business_Transaction ON dbo.Contract.Contract_Number = dbo.Business_Transaction.Contract_Number
WHERE     (dbo.Business_Transaction.Transaction_Type = 'Con') AND (dbo.Business_Transaction.Transaction_Description IN ('Check In', 'Foreign Check In')) AND
                       (dbo.Business_Transaction.Location_ID in (16,13,168,26,31,43,57,99,59,150,151,154,156,157,158,159,161,169,188,187,189,62,164))

*/

--SELECT    distinct  dbo.Contract.* into #Contract_Archive 


--Delete all Cancel or Void Contracts
select * into #Contract_Archive_1 from contract  where (contract.Pick_Up_Location_ID in (16,13,168,26,31,43,57,99,59,150,151,154,156,157,158,159,161,169,188,187,189,62,164) or  Drop_Off_Location_ID in (16,13,168,26,31,43,57,99,59,150,151,154,156,157,158,159,161,169,188,187,189,62,164))



SELECT    distinct  dbo.Contract.* into #Contract_Archive_2 
FROM         dbo.Contract INNER JOIN
                      dbo.Business_Transaction ON dbo.Contract.Contract_Number = dbo.Business_Transaction.Contract_Number
WHERE     (dbo.Business_Transaction.Transaction_Type = 'Con')  AND  (dbo.Business_Transaction.Location_ID in (16,13,168,26,31,43,57,99,59,150,151,154,156,157,158,159,161,169,188,187,189,62,164))

SELECT    distinct  c.* into #Contract_Archive from (select * from #Contract_Archive_1 union select * from #Contract_Archive_2) c


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
-- Reservation Not Opened
SELECT distinct confirmation_number into #Reservation_Temp  
FROM dbo.Reservation
WHERE	( 
	      (Confirmation_Number NOT IN
	                          (SELECT     confirmation_number
	                            FROM          contract
	                            WHERE      confirmation_number IS NOT NULL)
	       ) 
	       --AND (Status <> 'A') 
	       AND (
			(Pick_Up_Location_ID in (16,13,168,26,31,43,57,99,59,150,151,154,156,157,158,159,161,169,188,187,189,62,164))
			or (Drop_off_location_id in (16,13,168,26,31,43,57,99,59,150,151,154,156,157,158,159,161,169,188,187,189,62,164))
                    )
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
WHERE     ( 
              (Pick_Up_Location_ID in (16,13,168,26,31,43,57,99,59,150,151,154,156,157,158,159,161,169,188,187,189,62,164))
              
               or (Drop_off_location_id in (16,13,168,26,31,43,57,99,59,150,151,154,156,157,158,159,161,169,188,187,189,62,164))



             ) AND (Source_Code = 'Maestro' or dbo.Reservation.Quoted_Rate_ID is not null)  AND (Confirmation_Number NOT IN
                          (SELECT     Confirmation_Number
                            FROM          contract
                            WHERE      Confirmation_Number IS NOT NULL))




Delete AR_Export
--SELECT     dbo.AR_Export.*
FROM #Reservation_Archive  INNER JOIN
                      dbo.AR_Export ON #Reservation_Archive.Confirmation_Number = dbo.AR_Export.Confirmation_Number

delete AR_Transactions
--SELECT     dbo.AR_Transactions.* 
FROM         dbo.Reservation INNER JOIN
                      dbo.Business_Transaction ON dbo.Reservation.Confirmation_Number = dbo.Business_Transaction.Confirmation_Number INNER JOIN
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


--******************************************************************************************************************************************************
-- Purge Rats
exec PurgeGISRATETABLES

-- Purge Accounting Data
Delete AR_Export where Location_ID in (16,13,168,26,31,43,57,99,59,150,151,154,156,157,158,159,161,169,188,187,189,62,164)

-- Purge Credit Card_daily_total

Delete dbo.Terminal_Daily_Total
--SELECT     dbo.Terminal.Location_ID
FROM         dbo.Terminal_Daily_Total INNER JOIN
                      dbo.Terminal ON dbo.Terminal_Daily_Total.Terminal_ID = dbo.Terminal.Terminal_ID
where  Location_ID in (16,13,168,26,31,43,57,99,59,150,151,154,156,157,158,159,161,169,188,187,189,62,164)

--Soft Delete Location

update location set delete_flag=1 where Location_ID in (16,13,168,26,31,43,57,99,59,150,151,154,156,157,158,159,161,169,188,187,189,62,164)


GO
