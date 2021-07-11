USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Con_21_Sendback_Transaction_Detail]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* updated to ver 80 */
Create PROCEDURE [dbo].[RP_SP_Con_21_Sendback_Transaction_Detail] --'09 jun 2016','10 jun 2016'
(
	@paramStartDate varchar(24) = '01 May 2000 00:00',
	@paramEndDate varchar(24) = '07 May 2000 00:00'
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
SELECT	@startDate	= CONVERT(datetime,  @paramStartDate),
	@endDate	= CONVERT(datetime, @paramEndDate)	


SELECT 
--PU_Location as Location,
--POW.Name as ,
CRS.Contract_Number, 
VOW.Name Owning_Company,
POW.Name Renting_company, 
DOW.Name Receiving_company, 
--PU_Location Renting_location,
--DO_Location Receiving_location,
	 
--DOW.Name as Receiving_Company,
--year(RBR_Date) TransYear,month(RBR_Date)TransMonth, --day(RBR_Date) Day,
--count(*) as TransactionCount, 
Pick_Up_On,
Actual_Check_in,
round(Contract_Rental_Days,2) as RentalDays,
TimeCharge  TimeCharge, 
All_Level_LDW,
(Amount-TimeCharge-All_Level_LDW) OtherItems,
Amount Total_Amount,
Round(TimeCharge/Contract_Rental_Days,2) TimeChargeDDA

FROM  dbo.Contract_Revenue_Sum_vw CRS
INNER JOIN
       dbo.Contract_Payment_Amount_vw AS RAPay ON CRS.Contract_Number = RAPay.Contract_Number
      Inner Join Owning_Company DOW on CRS.DOLoc_OID=DOW.Owning_Company_ID
      Inner Join Owning_Company POW on CRS.PULoc_OID=POW.Owning_Company_ID
       Inner Join Owning_Company VOW on CRS.owning_company_id=VOW.Owning_Company_ID
where 
--((PU_Location = 'B-03 Downtown' and DO_Location= 'B-01 YVR Airport' ) or (DO_Location = 'B-03 Downtown' and PU_Location= 'B-01 YVR Airport' ) )
PULoc_OID=7425 and DOLoc_OID<>7425 and 
RBR_date between @startDate and @endDate
 And CRS.owning_company_id<>7425 -- Foreign Vehicle
--Group by year(RBR_Date),month(RBR_Date),-- PU_Location,
--DOW.Name 
--order by DOW.Name, --PU_Location,
--year(RBR_Date),month(RBR_Date)


 
GO
