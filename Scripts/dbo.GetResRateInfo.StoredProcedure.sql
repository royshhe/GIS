USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetResRateInfo]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetResRateInfo    Script Date: 2/18/99 12:12:04 PM ******/
/****** Object:  Stored Procedure dbo.GetResRateInfo    Script Date: 2/16/99 2:05:42 PM ******/
CREATE PROCEDURE [dbo].[GetResRateInfo]
	@ConfirmNum Varchar(10)
AS
	/* 10/13/99 - do type conversion and nullif outside of SQL statements */
DECLARE	@iConfirmNum Int

	SELECT @iConfirmNum = Convert(Int, NULLIF(@ConfirmNum,''))

	SELECT	Rate_ID,
		Rate_Level,
		Date_Rate_Assigned,
		BCD_Rate_Org_Id,
		Referring_Org_Id,
		Source_Code,
		Quoted_Rate_Id
	FROM	Reservation
	WHERE	Confirmation_Number = @iConfirmNum
	RETURN @@ROWCOUNT













GO
