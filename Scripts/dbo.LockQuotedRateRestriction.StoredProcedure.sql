USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[LockQuotedRateRestriction]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO




/*
PURPOSE: To lock the Quoted Rate Restriction for a confirmation number
AUTHOR: Niem Phan
DATE CREATED: Oct 15 1999
CALLED BY: Maestro
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[LockQuotedRateRestriction]
	@ConfirmNum varchar(11)
AS

	DECLARE @nConfirmNum integer
	SELECT @nConfirmNum = CAST(NULLIF(@ConfirmNum, '') AS integer)

	SELECT	COUNT(*)
	  FROM	Reservation AS RES WITH (UPDLOCK)
	JOIN		Quoted_Rate_Restriction AS QRR WITH(UPDLOCK)
	ON		RES.Quoted_Rate_ID = QRR.Quoted_Rate_ID

	 WHERE	RES.confirmation_number = @nConfirmNum






GO
