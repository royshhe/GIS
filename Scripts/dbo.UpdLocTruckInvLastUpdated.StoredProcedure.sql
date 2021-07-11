USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdLocTruckInvLastUpdated]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


/*
PURPOSE: To update a record in Location table .
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[UpdLocTruckInvLastUpdated]
	@LocationID			VarChar(10),
	@TruckInvLastUpdatedBy	VarChar(20)
AS
	Declare	@iLocationID SmallInt
	Select		@iLocationID = CONVERT(SmallInt, NULLIF(@LocationID, ''))

	UPDATE	Location

	SET		TruckInv_Last_Updated_By = @TruckInvLastUpdatedBy,
			TruckInv_Last_Updated_On = GetDate()

	WHERE	Location_ID	= @iLocationID
Return 1


GO
