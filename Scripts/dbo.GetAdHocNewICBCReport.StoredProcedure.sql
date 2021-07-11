USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetAdHocNewICBCReport]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO





---------------------------------------------------------------------------------------
--  Programmer :   Jack Jian
--  Date :              Aug 15, 2001
--  Details: 	 create new icbc report
--  Tracker:	 Issue# 1867
---------------------------------------------------------------------------------------

CREATE Procedure [dbo].[GetAdHocNewICBCReport] 

                 @StartDateInput varchar(30)='Dec 01 2000', 
                 @EndDateInput varchar(30)='Dec 31 2000'

AS 

SET NOCOUNT ON 

DECLARE @StartDate datetime, @EndDate datetime
SELECT @StartDate = CONVERT(DATETIME, @StartDateInput)
SELECT @EndDate = CONVERT(DATETIME, @EndDateInput)+1

--PRINT ' *************** Closed Contracts For ICBC *************'
--PRINT ' *** Report Period Starts From:'+@StartDateInput+'  To: '+@EndDateInput+'             ***'
--PRINT ' *** Report Time: '+ CONVERT(VARCHAR(30),GETDATE())+'                                   ***'
--PRINT ''

select    con.contract_number as 'Contract#',  vc.Vehicle_Type_ID,
	rate.rate_name ,
             con.Pick_Up_On as PickUpDate ,
             con.Drop_Off_On as DropOffDate ,
	DATEDIFF(DAYOFYEAR,con.pick_up_on,con.drop_off_on ) as days

FROM Contract con
 INNER JOIN dbo.Vehicle_Class vc ON con.Vehicle_Class_Code = vc.Vehicle_Class_Code
join  Vehicle_Rate rate
   on con.Rate_ID=rate.Rate_ID and @EndDate < rate.Termination_Date
join business_transaction bt
   on bt.Transaction_Description = 'Check in'   and bt.contract_number = con.contract_number
	and bt.Transaction_Date >= @StartDate and bt.Transaction_Date < @EndDate

WHERE 
	rate.Rate_Purpose_ID in (14, 18) -- (Insurance Replacement, Service Shop/Dealership)
	AND con.status='ci'

--	AND con.pick_up_on >=@StartDate AND con.pick_up_on<@EndDate
--	AND con.drop_off_on between @StartDate AND @EndDate

ORDER BY rate.Rate_Name,con.Contract_Number

--COMPUTE COUNT(con.Contract_Number), SUM(DATEDIFF(DAYOFYEAR,con.pick_up_on,con.drop_off_on )) BY rate.Rate_Name
--SET NOCOUNT OFF
--RETURN 0



GO
