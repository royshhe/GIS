USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Acc_7_CSR_Performance_Report_Main]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








/*
PROCEDURE NAME: RP_SP_Acc_7_CSR_Performance_Report_Main
PURPOSE: Select all the information needed for CSR Performance Report.
	
AUTHOR:	Nenad Ukropina
DATE CREATED: 1999/01/01
USED BY: CSR Performance Report
MOD HISTORY:
Name 		Date		Comments
Joseph Tseung	2000/04/19	Fix dates conversion to improve performance
*/

CREATE PROCEDURE [dbo].[RP_SP_Acc_7_CSR_Performance_Report_Main] --'Car','20','Check Out','2012/01/28','2012/01/28','*','*'
(
	@Vehicle_Type		VARCHAR(5)  	= 'Car',	
	@Location_ID		VARCHAR(10) 	= '*',	
	@Check_In_Or_Out	VARCHAR(9)     	= 'Check In',
	@RBR_Start_Date 	varchar(10) 	= '1999/04/23',
	@RBR_End_Date 	varchar(10) 	= '1999/04/23',
	@CSR_Name		VARCHAR(20) 	= '*',
	@Rate_Name		VARCHAR(25) 	= '*'
)	

AS

-- convert strings to datetime
DECLARE @startDate datetime,
	@endDate datetime

SELECT	@startDate	= CONVERT(datetime,  @RBR_Start_Date+' 00:00:00'),
	@endDate	= CONVERT(datetime,  @RBR_End_Date+' 23:59:59')	

-- fix upgrading problem (SQL7->SQL2000)

DECLARE  @tmpLocID varchar(20)

if @Location_ID = '*'
	BEGIN
		SELECT @tmpLocID='0'
        END
else
	BEGIN
		SELECT @tmpLocID = @Location_ID
	END 

-- end of fixing the problem

-- Used to store Report Run ID
DECLARE @iRunID int

-- Create report run id.
INSERT
  INTO	RP_Run	
	(
	Report_Name,
	Run_On
	)
VALUES	(
	'Acc_7_CSR_Perfomance',
	GETDATE()
	)

-- Get the value of the Run ID that was just inserted
SELECT @iRunID = @@IDENTITY

-- Get All Reservation Rates
INSERT
  INTO	RP_Acc_7_CSR_Performance_Reservation_Rates
SELECT	@iRunID,
	RR.*
--select  *
  FROM	RP_Acc_7_CSR_Performance_Reservation_Rates_L2_Base_2 RR with(nolock)
		inner join (SELECT 	Reservation.Confirmation_Number as Confirmation_Number, 
   	(case when Vehicle_Rate.Rate_Name is not null
				then  Vehicle_Rate.Rate_Name
		  when Quoted_Vehicle_Rate.Rate_Name is not null
				then Quoted_Vehicle_Rate.Rate_Name
		  else ''
	end)  as Rate_Name
FROM 	Reservation  WITH(NOLOCK)
	left JOIN
   	Vehicle_Rate 
		ON Reservation.Rate_ID = Vehicle_Rate.Rate_ID 
		AND Reservation.Date_Rate_Assigned >= Vehicle_Rate.Effective_Date
    		AND Reservation.Date_Rate_Assigned <= Vehicle_Rate.Termination_Date
	left join Quoted_Vehicle_Rate with (NOLOCK)
		ON Quoted_Vehicle_Rate.Quoted_Rate_ID = Reservation.Quoted_Rate_ID ) Res_Rate
		on Res_Rate.Confirmation_Number=RR.Confirmation_Number and Res_Rate.Rate_Name=RR.Rate_Name

	
-- Get All Contract Rates
INSERT
  INTO	RP_Acc_7_CSR_Performance_Contract_Rates
SELECT	@iRunID,
	RP_Acc_7_CSR_Performance_Contract_Rates_L2_Base_2.*
  FROM	RP_Acc_7_CSR_Performance_Contract_Rates_L2_Base_2 with(nolock)

-- return the result
SELECT 	RP_Acc_7_CSR_Performance_Contract_Reservation_Info_L1_Base_1.Vehicle_Type_ID,
    	RP_Acc_7_CSR_Performance_Contracts_L1_Main_1.Contract_Opened_At_Location_ID,
    	RP_Acc_7_CSR_Performance_Contracts_L1_Main_1.Contract_Opened_At_Location_Name,
    	RP_Acc_7_CSR_Performance_Contracts_L1_Main_1.RBR_Date,
   	RP_Acc_7_CSR_Performance_Contracts_L1_Main_1.Contract_Number,
    	RP_Acc_7_CSR_Performance_Contracts_L1_Main_1.Confirmation_Number,
    	RP_Acc_7_CSR_Performance_Contracts_L1_Main_1.Transaction_Description,
    	RP_Acc_7_CSR_Performance_Contracts_L1_Main_1.User_ID,
    	RP_Acc_7_CSR_Performance_Contract_Reservation_Info_L1_Base_1.Status,
    	RP_Acc_7_CSR_Performance_Contract_Reservation_Info_L1_Base_1.Rez_Src,
    	RP_Acc_7_CSR_Performance_Contract_Reservation_Info_L1_Base_1.Rez_CS,
    	RP_Acc_7_CSR_Performance_Contract_Reservation_Info_L1_Base_1.Upgd_Sub,
    	RP_Acc_7_CSR_Performance_Reservation_Rates.Rate_Name			AS Rez_Rate_Name,
   	RP_Acc_7_CSR_Performance_Contract_Reservation_Info_L1_Base_1.Rez_Rate_Level	AS Rez_Rate_Level,
   	Rez_Daily_Rate =
		ISNULL(CAST(RP_Acc_7_CSR_Performance_Reservation_Rates.Daily_Rate AS varchar(10)), '-'),		
   	Rez_Weekly_Rate =
		ISNULL(CAST(RP_Acc_7_CSR_Performance_Reservation_Rates.Weekly_Rate AS varchar(10)), '-'),
   	Rez_Monthly_Rate =
		ISNULL(CAST(RP_Acc_7_CSR_Performance_Reservation_Rates.Monthly_Rate AS varchar(10)), '-'),
   	Rez_Late_Day_Rate =
		ISNULL(CAST(RP_Acc_7_CSR_Performance_Reservation_Rates.Late_Day_Rate AS varchar(10)), '-'),
	Rate_Dif = CASE
		WHEN  	RP_Acc_7_CSR_Performance_Contract_Reservation_Info_L1_Base_1.Rez_Src = 'W' THEN
			''
		WHEN RP_Acc_7_CSR_Performance_Contract_Rates.Rate_Name
		     <> RP_Acc_7_CSR_Performance_Reservation_Rates.Rate_Name THEN
			'Y'	
		WHEN ISNULL(RP_Acc_7_CSR_Performance_Contract_Reservation_Info_L1_Base_1.Con_Rate_Level,'RATE LEVEL IS NULL')
		     <> ISNULL(RP_Acc_7_CSR_Performance_Contract_Reservation_Info_L1_Base_1.Rez_Rate_Level,'RATE LEVEL IS NULL') THEN
			'Y'
		WHEN ISNULL(RP_Acc_7_CSR_Performance_Contract_Rates.Daily_Rate, -1)
		     <> ISNULL(RP_Acc_7_CSR_Performance_Reservation_Rates.Daily_Rate, -1) THEN
			'Y'
		WHEN ISNULL(RP_Acc_7_CSR_Performance_Contract_Rates.Weekly_Rate, -1)
		     <> ISNULL(RP_Acc_7_CSR_Performance_Reservation_Rates.Weekly_Rate, -1) THEN
			'Y'

		WHEN ISNULL(RP_Acc_7_CSR_Performance_Contract_Rates.Monthly_Rate, -1)
		     <> ISNULL(RP_Acc_7_CSR_Performance_Reservation_Rates.Monthly_Rate, -1) THEN
			'Y'
		ELSE
			''
		END,	
   	RP_Acc_7_CSR_Performance_Contract_Reservation_Info_L1_Base_1.Length,
    	RP_Acc_7_CSR_Performance_LDW_BD_Daily_Rate_L1_Base_1.Daily_Rate,
    	LDW_Inc = CASE
		WHEN RP_Acc_7_CSR_Performance_LDW_INC_Flag_L1_Base_1.Optional_Extra_ID IS NOT NULL  THEN
			'Y'
		END,
    	RP_Acc_7_CSR_Performance_CCI_OE_Totals_L1_Base_1.LDW_BD_Total,
    	RP_Acc_7_CSR_Performance_CCI_OE_Totals_L1_Base_1.PAI_Total,
    	RP_Acc_7_CSR_Performance_CCI_OE_Totals_L1_Base_1.PEC_Total,
    	RP_Acc_7_CSR_Performance_CCI_OE_Totals_L1_Base_1.Discount_Total,
    	RP_Acc_7_CSR_Performance_CCI_OE_Totals_L1_Base_1.Time_Km_Total,
    	RP_Acc_7_CSR_Performance_CCI_OE_Totals_L1_Base_1.Upgrade_Total,
    	CFR_Flag = CASE
		WHEN RP_Acc_7_CSR_Performance_CCI_OE_Totals_L1_Base_1.CFR_Total > 0 THEN
			'Y'
		ELSE
			'N'
		END,
	FPO_Flag = CASE
		WHEN RP_Acc_7_CSR_Performance_CCI_OE_Totals_L1_Base_1.FPO_Total > 0 THEN
			'Y'
		ELSE
			'N'
		END,
    	RP_Acc_7_CSR_Performance_Contract_Reservation_Info_L1_Base_1.Number_Of_Vehicles,
    	RP_Acc_7_CSR_Performance_Contract_Reservation_Info_L1_Base_1.ADJ,
    	RP_Acc_7_CSR_Performance_Contract_Reservation_Info_L1_Base_1.Con_CS,
   	RP_Acc_7_CSR_Performance_Contract_Rates.Rate_Name		    	AS Con_Rate_Name,
   	RP_Acc_7_CSR_Performance_Contract_Reservation_Info_L1_Base_1.Con_Rate_Level    	AS Con_Rate_Level,
   	Con_Daily_Rate =
	ISNULL(CAST(RP_Acc_7_CSR_Performance_Contract_Rates.Daily_Rate AS varchar(10)),'-'),
   	Con_Weekly_Rate =
	ISNULL(CAST(RP_Acc_7_CSR_Performance_Contract_Rates.Weekly_Rate AS varchar(10)),'-'),
   	Con_Monthly_Rate =
	ISNULL(CAST(RP_Acc_7_CSR_Performance_Contract_Rates.Monthly_Rate AS varchar(10)),'-'),
   	Con_Late_Day_Rate =
	ISNULL(CAST(RP_Acc_7_CSR_Performance_Contract_Rates.Late_Day_Rate AS varchar(10)),'-')
FROM 	RP_Acc_7_CSR_Performance_Contracts_L1_Main_1 with(nolock)
	INNER JOIN
   	RP_Acc_7_CSR_Performance_Contract_Reservation_Info_L1_Base_1
    		ON RP_Acc_7_CSR_Performance_Contracts_L1_Main_1.Contract_Number
    			= RP_Acc_7_CSR_Performance_Contract_Reservation_Info_L1_Base_1.Contract_Number
		
    	INNER JOIN
   	RP_Acc_7_CSR_Performance_Contract_Rates
		ON RP_Acc_7_CSR_Performance_Contracts_L1_Main_1.Contract_Number
    			= RP_Acc_7_CSR_Performance_Contract_Rates.Contract_Number	
		AND RP_Acc_7_CSR_Performance_Contract_Rates.Run_ID = @iRunID		
    	LEFT OUTER JOIN
   	RP_Acc_7_CSR_Performance_Reservation_Rates
		ON RP_Acc_7_CSR_Performance_Contracts_L1_Main_1.Confirmation_Number
	    		= RP_Acc_7_CSR_Performance_Reservation_Rates.Confirmation_Number
		AND RP_Acc_7_CSR_Performance_Reservation_Rates.Run_ID = @iRunID
	LEFT OUTER JOIN
   	RP_Acc_7_CSR_Performance_CCI_OE_Totals_L1_Base_1
		ON RP_Acc_7_CSR_Performance_Contracts_L1_Main_1.Contract_Number
    			= RP_Acc_7_CSR_Performance_CCI_OE_Totals_L1_Base_1.Contract_Number

    	LEFT OUTER JOIN
   	RP_Acc_7_CSR_Performance_LDW_INC_Flag_L1_Base_1
		ON RP_Acc_7_CSR_Performance_Contracts_L1_Main_1.Contract_Number
    			= RP_Acc_7_CSR_Performance_LDW_INC_Flag_L1_Base_1.Contract_Number
    	LEFT OUTER JOIN
   	RP_Acc_7_CSR_Performance_LDW_BD_Daily_Rate_L1_Base_1
		ON RP_Acc_7_CSR_Performance_Contracts_L1_Main_1.Contract_Number
    			= RP_Acc_7_CSR_Performance_LDW_BD_Daily_Rate_L1_Base_1.Contract_Number
WHERE
	--(@Vehicle_Type = '*'
	-- OR
	-- RP_Acc_7_CSR_Performance_Contract_Reservation_Info_L1_Base_1.Vehicle_Type_ID
	--	= @Vehicle_Type
	--)
	--AND
	(RP_Acc_7_CSR_Performance_Contracts_L1_Main_1.RBR_Date
		BETWEEN @startDate AND @endDate
	)
	AND
	(@Location_ID = '*'
	 OR
	 RP_Acc_7_CSR_Performance_Contracts_L1_Main_1.Contract_Opened_At_Location_ID
		= CAST(@tmpLocID AS INT)
	)
	AND
	(@CSR_Name = '*'
	 OR
	 RP_Acc_7_CSR_Performance_Contracts_L1_Main_1.User_ID = @CSR_Name
	)	
	AND
	(RP_Acc_7_CSR_Performance_Contracts_L1_Main_1.Transaction_Description
		= @Check_In_Or_Out
	)	
	AND
	-- When 'Check Out' select contracts with status 'CO' and 'CI'
	-- When 'Check In' select contracts with status 'CI'
	(@Check_In_Or_Out = 'Check Out'
	 OR
	 RP_Acc_7_CSR_Performance_Contract_Reservation_Info_L1_Base_1.Contract_Status = 'CI'
	)
	AND
	(@Rate_Name = '*'
	 OR
	 RP_Acc_7_CSR_Performance_Contract_Rates.Rate_Name = @Rate_Name
	)	
			
-- delete the run from the RP_Acc_7_CSR_Performance_Reservation_Rates table
DELETE
  FROM	RP_Acc_7_CSR_Performance_Reservation_Rates
 WHERE	Run_ID = @iRunID

-- delete the run from the RP_Acc_7_CSR_Performance_Contract_Rates table
DELETE
  FROM	RP_Acc_7_CSR_Performance_Contract_Rates
 WHERE	Run_ID = @iRunID

-- delete the run from the RP_Run table
DELETE
  FROM	RP_Run
 WHERE	Run_ID = @iRunID

return




GO
