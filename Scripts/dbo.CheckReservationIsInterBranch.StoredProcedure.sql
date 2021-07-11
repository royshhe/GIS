USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CheckReservationIsInterBranch]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CheckReservationIsInterBranch    Script Date: 2/18/99 12:11:59 PM ******/
/****** Object:  Stored Procedure dbo.CheckReservationIsInterBranch    Script Date: 2/16/99 2:05:39 PM ******/
CREATE PROCEDURE [dbo].[CheckReservationIsInterBranch]
	@ConfirmNum Varchar(10)
AS
	/* 10/08/99 - do type conversion and nullif outside of select */

DECLARE @iConfirmNum Int

	SELECT	@iConfirmNum = Convert(Int, NULLIF(@ConfirmNum,''))

/* Change these rules as per pending business design */
SELECT
	R.Confirmation_Number
FROM
	Reservation R, Location L, Lookup_Table LT
WHERE
	R.Confirmation_Number = @iConfirmNum
	And R.Pick_Up_Location_ID = L.Location_ID
	And LT.Category = 'BudgetBC Company'
	And Convert(int,LT.Code) <> L.Owning_Company_ID
	
	IF @@ROWCOUNT <> 0
		RETURN 1
RETURN 0













GO
