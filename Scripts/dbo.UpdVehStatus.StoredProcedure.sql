USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdVehStatus]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO














/****** Object:  Stored Procedure dbo.UpdVehStatus    Script Date: 2/18/99 12:12:11 PM ******/
/****** Object:  Stored Procedure dbo.UpdVehStatus    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.UpdVehStatus    Script Date: 1/11/99 1:03:17 PM ******/
/*
PURPOSE: To update a record in Vehicle table .
MOD HISTORY:
Name    Date        Comments
*/
/*Moved NULLIF out of the Where clause */

CREATE PROCEDURE [dbo].[UpdVehStatus]
	@UnitNumber		VarChar(10),
	@OldVehStatus		VarChar(1),
	@NewVehStatus	VarChar(1),
	@NewVehStatusDate	VarChar(24)
AS
	/* 99/05/27 - np modified - create vehicle history record when updating vehicle status */
	Declare @nUnitNumber Int

	Select @nUnitNumber = CONVERT(Int, NULLIF(@UnitNumber, ''))
	Select @OldVehStatus = NULLIF(@OldVehStatus, '')

	if @NewVehStatus = 'f'
	begin

		UPDATE	
			Vehicle
		SET	
			Current_Vehicle_Status		= NULLIF(@NewVehStatus, ''),
			Vehicle_Status_Effective_On	= CONVERT(DateTime, NULLIF(@NewVehStatusDate, ''))
		WHERE	
			Unit_Number			= @nUnitNumber
		AND	Current_Vehicle_Status	= @OldVehStatus

		/* Create vehicle history record */
		INSERT INTO	Vehicle_History
		(	Unit_Number,
			Vehicle_Status,
			Effective_On
		)
		Values
		(	@UnitNumber,
			@NewVehStatus,
			Convert(datetime, @NewVehStatusDate)
		)
	end 
	else --if @NewVehStatus != 'f'
	begin
		UPDATE	
			Vehicle
		SET	
			Current_Vehicle_Status		= NULLIF(@NewVehStatus, ''),
			Vehicle_Status_Effective_On	= CONVERT(DateTime, NULLIF(@NewVehStatusDate, ''))
		WHERE	
			Unit_Number			= @nUnitNumber
		AND	Current_Vehicle_Status	= @OldVehStatus

		/* Create vehicle history record */
		INSERT INTO	Vehicle_History
		(	Unit_Number,
			Vehicle_Status,
			Effective_On
		)
		Values
		(	@UnitNumber,
			@NewVehStatus,
			Convert(datetime, @NewVehStatusDate)
		)
	end 

Return 1

GO
