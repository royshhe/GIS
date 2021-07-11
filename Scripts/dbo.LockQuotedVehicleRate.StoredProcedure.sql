USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[LockQuotedVehicleRate]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO




/*
PURPOSE: To lock the Quoted Vehicle Rate for a contract
AUTHOR: Niem Phan
DATE CREATED: Oct 6 1999
CALLED BY: Contract
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[LockQuotedVehicleRate]
	@ConfirmNum varchar(11)
AS

	DECLARE @nConfirmNum integer
	SELECT @nConfirmNum = CAST(NULLIF(@ConfirmNum, '') AS integer)

	SELECT	COUNT(*)
	  FROM	Reservation AS RES WITH (UPDLOCK)
	JOIN		Quoted_Vehicle_Rate AS QVR WITH(UPDLOCK)
	ON		RES.Quoted_Rate_ID = QVR.Quoted_Rate_ID

	 WHERE	RES.confirmation_number = @nConfirmNum






GO
