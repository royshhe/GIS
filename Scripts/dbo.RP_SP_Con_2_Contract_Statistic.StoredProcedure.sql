USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Con_2_Contract_Statistic]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*
PROCEDURE NAME: RP_SP_Con_2_Contract_Statistic_New
PURPOSE: Collect Contract Statistics for all budget BC vehicle contract 
AUTHOR:	Linda Qu
DATE CREATED: 2000/06/08
USED BY:  Contract Statistic Report
MOD HISTORY:
Name 		Date		Comments
Linda Qu	June 08 2000	Rewrite Contract Statistic Report in order to solve the SQL Server Access Violation Error
                                Called Microsoft but can't find the source for AV error. Thus we decide to rewrite this report
                                using report table. Two report tables have been introduced for this purpose. 
                                They are Contract_CI and Contract_CO. Contract_CI will summarize all closed contract statistics. 
                                Contract_CO will list all check out contracts. 
*/
/* updated to ver 80 */
CREATE PROCEDURE [dbo].[RP_SP_Con_2_Contract_Statistic] -- '01 jun 2011','30 jun 2011','Car','16'
(
	@paramStartDate varchar(20) = '01 May 2000',
	@paramEndDate varchar(20) = '07 May 2000',
	@paramVehTypeID varchar(20) = '*',
	@paramLocID varchar(20) = '43'
)
AS

SET NOCOUNT ON
DECLARE 	@startDate datetime,
		@endDate datetime

--Check reportoken to avoid that multiple users run this report at the same time
--DECLARE @concurrentRpt char(1)
--select @concurrentRpt=Code FROM Lookup_Table WHERE Category='ReportToken'
--IF @concurrentRpt='1'
--   RETURN
--ELSE UPDATE Lookup_Table Set Code='1' WHERE Category='ReportToken'
--end reporttoken checking

-- convert strings to datetime
SELECT	@startDate	= CONVERT(datetime, '00:00:00 ' + @paramStartDate),
	@endDate	= CONVERT(datetime, '23:59:59 ' + @paramEndDate)	

-- fix upgrading problem (SQL7->SQL2000)
DECLARE  @tmpLocID varchar(20)

if @paramLocID = '*'
	BEGIN
		SELECT @tmpLocID='0'
        END
else
	BEGIN
		SELECT @tmpLocID = @paramLocID
	END 
-- end of fixing the problem

--Clean Up
--DELETE FROM Contract_CI
--DELETE FROM Contract_CO

CREATE TABLE #Contract_CI(
	[Contract_Number] [int] NOT NULL,
	[RBR_Date] [datetime] NOT NULL,
	[Pick_Up_Location_ID] [smallint] NOT NULL,
	[Pick_Up_On] [datetime] NOT NULL,
	[Vehicle_Type_ID] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Vehicle_Class_Code] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Status] [char](2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Foreign_Contract_Number] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BRAC_Unit] [bit] NULL,
	[Location_Name] [varchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Rental_Days] [decimal](18, 10) NULL,
	[KM_Driven] [int] NULL,
	--[TimeKM_Charge] [decimal](16, 6) NULL,
	[DailyRental_Charge] [decimal](16, 6) NULL,
	[KM_Charge] [decimal](16, 6) NULL,
	[Upgrade_Charge] [decimal](16, 6) NULL,
	[MemebershipDiscount_Charge] [decimal](16, 6) NULL,
	[LicenceFeeRecovery_Charge] [decimal](16, 6) NULL,
	[ERF_Charge] [decimal](16, 6) NULL,
	[Drop_Charge] [decimal](16, 6) NULL,
	[OA_SURCHARGE] [decimal](16, 6) NULL,
	[LDW_Charge] [decimal](16, 6) NULL,
	[Buydown_Charge] [decimal](16, 6) NULL,
	[PAI_Charge] [decimal](16, 6) NULL,
	[AdditionalDriver_Charge] [decimal](16, 6) NULL,
	[GPSRental_Charge] [decimal](16, 6) NULL,
	[Driver_SurCharge] [decimal](16, 6) NULL,
	[Phone_Charge] [decimal](16, 6) NULL,
	[PEC_Charge] [decimal](16, 6) NULL,
	[BabySeats_Charge] [decimal](16, 6) NULL,
	[KPO_Charge] [decimal](16, 6) NULL,
	[ELI_Charge] [decimal](16, 6) NULL,
	[Cargo_Charge] [decimal](16, 6) NULL,
	[Foreign_Opt_Extra_Charge] [decimal](16, 6) NULL
) 

CREATE TABLE #Contract_CO(
	[Contract_Number] [int] NOT NULL,
	[RBR_Date] [datetime] NOT NULL,
	[Pick_Up_Location_ID] [smallint] NOT NULL,
	[Pick_Up_On] [datetime] NOT NULL,
	[Vehicle_Type_ID] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Vehicle_Class_Code] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Status] [char](2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Foreign_Contract_Number] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BRAC_Unit] [bit] NULL,
	[Location_Name] [varchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) 

--Collect all check out contract in the report specified date
INSERT INTO #Contract_CO (Contract_Number, RBR_Date,Pick_Up_Location_ID,Pick_Up_On,
                         Vehicle_Type_ID,Vehicle_Class_Code,Status,Foreign_Contract_Number,Location_Name
                         ,BRAC_Unit
                         )
   SELECT DISTINCT con.Contract_number, bt.RBR_Date,con.Pick_Up_Location_ID,con.Pick_Up_On,vc.Vehicle_Type_ID,
          con.Vehicle_Class_Code,con.Status,con.Foreign_Contract_number,loc.Location,1
   FROM Contract con with(nolock)
   INNER JOIN Business_Transaction bt
   ON bt.Contract_Number=con.Contract_Number
	AND bt.transaction_type='con'
	AND bt.transaction_description='Check Out' 
   INNER JOIN Vehicle_Class vc
   ON vc.Vehicle_Class_Code=con.Vehicle_Class_Code
   INNER JOIN Location loc
   ON loc.Location_ID=con.Pick_Up_Location_ID
--Add brac_unit condition
   INNER JOIN Vehicle_On_Contract voc
   ON voc.Contract_Number=bt.Contract_Number
      AND voc.Business_Transaction_ID=bt.Business_Transaction_ID
   INNER JOIN Vehicle veh
   ON veh.Unit_Number=voc.Unit_Number
   INNER JOIN  Lookup_Table lt
   ON lt.code=veh.Owning_Company_ID
--end brac_unit
   WHERE 
	 bt.rbr_date BETWEEN @startDate AND @endDate 
	 AND ( @paramLocID='*' OR (con.pick_up_location_id=CONVERT(INT,@tmpLocID) ) )
         AND (@paramVehTypeID='*' OR (vc.Vehicle_Type_ID=@paramVehTypeID) )
         AND lt.Category='BudgetBC Company'

--Collect all check in contract in the report specified date
INSERT INTO #Contract_CI (	Contract_Number, RBR_Date,Pick_Up_Location_ID,Pick_Up_On,
							Vehicle_Type_ID,Vehicle_Class_Code,Status,Foreign_Contract_Number,Location_Name,
							Rental_Days,KM_Driven,DailyRental_Charge,KM_Charge,Upgrade_Charge,
							MemebershipDiscount_Charge,
							LicenceFeeRecovery_Charge,
							ERF_Charge,
							Drop_Charge,
							OA_SURCHARGE,	
							LDW_Charge,
							Buydown_Charge,
							PAI_Charge,
							AdditionalDriver_Charge,
							GPSRental_Charge,
							Driver_SurCharge,
							Phone_Charge,
							PEC_Charge,Cargo_Charge,
							BabySeats_Charge,
							KPO_Charge,
							ELI_Charge,	
							Foreign_Opt_Extra_Charge)
   SELECT DISTINCT con.Contract_number, bt.RBR_Date,con.Pick_Up_Location_ID,con.Pick_Up_On,vc.Vehicle_Type_ID,
          con.Vehicle_Class_Code,con.Status,con.Foreign_Contract_number,loc.Location,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
   FROM Contract con with(nolock)
   INNER JOIN Business_Transaction bt
   ON bt.Contract_Number=con.Contract_Number
	AND bt.transaction_type='con'
	AND bt.transaction_description  IN ('Check In', 'Foreign Check In')  
   INNER JOIN Vehicle_Class vc
   ON vc.Vehicle_Class_Code=con.Vehicle_Class_Code
   INNER JOIN Location loc
   ON loc.Location_ID=con.Pick_Up_Location_ID
   WHERE 
	 bt.rbr_date BETWEEN @startDate AND @endDate
	 AND ( @paramLocID='*' OR (con.pick_up_location_id=CONVERT(INT,@tmpLocID) ) )
         AND (@paramVehTypeID='*' OR (vc.Vehicle_Type_ID=@paramVehTypeID) )
         AND con.Status='CI'

--flag BRAC_Unit to 1 for the contract whose initial car is  a BudgetBC vehicle

UPDATE #Contract_CI
SET BRAC_Unit=1
FROM #Contract_CI ci
INNER JOIN  Business_Transaction bt
ON bt.Contract_Number=ci.Contract_Number
   AND bt.Transaction_Type='Con'
   AND bt.Transaction_Description='Check Out'
INNER JOIN Vehicle_On_Contract voc
ON voc.Contract_Number=bt.Contract_Number
   AND voc.Business_Transaction_ID=bt.Business_Transaction_ID
WHERE voc.Unit_Number in 
(SELECT Unit_Number FROM Vehicle WHERE Owning_Company_ID=
        (SELECT code FROM Lookup_Table WHERE Category='BudgetBC Company')
)

--Get Statistics for each CI contract

UPDATE #Contract_CI
SET Rental_Days=rdays.Rental_Days
FROM #Contract_CI ci,
-- Calculate total number of Rental Days for all contracts checked in 

(	SELECT
		cci.Contract_Number, 
		DATEDIFF(mi, cci.Pick_Up_On, Vehicle_On_Contract.Actual_Check_In)/1440.0000000000  AS Rental_Days
	FROM 	#Contract_CI cci
	INNER JOIN
    	Vehicle_On_Contract 
	ON cci.Contract_Number = Vehicle_On_Contract.Contract_Number
		AND cci.Status = 'CI'
		AND Vehicle_On_Contract.Actual_Check_In IS NOT NULL
     		AND Vehicle_On_Contract.Actual_Check_In =
    			(SELECT MAX(actual_check_in)
      				FROM vehicle_On_Contract
      					WHERE cci.Contract_Number = Vehicle_On_Contract.Contract_Number)
) rdays
WHERE rdays.Contract_Number=ci.Contract_Number
AND ci.BRAC_Unit=1


UPDATE #Contract_CI
SET Km_Driven=kmd.Km_Driven
FROM #Contract_CI ci,

-- Calculate Kms Driven for all contracts checked in 
	(SELECT 	
		cci.Contract_Number, 
    		SUM(ABS(Vehicle_On_Contract.Km_In - Vehicle_On_Contract.Km_Out)) AS Km_Driven
	FROM 	#Contract_CI cci
	INNER JOIN Vehicle_On_Contract 
		ON cci.Contract_Number = Vehicle_On_Contract.Contract_Number

	WHERE 	(cci.Status = 'CI') 
	GROUP BY 
	cci.Contract_Number) kmd
WHERE kmd.Contract_Number=ci.Contract_Number 
AND ci.BRAC_Unit=1

UPDATE #Contract_CI
SET DailyRental_Charge=tkmc.DailyRental_Charge,
	KM_Charge=tkmc.KM_Charge,
	Upgrade_Charge=tkmc.Upgrade_Charge,
	MemebershipDiscount_Charge=tkmc.MemebershipDiscount_Charge,
	LicenceFeeRecovery_Charge=tkmc.LicenceFeeRecovery_Charge,
	ERF_Charge=tkmc.ERF_Charge,
	Drop_Charge=tkmc.Drop_Charge,
--	OA_SURCHARGE=tkmc.OA_SURCHARGE	,
	AdditionalDriver_Charge=tkmc.AdditionalDriver_Charge
--	GPSRental_Charge=tkmc.GPSRental_Charge,
--	Driver_SurCharge=tkmc.Driver_SurCharge
FROM #Contract_CI ci,
-- Calculate Time and Km Charge for all contracts, including upgrade revenue
-- less any discounts
	(SELECT 	
		cci.Contract_Number, 
		SUM( CASE 	WHEN Contract_Charge_Item.Charge_Type IN (10)
					THEN Contract_Charge_Item.Amount
							-Contract_Charge_Item.GST_Amount_Included
							-Contract_Charge_Item.PST_Amount_Included
							-Contract_Charge_Item.PVRT_Amount_Included
					ELSE 0
			END)  						as DailyRental_Charge,					
		SUM( CASE 	WHEN Contract_Charge_Item.Charge_Type IN (11)
					THEN Contract_Charge_Item.Amount
							-Contract_Charge_Item.GST_Amount_Included
							-Contract_Charge_Item.PST_Amount_Included
							-Contract_Charge_Item.PVRT_Amount_Included
					ELSE 0
			END)  						as KM_Charge,					
		SUM( CASE 	WHEN Contract_Charge_Item.Charge_Type IN (20)
					THEN Contract_Charge_Item.Amount
							-Contract_Charge_Item.GST_Amount_Included
							-Contract_Charge_Item.PST_Amount_Included
							-Contract_Charge_Item.PVRT_Amount_Included
					ELSE 0
			END)  						as Upgrade_Charge,
		SUM( CASE 	WHEN Contract_Charge_Item.Charge_Type IN (50,51,52)
					THEN Contract_Charge_Item.Amount
							-Contract_Charge_Item.GST_Amount_Included
							-Contract_Charge_Item.PST_Amount_Included
							-Contract_Charge_Item.PVRT_Amount_Included
					ELSE 0
			END)  						as MemebershipDiscount_Charge,				
		SUM( CASE 	WHEN Contract_Charge_Item.Charge_Type IN (31,96,97)
					THEN Contract_Charge_Item.Amount
							-Contract_Charge_Item.GST_Amount_Included
							-Contract_Charge_Item.PST_Amount_Included
							-Contract_Charge_Item.PVRT_Amount_Included
					ELSE 0
			END)  						as LicenceFeeRecovery_Charge,
		SUM( CASE 	WHEN Contract_Charge_Item.Charge_Type IN (46)
					THEN Contract_Charge_Item.Amount
							-Contract_Charge_Item.GST_Amount_Included
							-Contract_Charge_Item.PST_Amount_Included
							-Contract_Charge_Item.PVRT_Amount_Included
					ELSE 0
			END)  						as ERF_Charge,				
		SUM( CASE 	WHEN Contract_Charge_Item.Charge_Type IN (33)
					THEN Contract_Charge_Item.Amount
							-Contract_Charge_Item.GST_Amount_Included
							-Contract_Charge_Item.PST_Amount_Included
							-Contract_Charge_Item.PVRT_Amount_Included
					ELSE 0
			END)  						as Drop_Charge,				
		SUM( CASE 	WHEN Contract_Charge_Item.Charge_Type IN (34)
					THEN Contract_Charge_Item.Amount
							-Contract_Charge_Item.GST_Amount_Included
							-Contract_Charge_Item.PST_Amount_Included
							-Contract_Charge_Item.PVRT_Amount_Included
					ELSE 0
			END)  						as AdditionalDriver_Charge				
--		SUM( CASE 	WHEN Contract_Charge_Item.Charge_Type IN (68)
--					THEN Contract_Charge_Item.Amount
--							-Contract_Charge_Item.GST_Amount_Included
--							-Contract_Charge_Item.PST_Amount_Included
--							-Contract_Charge_Item.PVRT_Amount_Included
--					ELSE 0
--			END)  						as GPSRental_Charge	,
--		SUM( CASE 	WHEN Contract_Charge_Item.Charge_Type IN (36)
--					THEN Contract_Charge_Item.Amount
--							-Contract_Charge_Item.GST_Amount_Included
--							-Contract_Charge_Item.PST_Amount_Included
--							-Contract_Charge_Item.PVRT_Amount_Included
--					ELSE 0
--			END)  						as Driver_SurCharge				
			
--		SUM(Contract_Charge_Item.Amount) 
--    		- SUM(Contract_Charge_Item.GST_Amount_Included) 
--    		- SUM(Contract_Charge_Item.PST_Amount_Included) 
--    		- SUM(Contract_Charge_Item.PVRT_Amount_Included) AS TimeKM_Charge
	FROM 	#Contract_CI cci
	INNER JOIN Contract_Charge_Item 
		ON cci.Contract_Number = Contract_Charge_Item.Contract_Number
		AND cci.Status = 'CI'
		--AND Contract_Charge_Item.Charge_Type IN ('10', '11', '20', '50', '51', '52')
/* 	
	10  = Time Charge
	11 = KM Charge
	20 = Upgrade Charge
	50 = Flex Discount (-ve)
	51 = Member Discount (-ve)
	52 = Contract Discount (-ve)
*/
	GROUP BY cci.Contract_Number) tkmc
WHERE tkmc.Contract_Number=ci.Contract_Number
AND ci.BRAC_Unit=1

UPDATE #Contract_CI
SET LDW_Charge=ldwc.LDW_Charge,
	Buydown_Charge=ldwc.Buydown_Charge,
	Phone_Charge=ldwc.Phone_Charge,
	BabySeats_Charge=ldwc.BabySeats_Charge,
	KPO_Charge=ldwc.KPO_Charge,
	ELI_Charge=ldwc.ELI_charge,
	OA_SURCHARGE=ldwc.OA_SURCHARGE,
	GPSRental_Charge=ldwc.GPSRental_Charge,
	Driver_SurCharge=ldwc.Driver_SurCharge
	

FROM #Contract_CI ci,

-- Calculate LDW Charge for all BRAC contracts, including adjustment charges where charge type id is found in lookup table.
	(SELECT 	
		cci.Contract_Number, 
		SUM
		(
			CASE 
			WHEN ((Optional_Extra.Type = 'LDW') -- OR Optional_Extra.Type = 'Buydown'
				OR (Contract_Charge_Item.Charge_Type = 61 )
				--OR (Contract_Charge_Item.Charge_Type = 69 AND Charge_Item_Type = 'a')
					) -- adjustment charge for LDW
			THEN Contract_Charge_Item.Amount 
    				- Contract_Charge_Item.GST_Amount_Included
    				- Contract_Charge_Item.PST_Amount_Included 
    				- Contract_Charge_Item.PVRT_Amount_Included
			ELSE 0
		END
		) AS LDW_Charge,
		SUM
		(
			CASE 
			WHEN (( Optional_Extra.Type = 'Buydown') --Optional_Extra.Type = 'LDW' OR
				--OR (Contract_Charge_Item.Charge_Type = 61 AND Charge_Item_Type = 'a')
				OR (Contract_Charge_Item.Charge_Type = 69 )) -- adjustment charge for LDW
			THEN Contract_Charge_Item.Amount 
    				- Contract_Charge_Item.GST_Amount_Included
    				- Contract_Charge_Item.PST_Amount_Included 
    				- Contract_Charge_Item.PVRT_Amount_Included
			ELSE 0
		END
		) AS Buydown_Charge,
		SUM
		(
			CASE 
			WHEN (Optional_Extra.Type = 'PHONE')
			THEN Contract_Charge_Item.Amount 
    				- Contract_Charge_Item.GST_Amount_Included
    				- Contract_Charge_Item.PST_Amount_Included 
    				- Contract_Charge_Item.PVRT_Amount_Included
			ELSE 0
		END
		) AS Phone_Charge,
		SUM
		(
			CASE 
			WHEN (( Optional_Extra.Type = 'Seat') 
				OR (Contract_Charge_Item.Charge_Type = 23 )) -- adjustment charge for LDW
			THEN Contract_Charge_Item.Amount 
    				- Contract_Charge_Item.GST_Amount_Included
    				- Contract_Charge_Item.PST_Amount_Included 
    				- Contract_Charge_Item.PVRT_Amount_Included
			ELSE 0
		END
		) AS BabySeats_Charge,
		SUM
		(
			CASE 
			WHEN ( Optional_Extra.Optional_Extra like  '%KPO%') 
			THEN Contract_Charge_Item.Amount 
    				- Contract_Charge_Item.GST_Amount_Included
    				- Contract_Charge_Item.PST_Amount_Included 
    				- Contract_Charge_Item.PVRT_Amount_Included
			ELSE 0
		END
		) AS KPO_Charge,
		SUM
		(
			CASE 
			WHEN ( Optional_Extra.Type = 'ELI') 
			THEN Contract_Charge_Item.Amount 
    				- Contract_Charge_Item.GST_Amount_Included
    				- Contract_Charge_Item.PST_Amount_Included 
    				- Contract_Charge_Item.PVRT_Amount_Included
			ELSE 0
		END
		) AS ELI_Charge,
		SUM
		(
			CASE 
			WHEN (( Optional_Extra.Type = 'OA') 
				OR (Contract_Charge_Item.Charge_Type = 47)) 
			THEN Contract_Charge_Item.Amount 
    				- Contract_Charge_Item.GST_Amount_Included
    				- Contract_Charge_Item.PST_Amount_Included 
    				- Contract_Charge_Item.PVRT_Amount_Included
			ELSE 0
		END
		) AS OA_SURCHARGE,
		SUM
		(
			CASE 
			WHEN (( Optional_Extra.Type = 'GPS') 
				OR (Contract_Charge_Item.Charge_Type = 68)) 
			THEN Contract_Charge_Item.Amount 
    				- Contract_Charge_Item.GST_Amount_Included
    				- Contract_Charge_Item.PST_Amount_Included 
    				- Contract_Charge_Item.PVRT_Amount_Included
			ELSE 0
		END
		) AS GPSRental_Charge,
		SUM
		(
			CASE 
			WHEN (( Optional_Extra.Optional_Extra_ID in (23, 25) ) 
				OR (Contract_Charge_Item.Charge_Type = 36)) 
			THEN Contract_Charge_Item.Amount 
    				- Contract_Charge_Item.GST_Amount_Included
    				- Contract_Charge_Item.PST_Amount_Included 
    				- Contract_Charge_Item.PVRT_Amount_Included
			ELSE 0
		END
		) AS Driver_SurCharge

FROM 	Location 
	INNER JOIN #Contract_CI cci
		ON Location.Location_ID = cci.Pick_Up_Location_ID 
		AND cci.Status = 'CI' 
	INNER JOIN Lookup_Table 
		ON Location.Owning_Company_ID = Lookup_Table.Code 
		AND Lookup_Table.Category = 'BudgetBC Company' 
	INNER JOIN
    	Contract_Charge_Item 
		ON cci.Contract_Number = Contract_Charge_Item.Contract_Number
     	LEFT JOIN Optional_Extra 
		ON Contract_Charge_Item.Optional_Extra_ID = Optional_Extra.Optional_Extra_ID
		GROUP BY cci.Contract_Number ) ldwc
WHERE ldwc.Contract_Number=ci.Contract_Number
AND ci.BRAC_Unit=1

UPDATE #Contract_CI
SET PAI_Charge=paic.PAI_Charge
FROM #Contract_CI ci,

-- Calculate PAI Charge for all BRAC contracts, including adjustment charges where charge type id is found in lookup table.
(	SELECT 	
		cci.Contract_Number, 
		SUM
		(
			CASE 
			WHEN (Optional_Extra.Type in ( 'PAI','PEC','PAE')
				OR (Contract_Charge_Item.Charge_Type in ( 62,63) AND Charge_Item_Type = 'a')) -- adjustment charge for PAI
			THEN Contract_Charge_Item.Amount 
    				- Contract_Charge_Item.GST_Amount_Included
    				- Contract_Charge_Item.PST_Amount_Included 
    				- Contract_Charge_Item.PVRT_Amount_Included
			ELSE 0
		END
		)
		AS PAI_Charge
	FROM 	Location 
	INNER JOIN #Contract_CI cci
		ON Location.Location_ID = cci.Pick_Up_Location_ID 
		AND cci.Status = 'CI' 
	INNER JOIN Lookup_Table 
		ON Location.Owning_Company_ID = Lookup_Table.Code 
		AND Lookup_Table.Category = 'BudgetBC Company' 
	INNER JOIN Contract_Charge_Item 
		ON cci.Contract_Number = Contract_Charge_Item.Contract_Number
	LEFT JOIN  Optional_Extra 
		ON Contract_Charge_Item.Optional_Extra_ID = Optional_Extra.Optional_Extra_ID
	GROUP BY cci.Contract_Number ) paic
WHERE paic.Contract_Number=ci.Contract_Number
AND ci.BRAC_Unit=1

UPDATE #Contract_CI
SET PEC_Charge=pecc.PEC_Charge
FROM #Contract_CI ci,

-- Calculate PEC Charge for all BRAC contracts, including adjustment charges where charge type id is found in lookup table.
(	SELECT 	
		cci.Contract_Number, 
		SUM
		(	
		CASE 
			WHEN (Optional_Extra.Type = 'RSN'
				OR (Contract_Charge_Item.Charge_Type = 83 AND Charge_Item_Type = 'a' AND Vehicle_Class.Vehicle_Type_ID = 'Car')) -- adjustment charge for PEC for cars
			THEN Contract_Charge_Item.Amount 
    				- Contract_Charge_Item.GST_Amount_Included
    				- Contract_Charge_Item.PST_Amount_Included 
    				- Contract_Charge_Item.PVRT_Amount_Included
			ELSE 0
		END
		)
		AS PEC_Charge
	FROM 	Location 
	INNER JOIN #Contract_CI cci
		ON Location.Location_ID = cci.Pick_Up_Location_ID 
		AND cci.Status = 'CI' 
	INNER JOIN Vehicle_Class
		ON cci.Vehicle_Class_Code = Vehicle_Class.Vehicle_Class_Code
	INNER JOIN Lookup_Table 
		ON Location.Owning_Company_ID = Lookup_Table.Code 
		AND Lookup_Table.Category = 'BudgetBC Company' 
	INNER JOIN Contract_Charge_Item 
		ON cci.Contract_Number = Contract_Charge_Item.Contract_Number
     	LEFT JOIN Optional_Extra 
		ON Contract_Charge_Item.Optional_Extra_ID = Optional_Extra.Optional_Extra_ID
        GROUP BY 	cci.Contract_Number) pecc
WHERE pecc.Contract_Number=ci.Contract_Number
AND ci.BRAC_Unit=1

UPDATE #Contract_CI
SET Cargo_Charge=carc.Cargo_Charge
FROM #Contract_CI ci,

-- Calculate Cargo Charge for all BRAC contracts, including adjustment charges where charge type id is found in lookup table.
(	SELECT 	
		cci.Contract_Number, 
		SUM
		(
		CASE 
			WHEN (Optional_Extra.Type = 'Cargo'
				OR (Contract_Charge_Item.Charge_Type = 63 AND Charge_Item_Type = 'a' AND Vehicle_Class.Vehicle_Type_ID = 'Truck')) -- adjustment charge for Cargo for trucks
			THEN Contract_Charge_Item.Amount 
    				- Contract_Charge_Item.GST_Amount_Included
    				- Contract_Charge_Item.PST_Amount_Included 
    				- Contract_Charge_Item.PVRT_Amount_Included
			ELSE 0
		END
		)
		AS Cargo_Charge
	FROM 	Location 
	INNER JOIN
    	#Contract_CI cci
		ON Location.Location_ID = cci.Pick_Up_Location_ID 
		AND cci.Status = 'CI' 
	INNER JOIN Vehicle_Class
		ON cci.Vehicle_Class_Code = Vehicle_Class.Vehicle_Class_Code
	INNER JOIN    	Lookup_Table 
		ON Location.Owning_Company_ID = Lookup_Table.Code 
		AND Lookup_Table.Category = 'BudgetBC Company' 
	INNER 	JOIN Contract_Charge_Item 
		ON cci.Contract_Number = Contract_Charge_Item.Contract_Number
     	LEFT JOIN    	Optional_Extra 
		ON Contract_Charge_Item.Optional_Extra_ID = Optional_Extra.Optional_Extra_ID
	GROUP BY 	cci.Contract_Number ) carc
WHERE carc.Contract_Number=ci.Contract_Number
AND ci.BRAC_Unit=1

UPDATE #Contract_CI
SET Foreign_Opt_Extra_Charge=forc.Foreign_Opt_Extra_Charge
FROM #Contract_CI ci,

-- Calculate Foreign Optional Extra Charge for all Foreign contracts
(	SELECT 	
		cci.Contract_Number, 
		SUM(Contract_Charge_Item.Amount) 
    		- SUM(Contract_Charge_Item.GST_Amount_Included) 
    		- SUM(Contract_Charge_Item.PST_Amount_Included) 
    		- SUM(Contract_Charge_Item.PVRT_Amount_Included) AS Foreign_Opt_Extra_Charge
	FROM 	#Contract_CI cci
	INNER JOIN Contract_Charge_Item 
		ON cci.Contract_Number = Contract_Charge_Item.Contract_Number
		AND Contract_Charge_Item.Charge_Type between 90 and 99  -- foreign optional extra
		AND (cci.Status = 'CI')
		AND cci.Foreign_Contract_Number IS NOT NULL
   	INNER JOIN Location 
		ON cci.Pick_Up_Location_ID = Location.Location_ID 
	INNER JOIN Lookup_Table  
		ON Location.Owning_Company_ID <> Lookup_Table.Code
		AND Lookup_Table.Category = 'BudgetBC Company'
	GROUP BY cci.Contract_Number ) forc
WHERE forc.Contract_Number=ci.Contract_Number
AND ci.BRAC_Unit=1
--end statistics calculation for each contract

--Summary CO and CI 
SELECT 	
	COALESCE (vci.RBR_Date, vco.RBR_Date) AS Business_Date,
    	COALESCE (vci.Vehicle_Type_ID, vco.Vehicle_Type_ID) AS Vehicle_Type_ID,
    	COALESCE (vci.Pick_Up_Location_ID, vco.Pick_Up_Location_ID) AS Location_ID,
    	COALESCE (vci.Location_Name, vco.Location_Name) AS Location_Name,	
    	COALESCE(vco.Check_Out,0) AS Check_Out,
	COALESCE(vci.Check_In,0) AS Check_In,
    	COALESCE(vci.Rental_Days,0) AS Rental_Days,
	COALESCE(vci.Km_Driven,0) AS Km_Driven,
--     	COALESCE(vci.TimeKm_Charge,0) AS TimeKm_Charge,
     	COALESCE(vci.DailyRental_Charge,0) AS DailyRental_Charge,
     	COALESCE(vci.KM_Charge,0) AS KM_Charge,
     	COALESCE(vci.Upgrade_Charge,0) AS Upgrade_Charge,
     	COALESCE(vci.MemebershipDiscount_Charge,0) AS MemebershipDiscount_Charge,
     	COALESCE(vci.LicenceFeeRecovery_Charge,0) AS LicenceFeeRecovery_Charge,
     	COALESCE(vci.ERF_Charge,0) AS ERF_Charge,
     	COALESCE(vci.Drop_Charge,0) AS Drop_Charge,
     	COALESCE(vci.OA_SURCHARGE,0) AS OA_SURCHARGE,
   	COALESCE(vci.LDW_Charge,0) AS LDW_Charge,
   	COALESCE(vci.Buydown_Charge,0) AS Buydown_Charge,
	COALESCE(vci.PAI_Charge,0) AS PAI_Charge,
	COALESCE(vci.AdditionalDriver_Charge,0) AS AdditionalDriver_Charge,
	COALESCE(vci.GPSRental_Charge,0) AS GPSRental_Charge,
	COALESCE(vci.Driver_SurCharge,0) AS Driver_SurCharge,
	COALESCE(vci.Phone_Charge,0) AS Phone_Charge,
	COALESCE(vci.PEC_Charge,0) AS PEC_Charge,
	COALESCE(vci.BabySeats_Charge,0) AS BabySeats_Charge,
	COALESCE(vci.KPO_Charge,0) AS KPO_Charge,
	COALESCE(vci.ELI_Charge,0) AS ELI_Charge,
   	COALESCE(vci.Cargo_Charge,0) AS Cargo_Charge,
    	COALESCE(vci.Foreign_Opt_Extra_Charge,0) AS Foreign_Opt_Extra_Charge
FROM 	(SELECT 	
			RBR_Date,
     		Vehicle_Type_ID,
     		Pick_Up_Location_ID,
     		Location_Name, 
    		COUNT(*) AS Check_In, 
    		SUM(Rental_Days) AS Rental_Days, 
    		SUM(Km_Driven) AS Km_Driven, 
--    		SUM(TimeKm_Charge) AS TimeKm_Charge, 
    		SUM(DailyRental_Charge) AS DailyRental_Charge, 
    		SUM(KM_Charge) AS KM_Charge, 
    		SUM(Upgrade_Charge) AS Upgrade_Charge, 
    		SUM(MemebershipDiscount_Charge) AS MemebershipDiscount_Charge, 
    		SUM(LicenceFeeRecovery_Charge) AS LicenceFeeRecovery_Charge, 
    		SUM(ERF_Charge) AS ERF_Charge, 
    		SUM(Drop_Charge) AS Drop_Charge, 
    		SUM(OA_SURCHARGE) AS OA_SURCHARGE, 
    		SUM(LDW_Charge) AS LDW_Charge, 
    		SUM(Buydown_Charge) AS Buydown_Charge, 
    		SUM(PAI_Charge) AS PAI_Charge, 
    		SUM(AdditionalDriver_Charge) AS AdditionalDriver_Charge, 
    		SUM(GPSRental_Charge) AS GPSRental_Charge, 
    		SUM(Driver_SurCharge) AS Driver_SurCharge, 
    		SUM(Phone_Charge) AS Phone_Charge, 
    		SUM(PEC_Charge) AS PEC_Charge, 
    		SUM(BabySeats_Charge) AS BabySeats_Charge, 
    		SUM(KPO_Charge) AS KPO_Charge, 
    		SUM(ELI_Charge) AS ELI_Charge, 
    		SUM(Cargo_Charge) AS Cargo_Charge, 
  			SUM(Foreign_Opt_Extra_Charge) AS Foreign_Opt_Extra_Charge

		FROM 	#Contract_CI 
		WHERE BRAC_Unit=1
		GROUP BY 
				RBR_Date,
     			Vehicle_Type_ID,
     			Pick_Up_Location_ID,
     			Location_Name
		) vci 
			FULL	OUTER
		JOIN
   		(SELECT 	
			RBR_Date, 
    		Vehicle_Type_ID, 
    		Pick_Up_Location_ID, 
    		Location_Name, 
    		COUNT(*) AS Check_Out
		 FROM 	#Contract_CO 
			WHERE BRAC_Unit=1
			GROUP BY 
				RBR_Date,  
				Vehicle_Type_ID, 
    			Pick_Up_Location_ID, 
				Location_Name
		) vco
		ON vci.RBR_Date = vco.RBR_Date
		AND vci.Vehicle_Type_ID = vco.Vehicle_Type_ID
		AND vci.Pick_Up_Location_ID = vco.Pick_Up_Location_ID

--Change the reportToken flag to be 0
--UPDATE Lookup_Table Set Code='0' WHERE Category='ReportToken'
--
drop table #contract_ci
drop table #contract_co


GO
