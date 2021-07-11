USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateVehicleAvailability]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

-- Create By Roy He  ----
 CREATE  Procedure [dbo].[CreateVehicleAvailability] as
 
Declare @maxRptDate datetime
Declare @DayNum Int

Select @DayNum=Max(DayNum) from RP_Day_Number
--select * from RP_Day_Number
Select @maxRptDate= CONVERT(VarChar, Dateadd( d, @DayNum, getdate()),106)

--Print @maxRptDate

Delete RP_Fleet_Availability --where Rpt_Date between CONVERT(VarChar, getdate(), 106) And @maxRptDate

declare @rptDate datetime, --varchar(20),
	@vcCode varchar(1)

DECLARE rptDate_cursor CURSOR FOR
SELECT	 CONVERT(VarChar, Dateadd( d, DayNum, getdate()),106)
FROM	RP_Day_Number
--WHERE	( DayNum>0)
order by DayNum
	
OPEN rptDate_cursor

-- Perform the first fetch and store the values in variables.
-- Note: The variables are in the same order as the columns
-- in the SELECT statement. 

FETCH NEXT FROM rptDate_cursor
INTO @rptDate

-- Check @@FETCH_STATUS to see if there are any more rows to fetch.
WHILE @@FETCH_STATUS = 0
BEGIN

-- Do the work here
	If  @rptDate=CONVERT(VarChar, getdate(), 106)
	  
	 Begin
--			Print 'Today'
--            Print @rptDate

			 Insert Into   RP_Fleet_Availability
			  Select Rpt_Date,Current_Location_ID,Vehicle_Class_Code, sum(cnt) from 
			   (
					select  @rptDate	 as Rpt_Date,
								v.Current_Location_ID,
								vc.Vehicle_Class_Code,					
								count(*) as cnt
							     	
					from  	Vehicle v WITH(NOLOCK)
						
						inner join
						Vehicle_Class vc
							on v.Vehicle_Class_Code = vc.Vehicle_Class_Code
     						inner join
    						Lookup_Table lt
							on v.Owning_Company_ID = convert(smallint,lt.Code)

					where   v.Current_Vehicle_Status = 'd'
						and
						(lt.Category = 'BudgetBC Company')
						and
						v.Deleted = 0
					Group By 
    						vc.Vehicle_Class_Code,
     						v.Current_Location_ID
				Union
						-- In 
						select Rpt_Date,  DO_ID Current_Location_ID,Vehicle_Class_Code, count(*) as cnt  from RP__Vehicle_Rental_Movement_All where Rpt_Date=@rptDate --and DO_ID=16
						Group by Rpt_Date,DO_ID,Vehicle_Class_Code
						Union
						-- out
						select Rpt_Date,PU_ID Current_Location_ID,Vehicle_Class_Code, count(*)*(-1) as cnt  from RP__Vehicle_Rental_Movement_All where Rpt_Date=@rptDate --and PU_ID=16
						Group by Rpt_Date, PU_ID,Vehicle_Class_Code
			) v
			Group By Rpt_Date,Current_Location_ID,Vehicle_Class_Code
	End

	Else
		Begin
--		Print @rptDate

			 Insert Into  RP_Fleet_Availability
			   
			 Select Rpt_date ,Current_Location_ID,Vehicle_Class_Code, sum(cnt) from 
			   (
 					select  @rptDate Rpt_date,
								Current_location Current_Location_ID,
								Vehicle_Class_Code,				
								Fleet_Total cnt
							     	
					from  	RP_Fleet_Availability WITH(NOLOCK) Where Rpt_date=@rptDate-1 

					Union

					select Rpt_Date,  DO_ID Current_Location_ID,Vehicle_Class_Code, count(*) as cnt  from RP__Vehicle_Rental_Movement_All where Rpt_Date=@rptDate --and DO_ID=16
					Group by Rpt_Date,DO_ID ,Vehicle_Class_Code

					Union

					select Rpt_Date,PU_ID Current_Location_ID,Vehicle_Class_Code, count(*)*(-1) as cnt  from RP__Vehicle_Rental_Movement_All where Rpt_Date=@rptDate --and PU_ID=16
					Group by Rpt_Date, PU_ID,Vehicle_Class_Code
			)v
			Group By Rpt_Date,Current_Location_ID,Vehicle_Class_Code

		End

--    select * from RP__Vehicle_Rental_Movement_All

   FETCH NEXT FROM rptDate_cursor
   INTO @rptDate
END

CLOSE rptDate_cursor
DEALLOCATE rptDate_cursor
GO
