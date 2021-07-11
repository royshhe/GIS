USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Flt_7_Fleet_Mix_Monthly]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO





/*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Procedure Name:	RP_SP_Flt_7_Fleet_Mix_Monthly
-- Purpose: 		Create the Fleet Mix Monthly report	
-- Author:		Vivian Leung
-- Date Created: 		03 Dec 2001
-- Modification:	
			Name 		Date		Comments
		Sharon L.	15 Jul 2005	Filter by Location_ID & Class_ID
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

CREATE procedure [dbo].[RP_SP_Flt_7_Fleet_Mix_Monthly] 
(
	@paramVehicleTypeID varchar(10) = '*',
	@paramVehicleClassID char(1) = '*',
	@paramPickUpLocationID varchar(25) = '*',
	@paramStartBusDate varchar(25) = 'Mar 01 2002',
	@paramEndBusDate varchar(25) = 'Mar 31 2002'
)
as

declare  @StartDate datetime, @EndDate datetime
select  @StartDate=CONVERT(DATETIME, @paramStartBusDate )
select @EndDate=CONVERT(DATETIME, @paramEndBusDate )

-- fix upgrading problem (SQL7->SQL2000)
DECLARE  @tmpLocID varchar(20)

if @paramPickUpLocationID = '*'
	BEGIN
		SELECT @tmpLocID='0'
        END
else
	BEGIN
		SELECT @tmpLocID = @paramPickUpLocationID
	END 
-- end of fixing the problem


select 	Rpt_date, 
	l.Location as Current_Location, 
	vc.Vehicle_Class_Name, 	
	Fleet_Total
from 	RP_FleetMixMonthly rp
	left JOIN
	Vehicle_Class vc
		ON rp.Vehicle_Class_Code = vc.Vehicle_Class_Code
	left JOIN
    	Location l
		ON  Current_Location = l.Location_ID
where	(@paramVehicleTypeID = "*" or rp.Vehicle_Type_ID = @paramVehicleTypeID)
	AND
 	(@paramVehicleClassID = "*" OR rp.Vehicle_Class_Code = @paramVehicleClassID)
	and
	(@paramPickUpLocationID = "*" or Current_Location = @tmpLocID)
	and Rpt_date between @StartDate and @EndDate



GO
