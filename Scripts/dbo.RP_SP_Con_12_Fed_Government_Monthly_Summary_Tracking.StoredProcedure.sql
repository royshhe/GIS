USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Con_12_Fed_Government_Monthly_Summary_Tracking]    Script Date: 2021-07-10 1:50:50 PM ******/
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

Create PROCEDURE [dbo].[RP_SP_Con_12_Fed_Government_Monthly_Summary_Tracking] --'01 aug 2012', '31 jul 2013'
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

Select @SQLString='SELECT PU_Location, Convert(Varchar(4), Year(RBR_Date))+''-''+Convert(Varchar(02), Month(RBR_Date)) RBR_Month, count(*) Contract_Count,sum(Contract_Rental_Days) as Rental_Days, sum(TimeCharge) as TimeCharge, sum(KMCharge) as KMCharge,sum(DropOff_Charge)+sum(Additional_Driver_Charge) as OtherCharge, sum(All_Level_LDW) as LDW, sum(PAI) as PAI, sum(PEC) as PEC,'

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
'FROM  dbo.Contract_Revenue_Fed_Tracking_sum_vw
where rbr_date between '''+ @paramStartDate + ''' and '''+@paramEndDate+''' GROUP BY PU_Location,  Convert(Varchar(4), Year(RBR_Date))+''-''+Convert(Varchar(02), Month(RBR_Date))
order by PU_Location,  Convert(Varchar(4), Year(RBR_Date))+''-''+Convert(Varchar(02), Month(RBR_Date))'

CLOSE VCName_cursor
DEALLOCATE VCName_cursor

--print @sqlstring
exec (@SQLString)

		
GO
