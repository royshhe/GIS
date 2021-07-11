USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Con_12_Government_Monthly_Summary_Tracking]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--select * from vehicle_Class

/*
PURPOSE: 
REQUIRES: 
AUTHOR: Roy He
DATE CREATED: Jan 25, 2008
CALLED BY: 
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[RP_SP_Con_12_Government_Monthly_Summary_Tracking]  --'01 Jan 2009', '31 oct 2009'
	@paramStartDate varchar(20) = '15 April 1999',
	@paramEndDate varchar(20) = '15 April 1999'
AS


declare @VehicleClassName varchar(25)
DECLARE @SQLString VARCHAR(8000)

DECLARE VCName_cursor CURSOR FOR
SELECT	replace(Vehicle_Class_Name,'''','')
FROM	vehicle_Class
--WHERE	( Vehicle_Type_ID ='Car') 
order by Vehicle_Class_Name
	
OPEN VCName_cursor

-- Perform the first fetch and store the values in variables.
-- Note: The variables are in the same order as the columns
-- in the SELECT statement. 

Select @SQLString='SELECT PU_Location, Month(RBR_Date) RBR_Month, count(*) Contract_Count,sum(Contract_Rental_Days) as Rental_Days, sum(TimeCharge) as TimeCharge, sum(KMCharge) as KMCharge,sum(DropOff_Charge)+sum(Additional_Driver_Charge) as OtherCharge, sum(All_Level_LDW) as LDW, sum(PAI) as PAI, sum(PEC) as PEC,'

FETCH NEXT FROM VCName_cursor
INTO @VehicleClassName

-- Check @@FETCH_STATUS to see if there are any more rows to fetch.
WHILE @@FETCH_STATUS = 0
BEGIN
  
	Select @SQLString= @SQLString + 'Sum(Case When Vehicle_Class_Name in('''+@VehicleClassName+''') then 1
				                  Else 0
				             End)  "'+@VehicleClassName +'",'
  

   FETCH NEXT FROM VCName_cursor


   INTO @VehicleClassName
End
Select @SQLString= substring(@SQLString,1, len(@SQLString)-1)+
'FROM  dbo.Contract_Revenue_Goverment_Tracking_sum_vw
where rbr_date between '''+ @paramStartDate + ''' and '''+@paramEndDate+''' GROUP BY PU_Location, Month(RBR_Date)
order by PU_Location, Month(RBR_Date)'

CLOSE VCName_cursor
DEALLOCATE VCName_cursor

--print @sqlstring
exec (@SQLString)

/*
SELECT PU_Location, Month(RBR_Date) RBR_Month, count(*) Contract_Count,

sum(Contract_Rental_Days) as Rental_Days, sum(TimeCharge)+ sum(KMCharge) as Revenue, sum(All_Level_LDW) as LDW, sum(PAI) as PAI, sum(PEC) as PEC,

Sum(Case When Vehicle_Class_Name in('Economy') then 1
      Else 0
 End) EC,

Sum(Case When Vehicle_Class_Name in('Compact (Air)','Compact') then  1
      Else 0
 End) CC,

SUM(Case When Vehicle_Class_Name in('Intermediate','Intermediate (Air)','Sport Coupe','Sport GT Coupe','Hybrid')  then  1
      Else 0
 End) IC,

SUM(Case When Vehicle_Class_Name in('Full Size 2Door','Full Size 4Door') then  1
      Else 0
 End) FC,

SUM(Case When Vehicle_Class_Name in('Premium') then  1
      Else 0
 End) PC,

SUM(Case When Vehicle_Class_Name in('Luxury') then  1
      Else 0
 End) LC,

SUM(Case When Vehicle_Class_Name in('Minivan','Minivan (8pass)') then  1
      Else 0
 End) MV,

SUM(Case When Vehicle_Class_Name in('Mid-Size SUV') then  1
      Else 0
 End) MF,

SUM(Case When Vehicle_Class_Name in('Sport Utility') then  1
      Else 0
 End) MV,

SUM(Case When Vehicle_Class_Name in('Luxury 4X4') then  1
      Else 0
 End) LF,

SUM(Case When Vehicle_Class_Name in('Sport Convertible','Sport Convertible-GT','Sport Convertible-Luxury'  ) then  1
      Else 0
 End) SC,

SUM(Case When Vehicle_Class_Name in('Station Wagon'  ) then  1
      Else 0
 End) SW,

SUM(Case When Vehicle_Class_Name in('Pickup'  ) then  1
      Else 0
 End) Pickup,

SUM(Case When Vehicle_Class_Name in('Cargo Van'  ) then  1
      Else 0
 End) "Cargo Van",

SUM(Case When Vehicle_Class_Name in('15 Passengers Bus') then  1
      Else 0
 End) "15P"

FROM  dbo.Contract_Revenue_Goverment_Tracking_sum_vw
where rbr_date between '2005-01-01' and '2005-12-31'
GROUP BY PU_Location, Month(RBR_Date)
order by PU_Location, Month(RBR_Date)
*/




GO
