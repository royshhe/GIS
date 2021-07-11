USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[LockQuotedRateCategory]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO




/*
PURPOSE: To lock the Quoted Rate for a confirmation number
AUTHOR: Niem Phan
DATE CREATED: Oct 15 1999
CALLED BY: Maestro
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[LockQuotedRateCategory]
	@ConfirmNum varchar(11)
AS

	DECLARE @nConfirmNum integer
	SELECT @nConfirmNum = CAST(NULLIF(@ConfirmNum, '') AS integer)

	SELECT	COUNT(*)
	  FROM	Reservation AS RES WITH (UPDLOCK)
	JOIN		Quoted_Rate_Category AS QRC WITH(UPDLOCK)
	ON		RES.Quoted_Rate_ID = QRC.Quoted_Rate_ID

	 WHERE	RES.confirmation_number = @nConfirmNum








GO
