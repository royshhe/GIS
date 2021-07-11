USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateVehRentalStatus]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*
PURPOSE: To update a vehicle's current status fields (eg. current rental status, 
	 KMs, location, etc). If the condition status has changed, also log
	 a record in the condition_history table for the vehicle.
MOD HISTORY:
Name    Date        	Comments
CPY	Jan 21 2000	Added param @LastUpdateBy to saved when updating Vehicle 
CPY	Feb 4 2000	Modified Select Case when assigning @dRentalStatusDate and
			@dCondStatusDate 
*/

CREATE PROCEDURE [dbo].[UpdateVehRentalStatus]
	@UnitNum 		Varchar(10),
	@CurrRentalStatus 	Varchar(1),
	@CurrDate 		Varchar(24),
	@CurrKM			VarChar(10),
	@DropOffLocID		VarChar(10),
	@CurrConditionStatus 	VarChar(1),
	@LastUpdateBy		Varchar(20)
AS
	/* 8/04/99 - only update condition_history if @CurrConditionStatus is not null */

DECLARE @dCurrDate Datetime,
	@dRentalStatusDate Datetime,
	@dCondStatusDate Datetime,
	@iCurrKM Int,
	@iDropOffLocId SmallInt,
	@iUnitNum Int,
	@sCurrentConditionStatus VarChar(1)

	/* default CurrDate to today if "" */
	SELECT 	@dCurrDate = ISNULL(Convert(Datetime, NULLIF(@CurrDate,"")),
				GetDate()),
		@iUnitNum = Convert(Int, NULLIF(@UnitNum,"")),
		@CurrRentalStatus = NULLIF(@CurrRentalStatus,""),
		@iCurrKM = Convert(Int, NULLIF(@CurrKM,"")),
		@iDropOffLocId = Convert(SmallInt, NULLIF(@DropOffLocId,"")),
		@CurrConditionStatus = NULLIF(@CurrConditionStatus,""), 
		@LastUpdateBy = NULLIF(@LastUpdateBy,'')

	/* only assign rental status date if rental status provided
	 * only assign condition status date if condition status provided */

	/* Feb 4 2000 - instead of CASE @CurrRentalStatus WHEN NULL, 
	 * 		use CASE WHEN @CurrRentalStatus IS NULL */

	SELECT 	@dRentalStatusDate = CASE 
					WHEN @CurrRentalStatus IS NULL THEN NULL
					ELSE @dCurrDate
				     END,
		@dCondStatusDate = CASE 
					WHEN @CurrConditionStatus IS NULL THEN NULL
					ELSE @dCurrDate
				   END
	/*
	If Current Condition Status is changed then create a condition history	
	*/
	SELECT	@sCurrentConditionStatus = V.Current_Condition_Status
	FROM		Vehicle V
	WHERE	V.Unit_Number = @iUnitNum

	If @sCurrentConditionStatus <> @CurrConditionStatus AND
		NULLIF(@CurrConditionStatus,'') IS NOT NULL

		-- Create a record for Condition_History for each condition update
		INSERT INTO	Condition_History
			(	
				Unit_Number,
				Condition_Status,
				Effective_On
			)
		VALUES
			(	
				@iUnitNum,
				@CurrConditionStatus,
				@dCurrDate
			)

	UPDATE	Vehicle
	SET	Current_Rental_Status = ISNULL(@CurrRentalStatus, Current_Rental_Status),
		Rental_Status_Effective_On = ISNULL(@dRentalStatusDate, Rental_Status_Effective_On),
		Current_KM = ISNULL(@iCurrKM, Current_KM),
		Current_Location_ID = ISNULL(@iDropOffLocID, Current_Location_ID),
		Current_Condition_Status = ISNULL(@CurrConditionStatus, Current_Condition_Status),
		Condition_Status_Effective_On = ISNULL(@dCondStatusDate, Condition_Status_Effective_On),
		Last_Update_By = ISNULL(@LastUpdateBy, Last_Update_By), 
		Last_Update_On = GetDate()
	WHERE	Unit_Number = @iUnitNum
RETURN @@ROWCOUNT
GO
