USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Con_1_Perfect_Drive_Point_Submission]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO










/*
PROCEDURE NAME: RP_SP_Con_1_Perfect_Drive_Point_Submission
PURPOSE: Select all information needed for Perfect Drive Point Submission Report

AUTHOR:	Joseph Tseung
DATE CREATED: 1999/09/20
USED BY:  Perfect Drive Point Submission Report
MOD HISTORY:
Name 		Date		Comments

*/

CREATE PROCEDURE [dbo].[RP_SP_Con_1_Perfect_Drive_Point_Submission]
(
	@paramStartDODate varchar(20) = '01 Janl 1999',
	@paramEndDODate varchar(20) = '31 May 1999',
	@paramPULocID varchar(20) = '*'
)
AS
-- convert strings to datetime
DECLARE	@startDODate datetime,
	@endDODate datetime

SELECT	@startDODate	= CONVERT(datetime, '00:00:00 ' + @paramStartDODate),
	@endDODate	= CONVERT(datetime, '23:59:59 ' + @paramEndDODate)	

-- fix upgrading problem (SQL7->SQL2000)

DECLARE  @tmpLocID varchar(20)

if @paramPULocID = '*'
	BEGIN
		SELECT @tmpLocID='0'
        END
else
	BEGIN
		SELECT @tmpLocID = @paramPULocID
	END 

-- end of fixing the problem

SELECT 	
	Customer.Program_Number AS BCN_Number,
    	Contract.Last_Name,
	Contract.First_Name,
    	Frequent_Flyer_Plan.Maestro_Code AS Airline_Code,
    	Contract.FF_Member_Number,
	Contract.Contract_Number,
    	Contract.Vehicle_Class_Code,
    	SUM(Contract_Charge_Item.Amount)
    	+ SUM(Contract_Charge_Item.GST_Amount)
    	+ SUM(Contract_Charge_Item.PST_Amount)
    	+ SUM(Contract_Charge_Item.PVRT_Amount)	AS Total_Charge,
    	Location1.Location_ID AS Pick_Up_Location_ID,
    	Location1.Corporate_Location_ID	AS Int_Pick_Up_Location_ID,
    	Location1.Location AS Pick_Up_Location_Name,
    	Location.Corporate_Location_ID AS Int_Drop_Off_Location_ID,
    	Location.Location AS Drop_Off_Location_Name,
    	Contract.Pick_Up_On,
	voc.Actual_Check_In AS Drop_Off_On,
    	Contract.IATA_Number
FROM 	Contract with(nolock) 	
	INNER JOIN
    	Vehicle_On_Contract voc
		ON Contract.Contract_Number = voc.Contract_Number
	INNER JOIN
    	Contract_Charge_Item
		ON Contract.Contract_Number = Contract_Charge_Item.Contract_Number
     	INNER JOIN
    	Reservation
		ON Contract.Confirmation_Number = Reservation.Confirmation_Number
	INNER JOIN
	Customer
		ON Reservation.Customer_ID = Customer.Customer_ID
     	INNER JOIN
    	Location
		ON Contract.Drop_Off_Location_ID = Location.Location_ID
	INNER JOIN
    	Location Location1
		ON Contract.Pick_Up_Location_ID = Location1.Location_ID
		AND Location1.Rental_Location = 1 -- location has to be rental location
	INNER JOIN
	Lookup_Table
		ON Lookup_Table.Code = Location1.Owning_Company_ID
		AND Lookup_Table.Category = 'BudgetBC Company'	-- pick up location has to be owned by BRAC BC	
	LEFT OUTER JOIN
    	Frequent_Flyer_Plan
		ON Contract.Frequent_Flyer_Plan_ID = Frequent_Flyer_Plan.Frequent_Flyer_Plan_ID
WHERE 	
	(Reservation.Perfect_Drive_Indicator = 1)
	AND (Contract.Status = 'CI')
	AND (Contract_Charge_Item.Charge_Type IN ('10', '11', '12', '13', '20', '30', '31', '33', '34', '50', '51', '52'))

/* 	
	10  = Time Charge
	11 = KM Charge
	12 = Optional Extra
	13 = Sales Accessory	
	20 = Upgrade Charge
	30 = Location fee
	31 = Location Surcharge Charge
	33 = Drop Charge
	34 = Additional Driver Charge
	50 = Flex Discount (-ve)
	51 = Member Discount (-ve)
	52 = Contract Discount (-ve)
*/
	AND
	(@paramPULocID = "*" or CONVERT(INT, @tmpLocID) = Location1.Location_ID)
	AND
	voc.Actual_Check_In BETWEEN @startDODate AND @endDODate

GROUP BY 	
		
	Customer.Program_Number,
	Contract.Last_Name,
	Contract.First_Name,
  	Frequent_Flyer_Plan.Maestro_Code,
    	Contract.FF_Member_Number,
	Contract.Contract_Number,
    	Contract.Vehicle_Class_Code,
	Contract.IATA_Number,
    	Location1.Corporate_Location_ID,
    	Location.Corporate_Location_ID,
	Contract.Pick_Up_On,
    	voc.Actual_Check_In,
	Location1.Location,
	Location.Location,
    	Location1.Location_ID

GO
