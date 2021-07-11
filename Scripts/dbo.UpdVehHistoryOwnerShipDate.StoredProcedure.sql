USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdVehHistoryOwnerShipDate]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO




/****** Object:  Stored Procedure dbo.UpdVehHistoryOwnerShipDate    Script Date: 2/18/99 12:12:18 PM ******/
/****** Object:  Stored Procedure dbo.UpdVehHistoryOwnerShipDate    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.UpdVehHistoryOwnerShipDate    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.UpdVehHistoryOwnerShipDate    Script Date: 11/23/98 3:55:34 PM ******/
/*
PURPOSE: To update a record in Vehicle_History table .
MOD HISTORY:
Name    	Date        	Comments
Vivian Leung	13 Mar 2003	fixes for updating foreign vehicles which do not have ownership dates
*/
/*Oct 15 1999 : Moved NULLIF out of the Where clause */

CREATE PROCEDURE [dbo].[UpdVehHistoryOwnerShipDate]
	@UnitNumber		VarChar(10),
	@OldEffectiveDate	VarChar(24),
	@EffectiveDate		VarChar(24),
	@CategoryVehicleStatus	VarChar(20)
AS
	/* 27/05/99 - np modified - update vehicle status effective on when update ownership date and and current vehicle status is owned */

	/* fixes for updating foreign vehicles which do not have ownership dates*/
	if @OldEffectiveDate = '__ ___ ____ __:__' 
		select @OldEffectiveDate = ''

	if @EffectiveDate  = '__ ___ ____ __:__' 
		select @EffectiveDate = ''
	
	Declare @nUnitNumber Int
	Declare @dOldEffectiveDate DateTime

	Select @nUnitNumber = CONVERT(Int, NULLIF(@UnitNumber, ''))
	Select @dOldEffectiveDate = CONVERT(DateTime, NULLIF(@OldEffectiveDate, ''))
	
	

	UPDATE	
		Vehicle_History
	SET	
		Effective_On = CONVERT(DateTime, @EffectiveDate)
	WHERE	
		Unit_Number	= @nUnitNumber
	AND	Effective_On	= @dOldEffectiveDate
	AND	Vehicle_Status	= (	SELECT	Code
					FROM	Lookup_Table
					WHERE	Category	= @CategoryVehicleStatus
					AND	Value		= 'Owned'
				  )

	UPDATE	
		Vehicle
	SET	
		Vehicle_Status_Effective_On = CONVERT(DateTime, @EffectiveDate)
	WHERE	
		Unit_Number	=  @nUnitNumber
	AND	Current_Vehicle_Status	=	(	SELECT	Code
							FROM	Lookup_Table
							WHERE	Category	= @CategoryVehicleStatus
							AND	Value		= 'Owned'
				 		)

Return 1
GO
