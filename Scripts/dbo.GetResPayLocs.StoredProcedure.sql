USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetResPayLocs]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO







CREATE PROCEDURE [dbo].[GetResPayLocs]
	@ConfirmNum	VarChar(10)
AS
DECLARE	@iConfirmNum Int

	SELECT	@iConfirmNum = Convert(Int, NULLIF(@ConfirmNum,''))

	/* 8/12/99 - return all locations involved in payments
			for a reservation */

	SELECT	L.Location, RDP.Collected_At_Location_Id
	FROM	Location L,
		Reservation_Dep_Payment RDP
	WHERE	RDP.Confirmation_Number = @iConfirmNum
	AND	RDP.Collected_At_Location_Id = L.Location_Id
	ORDER BY 1
	
	RETURN @@ROWCOUNT









GO
