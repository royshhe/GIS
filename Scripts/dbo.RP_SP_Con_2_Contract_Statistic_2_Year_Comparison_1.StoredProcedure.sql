USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Con_2_Contract_Statistic_2_Year_Comparison_1]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








--replace Phone field as Winter Tire Peter/2014.1






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
                                They are Contract_CI_Curr and Contract_CO_Curr. Contract_CI_Curr will summarize all closed contract statistics. 
                                Contract_CO_Curr will list all check out contracts. 
*/
/* updated to ver 80 */
CREATE PROCEDURE [dbo].[RP_SP_Con_2_Contract_Statistic_2_Year_Comparison_1] -- '2013-03-01','2013-03-03','Car','*'
(
	@paramStartDate varchar(20) = '01 May 2000',
	@paramEndDate varchar(20) = '07 May 2000',
	@paramVehTypeID varchar(20) = '*',
	@paramLocID varchar(100) = '43'
)
AS

SET NOCOUNT ON
DECLARE 	@startDate datetime,
			@endDate datetime,
			@AvgTotal_Curr as int,
			@AvgBracTotal_Curr as int,
			@Total as int,
			@AvgTotal_Pre as int,
			@AvgBracTotal_Pre as int

-- fix upgrading problem (SQL7->SQL2000)
DECLARE  @tmpLocID varchar(100)

if @paramLocID = '*'
	BEGIN
		SELECT @tmpLocID='0'
        END
else
	BEGIN
		SELECT @tmpLocID = @paramLocID
	END 


--Curr Year
SELECT	@startDate	=CONVERT(datetime,  @paramStartDate+' 00:00:00' ),
	@endDate	=  CONVERT(datetime,  @paramEndDate+' 23:59:59')	

select @Total=sum(rentable)+sum(not_rentable)+sum(Rented)
				from RP_Flt_15_Vehicle_Utilization VU
				   WHERE 
					 rp_date BETWEEN dateadd(dd,1,CONVERT(datetime,  @paramStartDate+' 00:00:00')) AND dateadd(dd,1,CONVERT(datetime,  @paramEndDate+' 23:59:59')) 
						 AND (@paramVehTypeID='*' OR (vu.Vehicle_Type_ID=@paramVehTypeID) )
print @Total

select	@AvgTotal_Curr=	cast((sum(rentable)+sum(not_rentable)+sum(Rented)) /(datediff(dd, CONVERT(datetime,  @paramStartDate),CONVERT(datetime,  @paramEndDate))+1) as decimal(11,4))
				from RP_Flt_15_Vehicle_Utilization VU
				   WHERE 
					 rp_date BETWEEN dateadd(dd,1,CONVERT(datetime,  @paramStartDate+' 00:00:00')) AND dateadd(dd,1,CONVERT(datetime,  @paramEndDate+' 23:59:59')) 
						 AND (@paramVehTypeID='*' OR (vu.Vehicle_Type_ID=@paramVehTypeID) )
print @AvgTotal_Curr
select @AvgBracTotal_Curr=cast((sum(rentable)+sum(not_rentable)+sum(Rented)) /(datediff(dd, CONVERT(datetime,  @paramStartDate),CONVERT(datetime,  @paramEndDate))+1) as decimal(11,4))
				from RP_Flt_15_Vehicle_Utilization VU 
						inner join location l on vu.current_location_id=l.location_id
				   WHERE 
					 rp_date BETWEEN dateadd(dd,1,CONVERT(datetime,  @paramStartDate+' 00:00:00')) AND dateadd(dd,1,CONVERT(datetime,  @paramEndDate+' 23:59:59')) 
						and l.rental_location=1
						and l.owning_company_ID=(select code from lookup_Table where category='BudgetBC Company' )	
						 AND (@paramVehTypeID='*' OR (vu.Vehicle_Type_ID=@paramVehTypeID) )
print @AvgBracTotal_Curr

select	@AvgTotal_Pre=	cast((sum(rentable)+sum(not_rentable)+sum(Rented)) /(datediff(dd, CONVERT(datetime,  @paramStartDate),CONVERT(datetime,  @paramEndDate))+1) as decimal(11,4))
				from RP_Flt_15_Vehicle_Utilization VU
				   WHERE 
					 rp_date BETWEEN dateadd(dd,1,dateadd(yy,-1 ,CONVERT(datetime,  @paramStartDate+' 00:00:00')))
								 AND dateadd(dd,1,dateadd(yy,-1, CONVERT(datetime,  @paramEndDate+' 23:59:59')))	 
						 AND (@paramVehTypeID='*' OR (vu.Vehicle_Type_ID=@paramVehTypeID) )

select @AvgBracTotal_Pre=cast((sum(rentable)+sum(not_rentable)+sum(Rented)) /(datediff(dd, CONVERT(datetime,  @paramStartDate),CONVERT(datetime,  @paramEndDate))+1) as decimal(11,4))
				from RP_Flt_15_Vehicle_Utilization VU 
						inner join location l on vu.current_location_id=l.location_id
				   WHERE 
					 rp_date BETWEEN dateadd(dd,1,dateadd(yy,-1 ,CONVERT(datetime,  @paramStartDate+' 00:00:00')))
								 AND dateadd(dd,1,dateadd(yy,-1, CONVERT(datetime,  @paramEndDate+' 23:59:59')))	 
						and l.rental_location=1
						and l.owning_company_ID=(select code from lookup_Table where category='BudgetBC Company' )	
						 AND (@paramVehTypeID='*' OR (vu.Vehicle_Type_ID=@paramVehTypeID) )

--print cast(@AvgTotal_Curr as char(20)) + cast(@AvgBracTotal_Curr as char(20))  + cast(@AvgTotal_Pre as char(20))  + cast(@AvgBracTotal_Pre as char(20))

CREATE TABLE #Contract_CI_Curr(
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

CREATE TABLE #Contract_CO_Curr(
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
INSERT INTO #Contract_CO_Curr (Contract_Number, RBR_Date,Pick_Up_Location_ID,Pick_Up_On,
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
	 AND ( @paramLocID='*' OR (con.pick_up_location_id in (select * from dbo.Split(@tmpLocID,'~')) ) )
         AND (@paramVehTypeID='*' OR (vc.Vehicle_Type_ID=@paramVehTypeID) )
         AND lt.Category='BudgetBC Company'


--Collect all check in contract in the report specified date
INSERT INTO #Contract_CI_Curr (	Contract_Number, RBR_Date,Pick_Up_Location_ID,Pick_Up_On,
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
	 AND ( @paramLocID='*' OR (con.pick_up_location_id in (select * from dbo.Split(@tmpLocID,'~')) ) )
         AND (@paramVehTypeID='*' OR (vc.Vehicle_Type_ID=@paramVehTypeID) )
         AND con.Status='CI'

--flag BRAC_Unit to 1 for the contract whose initial car is  a BudgetBC vehicle

UPDATE #Contract_CI_Curr
SET BRAC_Unit=1
FROM #Contract_CI_Curr ci
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

UPDATE #Contract_CI_Curr
SET Rental_Days=rdays.Rental_Days
FROM #Contract_CI_Curr ci,
-- Calculate total number of Rental Days for all contracts checked in 

(	SELECT
		cci.Contract_Number, 
		DATEDIFF(mi, cci.Pick_Up_On, Vehicle_On_Contract.Actual_Check_In)/1440.0000000000  AS Rental_Days
	FROM 	#Contract_CI_Curr cci
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


UPDATE #Contract_CI_Curr
SET Km_Driven=kmd.Km_Driven
FROM #Contract_CI_Curr ci,

-- Calculate Kms Driven for all contracts checked in 
	(SELECT 	
		cci.Contract_Number, 
    		SUM(ABS(Vehicle_On_Contract.Km_In - Vehicle_On_Contract.Km_Out)) AS Km_Driven
	FROM 	#Contract_CI_Curr cci
	INNER JOIN Vehicle_On_Contract 
		ON cci.Contract_Number = Vehicle_On_Contract.Contract_Number

	WHERE 	(cci.Status = 'CI') 
	GROUP BY 
	cci.Contract_Number) kmd
WHERE kmd.Contract_Number=ci.Contract_Number 
AND ci.BRAC_Unit=1

UPDATE #Contract_CI_Curr
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
FROM #Contract_CI_Curr ci,
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
	FROM 	#Contract_CI_Curr cci
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

UPDATE #Contract_CI_Curr
SET LDW_Charge=ldwc.LDW_Charge,
	Buydown_Charge=ldwc.Buydown_Charge,
	Phone_Charge=ldwc.Phone_Charge,
	BabySeats_Charge=ldwc.BabySeats_Charge,
	KPO_Charge=ldwc.KPO_Charge,
	ELI_Charge=ldwc.ELI_charge,
	OA_SURCHARGE=ldwc.OA_SURCHARGE,
	GPSRental_Charge=ldwc.GPSRental_Charge,
	Driver_SurCharge=ldwc.Driver_SurCharge
	

FROM #Contract_CI_Curr ci,

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
			WHEN (Optional_Extra.Type = 'WT')
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
	INNER JOIN #Contract_CI_Curr cci
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

UPDATE #Contract_CI_Curr
SET PAI_Charge=paic.PAI_Charge
FROM #Contract_CI_Curr ci,

-- Calculate PAI Charge for all BRAC contracts, including adjustment charges where charge type id is found in lookup table.
(	SELECT 	
		cci.Contract_Number, 
		SUM
		(
			CASE 
			WHEN (Optional_Extra.Type = 'PAI'
				OR (Contract_Charge_Item.Charge_Type = 62 AND Charge_Item_Type = 'a')) -- adjustment charge for PAI
			THEN Contract_Charge_Item.Amount 
    				- Contract_Charge_Item.GST_Amount_Included
    				- Contract_Charge_Item.PST_Amount_Included 
    				- Contract_Charge_Item.PVRT_Amount_Included
			ELSE 0
		END
		)
		AS PAI_Charge
	FROM 	Location 
	INNER JOIN #Contract_CI_Curr cci
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

UPDATE #Contract_CI_Curr
SET PEC_Charge=pecc.PEC_Charge
FROM #Contract_CI_Curr ci,

-- Calculate PEC Charge for all BRAC contracts, including adjustment charges where charge type id is found in lookup table.
(	SELECT 	
		cci.Contract_Number, 
		SUM
		(	
		CASE 
			WHEN (Optional_Extra.Type = 'PEC'
				OR (Contract_Charge_Item.Charge_Type = 63 AND Charge_Item_Type = 'a' AND Vehicle_Class.Vehicle_Type_ID = 'Car')) -- adjustment charge for PEC for cars
			THEN Contract_Charge_Item.Amount 
    				- Contract_Charge_Item.GST_Amount_Included
    				- Contract_Charge_Item.PST_Amount_Included 
    				- Contract_Charge_Item.PVRT_Amount_Included
			ELSE 0
		END
		)
		AS PEC_Charge
	FROM 	Location 
	INNER JOIN #Contract_CI_Curr cci
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

UPDATE #Contract_CI_Curr
SET Cargo_Charge=carc.Cargo_Charge
FROM #Contract_CI_Curr ci,

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
    	#Contract_CI_Curr cci
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

UPDATE #Contract_CI_Curr
SET Foreign_Opt_Extra_Charge=forc.Foreign_Opt_Extra_Charge
FROM #Contract_CI_Curr ci,

-- Calculate Foreign Optional Extra Charge for all Foreign contracts
(	SELECT 	
		cci.Contract_Number, 
		SUM(Contract_Charge_Item.Amount) 
    		- SUM(Contract_Charge_Item.GST_Amount_Included) 
    		- SUM(Contract_Charge_Item.PST_Amount_Included) 
    		- SUM(Contract_Charge_Item.PVRT_Amount_Included) AS Foreign_Opt_Extra_Charge
	FROM 	#Contract_CI_Curr cci
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



--Last Year 
SELECT	@startDate	= dateadd(yy,-1 ,CONVERT(datetime,  @paramStartDate+' 00:00:00')),
	@endDate	= dateadd(yy,-1, CONVERT(datetime,  @paramEndDate+' 23:59:59'))	



CREATE TABLE #Contract_CI_Pre(
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

CREATE TABLE #Contract_CO_Pre(
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
INSERT INTO #Contract_CO_Pre (Contract_Number, RBR_Date,Pick_Up_Location_ID,Pick_Up_On,
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
	 AND ( @paramLocID='*' OR (con.pick_up_location_id in (select * from dbo.Split(@tmpLocID,'~')) ) )
         AND (@paramVehTypeID='*' OR (vc.Vehicle_Type_ID=@paramVehTypeID) )
         AND lt.Category='BudgetBC Company'

--Collect all check in contract in the report specified date
INSERT INTO #Contract_CI_Pre (	Contract_Number, RBR_Date,Pick_Up_Location_ID,Pick_Up_On,
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
	 AND ( @paramLocID='*' OR (con.pick_up_location_id in (select * from dbo.Split(@tmpLocID,'~'))) )
         AND (@paramVehTypeID='*' OR (vc.Vehicle_Type_ID=@paramVehTypeID) )
         AND con.Status='CI'

--flag BRAC_Unit to 1 for the contract whose initial car is  a BudgetBC vehicle

UPDATE #Contract_CI_Pre
SET BRAC_Unit=1
FROM #Contract_CI_Pre ci
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

UPDATE #Contract_CI_Pre
SET Rental_Days=rdays.Rental_Days
FROM #Contract_CI_Pre ci,
-- Calculate total number of Rental Days for all contracts checked in 

(	SELECT
		cci.Contract_Number, 
		DATEDIFF(mi, cci.Pick_Up_On, Vehicle_On_Contract.Actual_Check_In)/1440.0000000000  AS Rental_Days
	FROM 	#Contract_CI_Pre cci
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


UPDATE #Contract_CI_Pre
SET Km_Driven=kmd.Km_Driven
FROM #Contract_CI_Pre ci,

-- Calculate Kms Driven for all contracts checked in 
	(SELECT 	
		cci.Contract_Number, 
    		SUM(ABS(Vehicle_On_Contract.Km_In - Vehicle_On_Contract.Km_Out)) AS Km_Driven
	FROM 	#Contract_CI_Pre cci
	INNER JOIN Vehicle_On_Contract 
		ON cci.Contract_Number = Vehicle_On_Contract.Contract_Number

	WHERE 	(cci.Status = 'CI') 
	GROUP BY 
	cci.Contract_Number) kmd
WHERE kmd.Contract_Number=ci.Contract_Number 
AND ci.BRAC_Unit=1

UPDATE #Contract_CI_Pre
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
FROM #Contract_CI_Pre ci,
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
	FROM 	#Contract_CI_Pre cci
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

UPDATE #Contract_CI_Pre
SET LDW_Charge=ldwc.LDW_Charge,
	Buydown_Charge=ldwc.Buydown_Charge,
	Phone_Charge=ldwc.Phone_Charge,
	BabySeats_Charge=ldwc.BabySeats_Charge,
	KPO_Charge=ldwc.KPO_Charge,
	ELI_Charge=ldwc.ELI_charge,
	OA_SURCHARGE=ldwc.OA_SURCHARGE,
	GPSRental_Charge=ldwc.GPSRental_Charge,
	Driver_SurCharge=ldwc.Driver_SurCharge
	

FROM #Contract_CI_Pre ci,

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
			WHEN (Optional_Extra.Type = 'WT')
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
	INNER JOIN #Contract_CI_Pre cci
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

UPDATE #Contract_CI_Pre
SET PAI_Charge=paic.PAI_Charge
FROM #Contract_CI_Pre ci,

-- Calculate PAI Charge for all BRAC contracts, including adjustment charges where charge type id is found in lookup table.
(	SELECT 	
		cci.Contract_Number, 
		SUM
		(
			CASE 
			WHEN (Optional_Extra.Type = 'PAI'
				OR (Contract_Charge_Item.Charge_Type = 62 AND Charge_Item_Type = 'a')) -- adjustment charge for PAI
			THEN Contract_Charge_Item.Amount 
    				- Contract_Charge_Item.GST_Amount_Included
    				- Contract_Charge_Item.PST_Amount_Included 
    				- Contract_Charge_Item.PVRT_Amount_Included
			ELSE 0
		END
		)
		AS PAI_Charge
	FROM 	Location 
	INNER JOIN #Contract_CI_Pre cci
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

UPDATE #Contract_CI_Pre
SET PEC_Charge=pecc.PEC_Charge
FROM #Contract_CI_Pre ci,

-- Calculate PEC Charge for all BRAC contracts, including adjustment charges where charge type id is found in lookup table.
(	SELECT 	
		cci.Contract_Number, 
		SUM
		(	
		CASE 
			WHEN (Optional_Extra.Type = 'PEC'
				OR (Contract_Charge_Item.Charge_Type = 63 AND Charge_Item_Type = 'a' AND Vehicle_Class.Vehicle_Type_ID = 'Car')) -- adjustment charge for PEC for cars
			THEN Contract_Charge_Item.Amount 
    				- Contract_Charge_Item.GST_Amount_Included
    				- Contract_Charge_Item.PST_Amount_Included 
    				- Contract_Charge_Item.PVRT_Amount_Included
			ELSE 0
		END
		)
		AS PEC_Charge
	FROM 	Location 
	INNER JOIN #Contract_CI_Pre cci
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

UPDATE #Contract_CI_Pre
SET Cargo_Charge=carc.Cargo_Charge
FROM #Contract_CI_Pre ci,

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
    	#Contract_CI_Pre cci
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

UPDATE #Contract_CI_Pre
SET Foreign_Opt_Extra_Charge=forc.Foreign_Opt_Extra_Charge
FROM #Contract_CI_Pre ci,

-- Calculate Foreign Optional Extra Charge for all Foreign contracts
(	SELECT 	
		cci.Contract_Number, 
		SUM(Contract_Charge_Item.Amount) 
    		- SUM(Contract_Charge_Item.GST_Amount_Included) 
    		- SUM(Contract_Charge_Item.PST_Amount_Included) 
    		- SUM(Contract_Charge_Item.PVRT_Amount_Included) AS Foreign_Opt_Extra_Charge
	FROM 	#Contract_CI_Pre cci
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
select	COALESCE (con_curr.Vehicle_Type_ID, con_pre.Vehicle_Type_ID) AS Vehicle_Type_ID,
    	COALESCE (con_curr.Location_ID, con_pre.Location_ID) AS Location_ID,
    	COALESCE (con_curr.Location_Name, con_pre.Location_Name) AS Location_Name,	

		Opens_Curr,
		Closes_Curr,
		CAST(ROUND(RentalDays_Curr, 0) AS int) RentalDays_Curr ,
		Km_Driven_Curr,
		CAST(ROUND(DailyRental_Curr, 0) AS int) DailyRental_Curr,
		CAST(ROUND(Mileage_Curr, 0) AS int) Mileage_Curr,
		CAST(ROUND(Upgrade_Curr, 0) AS int) Upgrade_Curr,
		CAST(ROUND(MembershipDiscounts_Curr, 0) AS int) MembershipDiscounts_Curr,
		CAST(ROUND(LicenceFeeRecovery_Curr, 0) AS int) LicenceFeeRecovery_Curr,
		CAST(ROUND(ERF_Curr, 0) AS int) ERF_Curr,
		CAST(ROUND(DropCharge_Curr, 0) AS int) DropCharge_Curr,
		CAST(ROUND(OASURCHARGE_Curr, 0) AS int) OASURCHARGE_Curr,
		CAST(ROUND(ldw_Curr, 0) AS int) ldw_Curr,
		CAST(ROUND(buydown_Curr, 0) AS int) buydown_Curr,
		CAST(ROUND(pai_Curr, 0) AS int) pai_Curr,
		CAST(ROUND(AdditionalDriver_Curr, 0) AS int) AdditionalDriver_Curr,
		CAST(ROUND(GPSRental_Curr, 0) AS int) GPSRental_Curr,
		CAST(ROUND(Driver_Curr, 0) AS int) Driver_Curr,
		CAST(ROUND(Phone_Curr, 0) AS int) Phone_Curr,
		CAST(ROUND(PEC_Curr, 0) AS int) PEC_Curr,
		CAST(ROUND(BabySeats_Curr, 0) AS int) BabySeats_Curr,
		CAST(ROUND(KPO_Curr, 0) AS int) KPO_Curr,	
		CAST(ROUND(ELI_Curr, 0) AS int) ELI_Curr,
		CAST(ROUND(Cargo_Curr, 0) AS int) Cargo_Curr,
		CAST(ROUND(ForeignOptExtra_Curr, 0) AS int) ForeignOptExtra_Curr,
		Opens_Pre,
		Closes_Pre,
		CAST(ROUND(RentalDays_Pre, 0) AS int) RentalDays_Pre,
		Km_Driven_Pre,
		CAST(ROUND(DailyRental_Pre, 0) AS int) DailyRental_Pre,
		CAST(ROUND(Mileage_Pre, 0) AS int) Mileage_Pre,
		CAST(ROUND(Upgrade_Pre, 0) AS int) Upgrade_Pre,
		CAST(ROUND(MembershipDiscounts_Pre, 0) AS int) MembershipDiscounts_Pre,
		CAST(ROUND(LicenceFeeRecovery_Pre, 0) AS int) LicenceFeeRecovery_Pre,
		CAST(ROUND(ERF_Pre, 0) AS int) ERF_Pre,
		CAST(ROUND(DropCharge_Pre, 0) AS int) DropCharge_Pre,
		CAST(ROUND(OASURCHARGE_Pre, 0) AS int) OASURCHARGE_Pre,
		CAST(ROUND(ldw_Pre, 0) AS int) ldw_Pre,
		CAST(ROUND(buydown_Pre, 0) AS int) buydown_Pre,
		CAST(ROUND(pai_Pre, 0) AS int) pai_Pre,
		CAST(ROUND(AdditionalDriver_Pre, 0) AS int) AdditionalDriver_Pre,
		CAST(ROUND(GPSRental_Pre, 0) AS int) GPSRental_Pre,
		CAST(ROUND(Driver_Pre, 0) AS int) Driver_Pre,
		CAST(ROUND(Phone_Pre, 0) AS int) Phone_Pre,
		CAST(ROUND(PEC_Pre, 0) AS int) PEC_Pre,
		CAST(ROUND(BabySeats_Pre, 0) AS int) BabySeats_Pre,
		CAST(ROUND(KPO_Pre, 0) AS int) KPO_Pre,	
		CAST(ROUND(ELI_Pre, 0) AS int) ELI_Pre,
		CAST(ROUND(Cargo_Pre, 0) AS int) Cargo_Pre,
		CAST(ROUND(ForeignOptExtra_Pre, 0) AS int) ForeignOptExtra_Pre,
--		isnull(Average_Fleet_Curr,0) as Average_Fleet_Curr,
--		isnull(Average_Fleet_Pre,0) as Average_Fleet_Pre,
		isnull(CAST(ROUND(Average_Fleet_Curr,0) as int),0) as Average_Fleet_Curr,
		isnull(CAST(ROUND(Average_Fleet_Pre,0) as int),0) as Average_Fleet_Pre,
		datediff(d,@paramStartDate,@paramEndDate)+1 as BusinessDays

--select *
from 
	(select	Vehicle_Type_ID,
			Location_ID,
			Location_Name,
			sum(Check_Out) as Opens_Curr,
			sum(Check_In) as Closes_Curr,
			sum(Rental_Days) as RentalDays_Curr,
			sum(Km_Driven)as Km_Driven_Curr,
			sum(DailyRental_Charge) as DailyRental_Curr,
			sum(KM_Charge)as Mileage_Curr,
			sum(Upgrade_Charge)	as Upgrade_Curr,
			sum(MemebershipDiscount_Charge)as MembershipDiscounts_Curr,
			sum(LicenceFeeRecovery_Charge)	as LicenceFeeRecovery_Curr,
			sum(ERF_Charge) as ERF_Curr,
			sum(Drop_Charge) as DropCharge_Curr,
			sum(OA_SURCHARGE) as OASURCHARGE_Curr,
			sum(LDW_Charge) as ldw_Curr,
			sum(Buydown_Charge) as buydown_Curr,
			sum(PAI_Charge) as pai_Curr,
			sum(AdditionalDriver_Charge)as AdditionalDriver_Curr,
			sum(GPSRental_Charge) as GPSRental_Curr,
			sum(Driver_SurCharge) as Driver_Curr,
			sum(Phone_Charge) as Phone_Curr,
			sum(PEC_Charge) as PEC_Curr,
			sum(BabySeats_Charge) as BabySeats_Curr,
			sum(KPO_Charge) as KPO_Curr,	
			sum(ELI_Charge) as ELI_Curr,
			sum(Cargo_Charge) as Cargo_Curr,
			sum(Foreign_Opt_Extra_Charge) as ForeignOptExtra_Curr
	from (
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

			FROM 	#Contract_CI_Curr 
			WHERE BRAC_Unit=1
			GROUP BY 
					RBR_Date,
     				Vehicle_Type_ID,
     				Pick_Up_Location_ID,
     				Location_Name
			) vci 
				FULL	OUTER		JOIN
   			(SELECT 	
				RBR_Date, 
    			Vehicle_Type_ID, 
    			Pick_Up_Location_ID, 
    			Location_Name, 
    			COUNT(*) AS Check_Out
			 FROM 	#Contract_CO_Curr 
				WHERE BRAC_Unit=1
				GROUP BY 
					RBR_Date,  
					Vehicle_Type_ID, 
    				Pick_Up_Location_ID, 
					Location_Name
			) vco
			ON vci.RBR_Date = vco.RBR_Date		AND 
			vci.Vehicle_Type_ID = vco.Vehicle_Type_ID
			AND vci.Pick_Up_Location_ID = vco.Pick_Up_Location_ID
	) SM
	group by 				Vehicle_Type_ID,
			Location_ID,
			Location_Name

	) Con_Curr
full join 

	(select	Vehicle_Type_ID,
			Location_ID,
			Location_Name,
			sum(Check_Out) as Opens_Pre,
			sum(Check_In) as Closes_Pre,
			sum(Rental_Days) as RentalDays_Pre,
			sum(Km_Driven)as Km_Driven_Pre,
			sum(DailyRental_Charge) as DailyRental_Pre,
			sum(KM_Charge)as Mileage_Pre,
			sum(Upgrade_Charge)	as Upgrade_Pre,
			sum(MemebershipDiscount_Charge)as MembershipDiscounts_Pre,
			sum(LicenceFeeRecovery_Charge)	as LicenceFeeRecovery_Pre,
			sum(ERF_Charge) as ERF_Pre,
			sum(Drop_Charge) as DropCharge_Pre,
			sum(OA_SURCHARGE) as OASURCHARGE_Pre,
			sum(LDW_Charge) as ldw_Pre,
			sum(Buydown_Charge) as buydown_Pre,
			sum(PAI_Charge) as pai_Pre,
			sum(AdditionalDriver_Charge)as AdditionalDriver_Pre,
			sum(GPSRental_Charge) as GPSRental_Pre,
			sum(Driver_SurCharge) as Driver_Pre,
			sum(Phone_Charge) as Phone_Pre,
			sum(PEC_Charge) as PEC_Pre,
			sum(BabySeats_Charge) as BabySeats_Pre,
			sum(KPO_Charge) as KPO_Pre,	
			sum(ELI_Charge) as ELI_Pre,
			sum(Cargo_Charge) as Cargo_Pre,
			sum(Foreign_Opt_Extra_Charge) as ForeignOptExtra_Pre
	from (
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

			FROM 	#Contract_CI_Pre 
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
			 FROM 	#Contract_CO_Pre 
				WHERE BRAC_Unit=1
				GROUP BY 
					RBR_Date,  
					Vehicle_Type_ID, 
    				Pick_Up_Location_ID, 
					Location_Name
			) vco
			ON vci.RBR_Date = vco.RBR_Date		AND 
			vci.Vehicle_Type_ID = vco.Vehicle_Type_ID
			AND vci.Pick_Up_Location_ID = vco.Pick_Up_Location_ID
	) SM
	group by 				Vehicle_Type_ID,
			Location_ID,
			Location_Name

	) Con_Pre
	on con_curr.Vehicle_Type_ID=con_pre.Vehicle_Type_ID
		and con_curr.Location_ID=con_pre.Location_ID
		
	left outer join
			(select	Vehicle_Type_ID, 
    				Current_Location_ID, 
    				Current_Location_Name, 
					(cast(cast(sum(rentable)+sum(not_rentable)+sum(Rented) as decimal(11,4))
						 /	(datediff(dd, CONVERT(datetime,  @paramStartDate),CONVERT(datetime,  @paramEndDate))+1) 
						* @AvgTotal_Curr
						/ @AvgBracTotal_Curr  
						as decimal(11,4))) as Average_Fleet_Curr
				from RP_Flt_15_Vehicle_Utilization VU
				   WHERE 
					 rp_date BETWEEN dateadd(dd,1,CONVERT(datetime,  @paramStartDate+' 00:00:00')) AND dateadd(dd,1,CONVERT(datetime,  @paramEndDate+' 23:59:59')) 
					 AND ( @paramLocID='*' OR (VU.Current_Location_ID  in (select * from dbo.Split(@tmpLocID,'~')) ) )
						 AND (@paramVehTypeID='*' OR (vu.Vehicle_Type_ID=@paramVehTypeID) )

				group by 	Vehicle_Type_ID,
							Current_Location_ID,
							Current_Location_Name
			) Fleet_Curr
	on con_curr.vehicle_type_id=fleet_Curr.vehicle_type_id
		and con_curr.Location_ID=fleet_Curr.Current_Location_ID

	left outer join
			(select Vehicle_Type_ID, 
    				Current_Location_ID, 
    				Current_Location_Name, 
					(cast(cast(sum(rentable)+sum(not_rentable)+sum(Rented)as decimal(11,4))
						 /	(datediff(dd, CONVERT(datetime,  @paramStartDate),CONVERT(datetime,  @paramEndDate))+1) 
						* @AvgTotal_Pre
						/ @AvgBracTotal_Pre 
						as decimal(11,4))) as Average_Fleet_Pre
				from RP_Flt_15_Vehicle_Utilization VU
				   WHERE 
					 rp_date BETWEEN dateadd(dd,1,dateadd(yy,-1 ,CONVERT(datetime,  @paramStartDate+' 00:00:00')))
								 AND dateadd(dd,1,dateadd(yy,-1, CONVERT(datetime,  @paramEndDate+' 23:59:59')))	 
					 AND ( @paramLocID='*' OR (VU.Current_Location_ID in (select * from dbo.Split(@tmpLocID,'~')) ) )
						 AND (@paramVehTypeID='*' OR (vu.Vehicle_Type_ID=@paramVehTypeID) )

				group by 	Vehicle_Type_ID,
							Current_Location_ID,
							Current_Location_Name
			)Fleet_Pre
	on con_Pre.vehicle_type_id=fleet_Pre.vehicle_type_id
		and con_Pre.Location_ID=fleet_Pre.Current_Location_ID

where COALESCE (con_curr.Location_Name, con_pre.Location_Name) in (select location from location where owning_company_ID=(select code from lookup_Table where category='BudgetBC Company'))	
order by COALESCE (con_curr.Vehicle_Type_ID, con_pre.Vehicle_Type_ID)


--Change the reportToken flag to be 0
--UPDATE Lookup_Table Set Code='0' WHERE Category='ReportToken'
--
drop table #Contract_CI_Curr
drop table #Contract_CO_Curr
drop table #Contract_CI_Pre
drop table #Contract_CO_Pre













GO
