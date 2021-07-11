USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetVehClassIDByRateLevel]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/*
PURPOSE: To retrieve all vehicle classes (identified by Rate_Vehicle_Class_Id) 
	 defined for a given rate and level.
MOD HISTORY:
Name	Date        	Comments
Don K	Feb 29 2000	Added explicit ORDER BY clause
*/
CREATE PROCEDURE [dbo].[GetVehClassIDByRateLevel]
	@RateID varchar(20), @Level varchar(20)
AS
Set Rowcount 2000
Select Distinct
	dbo.Rate_Charge_Amount.Rate_Vehicle_Class_ID,dbo.Vehicle_Class.displayorder
From
	Rate_Charge_Amount
 inner JOIN
                      dbo.Rate_Vehicle_Class ON dbo.Rate_Charge_Amount.Rate_Vehicle_Class_ID = dbo.Rate_Vehicle_Class.Rate_Vehicle_Class_ID AND 
                      dbo.Rate_Charge_Amount.Rate_ID = dbo.Rate_Vehicle_Class.Rate_ID  inner JOIN
                      dbo.Vehicle_Class ON dbo.Rate_Vehicle_Class.Vehicle_Class_Code = dbo.Vehicle_Class.Vehicle_Class_Code
Where
	dbo.Rate_Charge_Amount.Rate_ID = Convert(int,@RateID)
	And Rate_Level = @Level
	And dbo.Rate_Charge_Amount.Termination_Date = 'Dec 31 2078 11:59PM'
	And dbo.Rate_Vehicle_Class.Termination_Date = 'Dec 31 2078 11:59PM'
ORDER
BY	dbo.Vehicle_Class.displayorder
Return 1
GO
