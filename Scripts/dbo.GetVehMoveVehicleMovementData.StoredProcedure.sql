USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetVehMoveVehicleMovementData]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetVehMoveVehicleMovementData    Script Date: 2/18/99 12:12:17 PM ******/
CREATE PROCEDURE [dbo].[GetVehMoveVehicleMovementData]
@UnitNumber varchar(10)
AS
	/* 6/14/99 - changed date formatting to not use date part/name */

Select
	Convert(char(11), VM.Movement_Out, 13),
	Right(VM.Movement_Out,8),
	Convert(char(11), VM.Movement_Out, 13),
	Right(VM.Movement_Out,8),
	VM.Movement_Type, VM.Km_Out,L.Location, VM.Receiving_Location_ID,
	VM.Approver_Name, VM.Driver_Name, Convert(char(1),VM.Billable),
	VM.Remarks_Out,
	Convert(char(11), VM.Movement_In, 13),
	Right(VM.Movement_In,8),
	VM.Km_In,VM.Remarks_In
From
	Vehicle_Movement VM,Location L
Where
	VM.Unit_Number=Convert(int,@UnitNumber)
	And VM.Sending_Location_ID=L.Location_ID
	And NULLIF(VM.Movement_In,'') IS NULL
	
RETURN 1












GO
