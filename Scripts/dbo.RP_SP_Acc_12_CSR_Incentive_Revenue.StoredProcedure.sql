USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Acc_12_CSR_Incentive_Revenue]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[RP_SP_Acc_12_CSR_Incentive_Revenue]
(
	@paramStartBusDate varchar(20) = '22 Apr 2001',
	@paramEndBusDate varchar(20) = '23 Apr 2001',
	@paramVehicleTypeID varchar(18) = 'car',
	@paramPickUpLocationID varchar(20) = '*'
)
AS
--convert strings to datetime
DECLARE 	@startBusDate datetime,
		@endBusDate datetime

SELECT	@startBusDate	= CONVERT(datetime, '00:00:00 ' + @paramStartBusDate),
		@endBusDate	= CONVERT(datetime, '23:59:59 ' + @paramEndBusDate)	


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


--exec RP_SP_Acc_12_CreateCSRRevenue @paramStartBusDate, @paramEndBusDate, @paramVehicleTypeID, @paramPickUpLocationID


select 	distinct EmployeeID,
	Location ,
	Vehicle_Type_ID,
	CSR_Name,
	Contract_In ,
	Rental_Days ,
	Walk_Up ,
	FPO,
	Up_sell ,
	Up_sell_Walkup ,
	Additional_Driver_Charge,
	All_Seats ,
	Driver_Under_Age ,
	All_Level_LDW ,
	PAI ,
	PEC ,
	Ski_Rack ,
	All_Dolly,
	All_Gates ,
	Blanket,
	-- Pay out result
	case when EmployeeStatus = 'T'
		then (Walk_Up_PO +FPO_PO +Up_sell_PO +Additional_Driver_Charge_PO +All_Seats_PO +Driver_Under_Age_PO +All_Level_LDW_PO 
			+PAI_PO  +PEC_PO +Ski_Rack_PO  +All_Dolly_PO  +All_Gates_PO +Blanket_PO) * 0.85
		else (Walk_Up_PO +FPO_PO +Up_sell_PO +Additional_Driver_Charge_PO +All_Seats_PO +Driver_Under_Age_PO +All_Level_LDW_PO 
			+PAI_PO  +PEC_PO +Ski_Rack_PO  +All_Dolly_PO  +All_Gates_PO +Blanket_PO) 
		end 	as Total_Pay_out
	
from CSRIncentiveRevenue
where 		(@paramVehicleTypeID = '*' OR Vehicle_Type_ID = @paramVehicleTypeID)
and		(@paramPickUpLocationID = '*' or CONVERT(INT, @tmpLocID) = Location_ID)
--and		CSR_Name not like 'Fast%Break%' and CSR_Name not like 'Lead%'

GO
