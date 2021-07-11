USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetResHistory]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[GetResHistory] --458248
	@ConfirmNum Varchar(10)
AS
	/* 10/13/99 - do type conversion and nullif outside of SQL statements */
DECLARE	@iConfirmNum Int

	SELECT @iConfirmNum = Convert(Int, NULLIF(@ConfirmNum,''))

	SELECT	
		DISTINCT
		RESCH.Changed_By,
		RESCH.Changed_On,
		LOCPU.Location,
		RESCH.Pick_Up_On,
		LOCDO.Location,
		RESCH.Drop_Off_On,
		VC.Vehicle_Class_Name,
		RESCH.First_Name + ' ' + RESCH.Last_Name,
		VR.Rate_Name,
		RESCH.Date_Rate_Assigned,
		RESCH.Rate_Level,
		LT.Value

	FROM	
		Reservation_Change_history RESCH
		Inner Join 	Vehicle_Class VC
		On RESCH.Vehicle_Class_Code = VC.Vehicle_Class_Code
		Inner Join 	Location LOCPU
		On RESCH.Pick_Up_Location_ID = LOCPU.Location_ID
		Inner Join 	Location LOCDO
		On RESCH.Drop_Off_Location_ID = LOCDO.Location_ID
		Inner Join 	Lookup_Table LT
		ON	RESCH.Status = LT.Code AND	LT.Category = 'Reservation Status'
		Left Join 	Vehicle_Rate VR
		On RESCH.Rate_ID = VR.Rate_ID
	


--FROM	
--		Reservation_Change_history RESCH,
--		Vehicle_Class VC,
--		Location LOCPU,
--		Location LOCDO,
--		Vehicle_Rate VR,
--		Lookup_Table LT



	WHERE	
		RESCH.Confirmation_Number = @iConfirmNum
--	AND	RESCH.Pick_Up_Location_ID = LOCPU.Location_ID
--	AND	RESCH.Drop_Off_Location_ID = LOCDO.Location_ID
--	AND	RESCH.Vehicle_Class_Code = VC.Vehicle_Class_Code
--	AND	RESCH.Rate_ID *= VR.Rate_ID
--	AND	LT.Category = 'Reservation Status'
--	AND	RESCH.Status = LT.Code

order by Changed_On
GO
