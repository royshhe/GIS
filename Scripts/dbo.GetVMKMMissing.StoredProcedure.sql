USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetVMKMMissing]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO




/*
Purpose: Lists any vehicle movement occurred last week (default) 
	 or in the specified period which use more than 20 KM 
Parameter: User can either enter the report starting date and ending date
         or enter nothing. If no period is specified, system will put the default 
         period, which is last 7 days.       
Author:  Linda Qu
Used By: Ad hoc report - KM missing in vehicle movement weekly report
Date Created: 13 July 2000
Mod History: 
Name 		Date 		Comments
Vivian Leung	14 Nov 2001	Included Foreign Vehicle Unit Number
*/
CREATE PROCEDURE [dbo].[GetVMKMMissing]
       @paramcStartDate  CHAR(15)='',
       @paramcEndDate CHAR(15)=''
AS 

SET NOCOUNT ON 
DECLARE @cSDate CHAR(15), @cEDate CHAR(15),@dSDate DATETIME, @dEDate DATETIME
IF (@paramcStartDate='' AND @paramcEndDate='')
    BEGIN 
	SELECT @cEDate=CONVERT(CHAR(15),GETDATE(),106)
	SELECT @cSDate=CONVERT(CHAR(15),GETDATE()-7,106)
	SELECT @dSDate=CONVERT(DATETIME, '00:00:00 '+@cSDate)
	SELECT @dEDate=CONVERT(DATETIME, '00:00:00 '+@cEDate)
    END 
ELSE  IF (@paramcStartDate='' OR @paramcEndDate='')
      	  BEGIN 
          	PRINT 'You are missing either the starting date or ending date! Please try it again'
                GOTO  Complete
	  END
      ELSE 
          BEGIN
		SELECT @cSDate=@paramcStartDate
		SELECT @cEDate=@paramcEndDate
		SELECT @dSDate=CONVERT(DATETIME, '00:00:00 '+@cSDate)
		SELECT @dEDate=CONVERT(DATETIME, '00:00:00 '+@cEDate)
                SELECT @dEDate=@dEDate+1
          END


IF @dEDate < @dSdate
   BEGIN 
	PRINT 'Invalid reporting period. Please check it out!'
        GOTO Complete
   END

SELECT  Vehicle#=vm.unit_number,	
	ForeignUnit#=Foreign_Vehicle_Unit_Number,
	OutTime=movement_out,
       	 OutLoc=loc1.location,	
	Inloc=loc2.location,
	Km_In,			
	KM_Out,		
	Diff#=KM_In-KM_out
FROM vehicle v
INNER JOIN vehicle_movement vm
	ON v.unit_number = vm.unit_number
INNER JOIN location loc1
	ON loc1.location_id=vm.sending_location_id
INNER JOIN location loc2 
	ON loc2.location_id=vm.receiving_location_id
WHERE 	movement_out BETWEEN @dSDate AND @dEDate
	AND KM_in -KM_out >20
ORDER BY movement_out

SET NOCOUNT OFF
Complete:


GO
