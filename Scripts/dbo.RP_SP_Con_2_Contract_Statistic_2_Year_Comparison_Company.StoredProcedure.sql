USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Con_2_Contract_Statistic_2_Year_Comparison_Company]    Script Date: 2021-07-10 1:50:50 PM ******/
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
                                They are Contract_CI_Curr and Contract_CO_Curr. Contract_CI_Curr will summarize all closed contract statistics. 
                                Contract_CO_Curr will list all check out contracts. 
*/
/* updated to ver 80 */
CREATE PROCEDURE [dbo].[RP_SP_Con_2_Contract_Statistic_2_Year_Comparison_Company]  --'2017-12-01','2017-12-31','Car','16'
(
	@paramStartDate varchar(20) = '01 May 2000',
	@paramEndDate varchar(20) = '07 May 2000',
	@paramVehTypeID varchar(20) = '*',
	@paramLocID varchar(50) = '43'
)
AS

						 
SET NOCOUNT ON
DECLARE 	@startDate datetime,
			@endDate datetime,
			@AvgTotal_Curr as int,
			@AvgBracTotal_Curr as int,
			@AvgTotal_Pre as int,
			@AvgBracTotal_Pre as int

-- fix upgrading problem (SQL7->SQL2000)
DECLARE  @tmpLocID varchar(50)

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
	@endDate	=  CONVERT(datetime,  @paramEndDate++' 00:00:00')	
	
	
	

select	@AvgTotal_Curr=	cast((sum(rentable)+sum(not_rentable)+sum(Rented)) /(datediff(dd, CONVERT(datetime,  @paramStartDate),CONVERT(datetime,  @paramEndDate))+1) as decimal(11,4))
				from RP_Flt_15_Vehicle_Utilization VU
				   WHERE 
					 rp_date BETWEEN dateadd(dd,1,CONVERT(datetime,  @paramStartDate+' 00:00:00')) AND dateadd(dd,1,CONVERT(datetime,  @paramEndDate+' 23:59:59')) 
						 AND (@paramVehTypeID='*' OR (vu.Vehicle_Type_ID=@paramVehTypeID) )
 
select @AvgBracTotal_Curr=cast((sum(rentable)+sum(not_rentable)+sum(Rented)) /(datediff(dd, CONVERT(datetime,  @paramStartDate),CONVERT(datetime,  @paramEndDate))+1) as decimal(11,4))
				from RP_Flt_15_Vehicle_Utilization VU 
						inner join location l on vu.current_location_id=l.location_id
				   WHERE 
					 rp_date BETWEEN dateadd(dd,1,CONVERT(datetime,  @paramStartDate+' 00:00:00')) AND dateadd(dd,1,CONVERT(datetime,  @paramEndDate+' 23:59:59')) 
						--and l.rental_location=1
						and l.owning_company_ID=(select code from lookup_Table where category='BudgetBC Company' )	
						 AND (@paramVehTypeID='*' OR (vu.Vehicle_Type_ID=@paramVehTypeID) )
 

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
						--and l.rental_location=1
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

-- Current Year Revenue
CREATE TABLE #CON_Revenue_Curr(
	[Vehicle_Type_ID] [varchar](18) NULL,
	[Location_ID] [smallint] NULL,
	[Location_Name] [varchar](25) NULL,		 
	[RentalDays_Curr] [decimal](10, 2)  NULL,  	 
	[DailyRental_Curr] [decimal](10, 2)  NULL,
	[Mileage_Curr] [decimal](10, 2)  NULL,
	[Upgrade_Curr] [decimal](10, 2)  NULL,
	[MembershipDiscounts_Curr] [decimal](10, 2)  NULL,
	[LicenceFeeRecovery_Curr] [decimal](10, 2)  NULL,
	[ERF_Curr] [decimal](10, 2)  NULL,
	[DropCharge_Curr] [decimal](10, 2)  NULL,
	[OASURCHARGE_Curr] [decimal](10, 2)  NULL,
	[ldw_Curr] [decimal](10, 2)  NULL,
	[buydown_Curr] [decimal](10, 2)  NULL,
	[pai_Curr] [decimal](10, 2)  NULL,
	[PEC_Curr] [decimal](10, 2)  NULL,
	--[Cargo_Curr] [decimal](10, 2)  NULL,
	[AdditionalDriver_Curr] [decimal](10, 2)  NULL,
	[GPSRental_Curr] [decimal](10, 2)  NULL,
	[Driver_Curr] [decimal](10, 2)  NULL,
	[Moving_Supply_Curr] [decimal](10, 2)  NULL,
	[Moving_Aids_Curr] [decimal](10, 2)  NULL,
	[BabySeats_Curr] [decimal](10, 2)  NULL,
	[SnowTire_Curr] [decimal](10, 2)  NULL,
	[ELI_Curr] [decimal](10, 2)  NULL
) 
  
  Insert Into   #CON_Revenue_Curr
  
	 SELECT 
		Vehicle_Type_ID,
		Location_id, 
        Location_Name,
        sum(DaysCounter) as RentalDays,   
		sum(DailyTime*DaysCounter)+sum(DailyKms*DaysCounter) as TimeCharge, 
		sum(DailyKms*DaysCounter) as KMs,
		sum(DailyUpgrade*DaysCounter) as Upgrade, 		  
		sum(DailyContractDiscount*DaysCounter) as ContractDiscount,
		Sum(DailyVLF*DaysCounter) as VLF, 
		sum(DailyERF*DaysCounter) as ERF,
		sum(DailyDropCharge*DaysCounter) as DropCharge,
		sum(DailyCrossBoardSurcharge*DaysCounter) as CrossBoardSurcharge,
		sum(DailyLDW*DaysCounter) as LDW , 
		sum(DailyBuyDown*DaysCounter) as BuyDown ,
		sum(DailyPAI*DaysCounter) as PAI, 
		sum(DailyPEC*DaysCounter) as PEC, 
		sum(DailyAddDriver*DaysCounter) as AddDriver,  
		sum(Dailygps*DaysCounter) as GPS, 
		sum(DailyYoungDriver*DaysCounter) as YoungDriver,		
		sum(DailyMovingSupply*DaysCounter) as MovingSupply,		
		sum(DailyMovingAids*DaysCounter) as MovingAids, 
		sum(DailyBabySeats) as BabySeats, 		
		sum(DailySnowTires*DaysCounter) as SnowTires, 
		sum(DailyELI*DaysCounter) as ELI 
		--sum(Dailyfpo*DaysCounter) as FPO ,
				 
	FROM  
	 (
			SELECT
			contract_number, 
			Pick_Up_On,
			Check_In,
			Rental_Days, 
			Vehicle_Type_ID,
			Location_id, 
            Location_Name,  
			--Vehicle_Class_Code, 
			
			(Case 
				When Pick_Up_On >= @startDate and Check_In < @endDate+1	
				Then datediff(mi,Pick_Up_On,Check_In)/ 1440.00
			--2		MB	CO	ME	CI
				When Pick_Up_On> = @startDate  And Pick_Up_On < @endDate+1 and @endDate+1<=Check_In
				Then datediff(mi,Pick_Up_On,@endDate+1)/ 1440.00
			--3		CO	MB	CI	ME		 
				When @startDate>=Pick_Up_On and @startDate<=Check_In  And Check_In <@endDate +1
						 
				Then datediff(mi,@startDate,Check_In)/ 1440.00
			--4		CO	MB	ME	CI
				When @startDate>=Pick_Up_On and @endDate+1<=Check_In 
				Then  datediff(mi,@startDate,@endDate+1)/ 1440.00
			End) DaysCounter,	
			RIGHT(CONVERT(varchar, DisplayOrder + 100), 2)	+ ' - ' + Vehicle_Class_Name Vehicle_Class_Name, 				
			Case when Rental_Days>0 
					then TimeCharge/Rental_Days 
					else 0 
				end as DailyTime, 
			Case when Rental_Days>0 
					then Upgrade/Rental_Days 
					else 0 
				end as DailyUpgrade, 
			Case when Rental_Days>0 
					then Kms/Rental_Days 
					else 0
				end as DailyKMs, 
			
			Case when Rental_Days>0 
					then ContractDiscount/Rental_Days 
					else 0
				end as DailyContractDiscount, 			 
			Case when Rental_Days>0 
					then LDW/Rental_Days 
					else 0
				end as DailyLDW , 
			Case when Rental_Days>0 
					then PAI/Rental_Days 
					else 0
				end as DailyPAI, 
			Case when Rental_Days>0 
					then PEC/Rental_Days 
					else 0
				end	as DailyPEC, 
			Case when Rental_Days>0 
					then MovingAids/Rental_Days 
					else 0
				end	as DailyMovingAids, 
			Case when Rental_Days>0 
					then MovingSupply/Rental_Days 
					else 0
				end as DailyMovingSupply,
			Case when Rental_Days>0 
					then VLF/Rental_Days 
					else 0
				end	as DailyVLF, 
			Case when Rental_Days>0 
					then LRF/Rental_Days 
					else 0
				end	as DailyLRF,
			Case when Rental_Days>0 
					then DropCharge/Rental_Days 
					else 0
				end	as DailyDropCharge,
			Case when Rental_Days>0 
					then Additional_Driver_Charge/Rental_Days 
					else 0
				end	as DailyAddDriver,  
			Case when Rental_Days>0 
					then Driver_Under_Age/Rental_Days 
					else 0
				end	as DailyYoungDriver,
			Case when Rental_Days>0 
					then BuyDown/Rental_Days 
					else 0
				end	as DailyBuyDown ,
			Case when Rental_Days>0 
					then gps/Rental_Days 
					else 0
				end	as DailyGPS, 
			Case when Rental_Days>0 
					then fpo/Rental_Days 
					else 0
				end	as DailyFPO ,
			Case when Rental_Days>0 
					then ELI/Rental_Days 
					else 0
				end	as DailyELI, 
			Case when Rental_Days>0 
					then CrossBoardSurcharge/Rental_Days 
					else 0
				end	as DailyCrossBoardSurcharge,
			Case when Rental_Days>0 
					then SnowTires/Rental_Days 
					else 0
				end	as DailySnowTires, 
			Case when Rental_Days>0 
					then ERF/Rental_Days 
					else 0
				end	as DailyERF,
			Case when Rental_Days>0 
					then BabySeats/Rental_Days 
					else 0
				end	as DailyBabySeats 
			 
			
			 
		FROM      [RP_Con_2_Contract_Statistic_2_Year_Comparison]

	 

		WHERE   ( @paramVehTypeID = '*' OR Vehicle_Type_ID = @paramVehTypeID)
			--AND
 		--	(@paramVehicleClassID = '*' OR Vehicle_Class_Code = @paramVehicleClassID)  			 
 			AND ( @paramLocID='*' OR (Location_id in (select * from dbo.Split(@tmpLocID,'~')) ) )		
			AND
			(
				(Pick_Up_On >= @startDate and Check_In < @endDate+1	)  
				Or
				(Pick_Up_On> = @startDate  And Pick_Up_On < @endDate+1 and @endDate+1<=Check_In)
				Or
				(@startDate>=Pick_Up_On and @startDate<=Check_In  And Check_In <@endDate +1)
				Or
				(@startDate>=Pick_Up_On and @endDate+1<=Check_In)
			)
	 )	RADetail
	 Group by  Vehicle_Type_ID,Location_id, Location_Name 

--Last Year 
SELECT	@startDate	= dateadd(yy,-1 ,CONVERT(datetime,  @paramStartDate+' 00:00:00')),
	@endDate	= dateadd(yy,-1, CONVERT(datetime,  @paramEndDate+' 00:00:00'))	



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
	 AND ( @paramLocID='*' OR (con.pick_up_location_id in (select * from dbo.Split(@tmpLocID,'~')) ) )
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
 
 

-- Create contract revenue for Previous year
CREATE TABLE #CON_Revenue_Prev(
	[Vehicle_Type_ID] [varchar](18) NULL,
	[Location_ID] [smallint] NULL,
	[Location_Name] [varchar](25) NULL,		 
	[RentalDays_Pre] [decimal](10, 2)  NULL,	 
	[DailyRental_Pre] [decimal](10, 2)  NULL,
	[Mileage_Pre] [decimal](10, 2)  NULL,
	[Upgrade_Pre] [decimal](10, 2)  NULL,
	[MembershipDiscounts_Pre] [decimal](10, 2)  NULL,
	[LicenceFeeRecovery_Pre] [decimal](10, 2)  NULL,
	[ERF_Pre] [decimal](10, 2)  NULL,
	[DropCharge_Pre] [decimal](10, 2)  NULL,
	[OASURCHARGE_Pre] [decimal](10, 2)  NULL,
	[ldw_Pre] [decimal](10, 2)  NULL,
	[buydown_Pre] [decimal](10, 2)  NULL,
	[pai_Pre] [decimal](10, 2)  NULL,
	[PEC_Pre] [decimal](10, 2)  NULL,
	--[Cargo_Pre] [decimal](10, 2)  NULL,
	[AdditionalDriver_Pre] [decimal](10, 2)  NULL,
	[GPSRental_Pre] [decimal](10, 2)  NULL,
	[Driver_Pre] [decimal](10, 2)  NULL,
	[Moving_Supply_Pre] [decimal](10, 2)  NULL,
	[Moving_Aids_Pre] [decimal](10, 2)  NULL,	
	[BabySeats_Pre] [decimal](10, 2)  NULL,
	[SnowTire_Pre] [decimal](10, 2)  NULL,
	[ELI_Pre] [decimal](10, 2)  NULL 
) 

  Insert Into   #CON_Revenue_Prev
  
	 SELECT 
		Vehicle_Type_ID,
		Location_id, 
        Location_Name,
        sum(DaysCounter) as RentalDays,   
		sum(DailyTime*DaysCounter) +sum(DailyKms*DaysCounter) as TimeCharge, 
		sum(DailyKms*DaysCounter) as KMs,
		sum(DailyUpgrade*DaysCounter) as Upgrade, 		  
		sum(DailyContractDiscount*DaysCounter) as ContractDiscount,
		Sum(DailyVLF*DaysCounter) as VLF, 
		sum(DailyERF*DaysCounter) as ERF,
		sum(DailyDropCharge*DaysCounter) as DropCharge,
		sum(DailyCrossBoardSurcharge*DaysCounter) as CrossBoardSurcharge,
		sum(DailyLDW*DaysCounter) as LDW , 
		sum(DailyBuyDown*DaysCounter) as BuyDown ,
		sum(DailyPAI*DaysCounter) as PAI, 
		sum(DailyPEC*DaysCounter) as PEC, 
		sum(DailyAddDriver*DaysCounter) as AddDriver,  
		sum(Dailygps*DaysCounter) as GPS, 
		sum(DailyYoungDriver*DaysCounter) as YoungDriver,		
		sum(DailyMovingSupply*DaysCounter) as MovingSupply,		
		sum(DailyMovingAids*DaysCounter) as MovingAids, 
		sum(DailyBabySeats) as BabySeats, 		
		sum(DailySnowTires*DaysCounter) as SnowTires, 
		sum(DailyELI*DaysCounter) as ELI 
		--sum(Dailyfpo*DaysCounter) as FPO ,
				 
	FROM  
	 (
			SELECT
			contract_number, 
			Pick_Up_On,
			Check_In,
			Rental_Days, 
			Vehicle_Type_ID,
			Location_id, 
            Location_Name,  
			--Vehicle_Class_Code, 
			
			(Case 
				When Pick_Up_On >= @startDate and Check_In < @endDate+1	
				Then datediff(mi,Pick_Up_On,Check_In)/ 1440.00
			--2		MB	CO	ME	CI
				When Pick_Up_On> = @startDate  And Pick_Up_On < @endDate+1 and @endDate+1<=Check_In
				Then datediff(mi,Pick_Up_On,@endDate+1)/ 1440.00
			--3		CO	MB	CI	ME		 
				When @startDate>=Pick_Up_On and @startDate<=Check_In  And Check_In <@endDate +1
						 
				Then datediff(mi,@startDate,Check_In)/ 1440.00
			--4		CO	MB	ME	CI
				When @startDate>=Pick_Up_On and @endDate+1<=Check_In 
				Then  datediff(mi,@startDate,@endDate+1)/ 1440.00
			End) DaysCounter,	
			RIGHT(CONVERT(varchar, DisplayOrder + 100), 2)	+ ' - ' + Vehicle_Class_Name Vehicle_Class_Name, 				
			Case when Rental_Days>0 
					then TimeCharge/Rental_Days 
					else 0 
				end as DailyTime, 
			Case when Rental_Days>0 
					then Upgrade/Rental_Days 
					else 0 
				end as DailyUpgrade, 
			Case when Rental_Days>0 
					then Kms/Rental_Days 
					else 0
				end as DailyKMs, 
			
			Case when Rental_Days>0 
					then ContractDiscount/Rental_Days 
					else 0
				end as DailyContractDiscount, 			 
			Case when Rental_Days>0 
					then LDW/Rental_Days 
					else 0
				end as DailyLDW , 
			Case when Rental_Days>0 
					then PAI/Rental_Days 
					else 0
				end as DailyPAI, 
			Case when Rental_Days>0 
					then PEC/Rental_Days 
					else 0
				end	as DailyPEC, 
			Case when Rental_Days>0 
					then MovingAids/Rental_Days 
					else 0
				end	as DailyMovingAids, 
			Case when Rental_Days>0 
					then MovingSupply/Rental_Days 
					else 0
				end as DailyMovingSupply,
			Case when Rental_Days>0 
					then VLF/Rental_Days 
					else 0
				end	as DailyVLF, 
			Case when Rental_Days>0 
					then LRF/Rental_Days 
					else 0
				end	as DailyLRF,
			Case when Rental_Days>0 
					then DropCharge/Rental_Days 
					else 0
				end	as DailyDropCharge,
			Case when Rental_Days>0 
					then Additional_Driver_Charge/Rental_Days 
					else 0
				end	as DailyAddDriver,  
			Case when Rental_Days>0 
					then Driver_Under_Age/Rental_Days 
					else 0
				end	as DailyYoungDriver,
			Case when Rental_Days>0 
					then BuyDown/Rental_Days 
					else 0
				end	as DailyBuyDown ,
			Case when Rental_Days>0 
					then gps/Rental_Days 
					else 0
				end	as DailyGPS, 
			Case when Rental_Days>0 
					then fpo/Rental_Days 
					else 0
				end	as DailyFPO ,
			Case when Rental_Days>0 
					then ELI/Rental_Days 
					else 0
				end	as DailyELI, 
			Case when Rental_Days>0 
					then CrossBoardSurcharge/Rental_Days 
					else 0
				end	as DailyCrossBoardSurcharge,
			Case when Rental_Days>0 
					then SnowTires/Rental_Days 
					else 0
				end	as DailySnowTires, 
			Case when Rental_Days>0 
					then ERF/Rental_Days 
					else 0
				end	as DailyERF,
			Case when Rental_Days>0 
					then BabySeats/Rental_Days 
					else 0
				end	as DailyBabySeats 
			 
			
			 
		FROM      [RP_Con_2_Contract_Statistic_2_Year_Comparison]

	 

		WHERE   ( @paramVehTypeID = '*' OR Vehicle_Type_ID = @paramVehTypeID)
			--AND
 		--	(@paramVehicleClassID = '*' OR Vehicle_Class_Code = @paramVehicleClassID) 
 			AND ( @paramLocID='*' OR (Location_id in (select * from dbo.Split(@tmpLocID,'~')) ) )
 				
			AND
			(
				(Pick_Up_On >= @startDate and Check_In < @endDate+1	)  
				Or
				(Pick_Up_On> = @startDate  And Pick_Up_On < @endDate+1 and @endDate+1<=Check_In)
				Or
				(@startDate>=Pick_Up_On and @startDate<=Check_In  And Check_In <@endDate +1)
				Or
				(@startDate>=Pick_Up_On and @endDate+1<=Check_In)
			)
	 )	RADetail
	 Group by  Vehicle_Type_ID,Location_id, Location_Name 


--Summary CO and CI 


CREATE TABLE #CON_COCI_Sum(
	[Vehicle_Type_ID] [varchar](18) NULL,
	[Location_ID] [smallint] NULL,
	[Location_Name] [varchar](25) NULL,
	[Opens_Curr] [int] NULL,
	[Closes_Curr] [int] NULL,
	[Opens_Pre] [int] NULL,
	[Closes_Pre] [int] NULL,
	[Average_Fleet_Curr] [int] NULL,
	[Average_Fleet_Pre] [int] NULL,
	[BusinessDays] [int] NULL
)  

If @AvgBracTotal_Curr= 0
	Select @AvgBracTotal_Curr=1
--If @AvgTotal_Curr= 0

--Select @AvgTotal_Curr=1
	

--If @AvgTotal_Pre= 0
--	Begin   
--		Select @AvgTotal_Pre=1
--	end

If @AvgBracTotal_Pre= 0   
		Select @AvgBracTotal_Pre=1
 
	
	
	print '@AvgTotal_Pre' + Convert(varchar(2), @AvgTotal_Pre)
	print '@@AvgBracTotal_Pre' + Convert(varchar(2),@AvgBracTotal_Pre)

Insert  Into #CON_COCI_Sum
select	COALESCE (con_curr.Vehicle_Type_ID, con_pre.Vehicle_Type_ID) AS Vehicle_Type_ID,
    	COALESCE (con_curr.Location_ID, con_pre.Location_ID) AS Location_ID,
    	COALESCE (con_curr.Location_Name, con_pre.Location_Name) AS Location_Name,	
		Opens_Curr,
		Closes_Curr,		 
		Opens_Pre,
		Closes_Pre,
		isnull(CAST(ROUND(Average_Fleet_Curr,0) as int),0) as Average_Fleet_Curr,
		isnull(CAST(ROUND(Average_Fleet_Pre,0) as int),0) as Average_Fleet_Pre,
		datediff(d,@paramStartDate,@paramEndDate)+1 as BusinessDays

--select *

from 
	(select	Vehicle_Type_ID,
			Location_ID,
			Location_Name,
			sum(Check_Out) as Opens_Curr,
			sum(Check_In) as Closes_Curr
			
	from (
	SELECT 	
		COALESCE (vci.RBR_Date, vco.RBR_Date) AS Business_Date,
    		COALESCE (vci.Vehicle_Type_ID, vco.Vehicle_Type_ID) AS Vehicle_Type_ID,
    		COALESCE (vci.Pick_Up_Location_ID, vco.Pick_Up_Location_ID) AS Location_ID,
    		COALESCE (vci.Location_Name, vco.Location_Name) AS Location_Name,	
    		COALESCE(vco.Check_Out,0) AS Check_Out,
		COALESCE(vci.Check_In,0) AS Check_In
	FROM 	(SELECT 	
				RBR_Date,
     			Vehicle_Type_ID,
     			Pick_Up_Location_ID,
     			Location_Name, 
    			COUNT(*) AS Check_In 

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
			sum(Check_In) as Closes_Pre
			 
	from (
	SELECT 	
		COALESCE (vci.RBR_Date, vco.RBR_Date) AS Business_Date,
    		COALESCE (vci.Vehicle_Type_ID, vco.Vehicle_Type_ID) AS Vehicle_Type_ID,
    		COALESCE (vci.Pick_Up_Location_ID, vco.Pick_Up_Location_ID) AS Location_ID,
    		COALESCE (vci.Location_Name, vco.Location_Name) AS Location_Name,	
    		COALESCE(vco.Check_Out,0) AS Check_Out,
		COALESCE(vci.Check_In,0) AS Check_In
 
	FROM 	(SELECT 	
				RBR_Date,
     			Vehicle_Type_ID,
     			Pick_Up_Location_ID,
     			Location_Name, 
    			COUNT(*) AS Check_In--, 
  

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
					--(cast(cast(sum(rentable)+sum(not_rentable)+sum(Rented) as decimal(11,4))
					--	 /	(datediff(dd, CONVERT(datetime,  @paramStartDate),CONVERT(datetime,  @paramEndDate))+1) 
					--	* @AvgTotal_Curr
					--	/ @AvgBracTotal_Curr  
					--	as decimal(11,4))) 
						
						@AvgTotal_Curr as Average_Fleet_Curr
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
					--(cast(cast(sum(rentable)+sum(not_rentable)+sum(Rented)as decimal(11,4))
					--	 /	(datediff(dd, CONVERT(datetime,  @paramStartDate),CONVERT(datetime,  @paramEndDate))+1) 
					--	* @AvgTotal_Pre
					--	/ @AvgBracTotal_Pre 
					--	as decimal(11,4))) as 
					@AvgTotal_Pre as	Average_Fleet_Pre
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


select  CICO.Vehicle_Type_ID,    	
    	'Total' as Location_ID,
		'Total' as Location_Name,
		SUM(Opens_Curr) Opens_Curr,
		SUM(Closes_Curr) Closes_Curr,
		SUM(RentalDays_Curr ) RentalDays_Curr ,
		SUM(DailyRental_Curr) DailyRental_Curr,
		SUM(Mileage_Curr) Mileage_Curr,
		SUM(Upgrade_Curr) Upgrade_Curr,
		SUM(MembershipDiscounts_Curr) MembershipDiscounts_Curr,
		SUM(LicenceFeeRecovery_Curr) LicenceFeeRecovery_Curr,
		SUM(ERF_Curr) ERF_Curr,
		SUM(DropCharge_Curr) DropCharge_Curr,
		SUM(OASURCHARGE_Curr) OASURCHARGE_Curr,
		SUM(ldw_Curr) ldw_Curr,
		SUM(buydown_Curr) buydown_Curr,
		SUM(pai_Curr) pai_Curr,
		SUM(AdditionalDriver_Curr) AdditionalDriver_Curr,
		SUM(GPSRental_Curr) GPSRental_Curr,
		SUM(Driver_Curr) Driver_Curr,
		SUM(Moving_Supply_Curr) Moving_Supply_Curr,
		SUM(Moving_Aids_Curr) Moving_Aids_Curr,
		SUM(PEC_Curr) PEC_Curr,
		SUM(BabySeats_Curr ) BabySeats_Curr ,
		SUM(SnowTire_Curr) SnowTire_Curr,
		SUM(ELI_Curr) ELI_Curr,
		SUM(Opens_Pre) Opens_Pre,
		SUM(Closes_Pre) Closes_Pre,
		SUM(RentalDays_Pre) RentalDays_Pre,
		SUM(DailyRental_Pre) DailyRental_Pre,
		SUM(Mileage_Pre) Mileage_Pre,
		SUM(Upgrade_Pre) Upgrade_Pre,
		SUM(MembershipDiscounts_Pre) MembershipDiscounts_Pre,
		SUM(LicenceFeeRecovery_Pre) LicenceFeeRecovery_Pre,
		SUM(ERF_Pre) ERF_Pre,
		SUM(DropCharge_Pre) DropCharge_Pre,
		SUM(OASURCHARGE_Pre) OASURCHARGE_Pre,
		SUM(ldw_Pre) ldw_Pre,
		SUM(buydown_Pre) buydown_Pre,
		SUM(pai_Pre) pai_Pre,
		SUM(AdditionalDriver_Pre) AdditionalDriver_Pre,
		SUM(GPSRental_Pre) GPSRental_Pre,
		SUM(Driver_Pre ) Driver_Pre ,
		SUM(Moving_Supply_Pre) Moving_Supply_Pre,
		SUM(Moving_Aids_Pre) Moving_Aids_Pre,
		SUM(PEC_Pre) PEC_Pre,
		SUM(BabySeats_Pre) BabySeats_Pre,
		SUM(SnowTire_Pre) SnowTire_Pre,
		SUM(ELI_Pre) ELI_Pre,
		--SUM(isnull(CAST(ROUND(Average_Fleet_Curr,0) as int),0)) as Average_Fleet_Curr,
		--SUM(isnull(CAST(ROUND(Average_Fleet_Pre,0) as int),0)) as Average_Fleet_Pre,
		-- for the company total, we don't need to prorate.
		isnull(CAST(ROUND(@AvgTotal_Curr,0) as int),0)  as Average_Fleet_Curr,
		isnull(CAST(ROUND(@AvgTotal_Pre,0) as int),0) as Average_Fleet_Pre,
		--SUM(Average_Fleet_Curr) Average_Fleet_Curr,
		--SUM(Average_Fleet_Pre) Average_Fleet_Pre,
		BusinessDays

from  #CON_COCI_Sum CICO
Left Join #CON_Revenue_Curr	RevCu
On CICO.Vehicle_Type_ID= RevCu.Vehicle_Type_ID
	And	 CICO.Location_ID = RevCu.Location_ID
Left Join #CON_Revenue_Prev RevPr
On CICO.Vehicle_Type_ID= RevPr.Vehicle_Type_ID
	And	 CICO.Location_ID = RevPr.Location_ID
	Group By	CICO.Vehicle_Type_ID,BusinessDays
 

--Change the reportToken flag to be 0
UPDATE Lookup_Table Set Code='0' WHERE Category='ReportToken'

drop table #Contract_CI_Curr
drop table #Contract_CO_Curr
drop table #Contract_CI_Pre
drop table #Contract_CO_Pre
drop table #CON_COCI_Sum
drop table #CON_Revenue_Curr
drop table #CON_Revenue_Prev
GO
