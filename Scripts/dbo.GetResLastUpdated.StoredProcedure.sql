USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetResLastUpdated]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO





CREATE PROCEDURE [dbo].[GetResLastUpdated]
	@ConfirmNum VarChar(10)
AS

/*  PURPOSE:		To retrieve the last cjanged on date for the given confirmation number
     AUTHOR:		Niem Phan
     MOD HISTORY:
     Name    Date        Comments
*/
	DECLARE	@iConfirmNum Int
	SELECT @iConfirmNum = CONVERT(Int, NULLIF(@ConfirmNum, ''))

	SELECT	
			Reservation.Confirmation_Number,
			CONVERT(VarChar, Last_Changed_On, 113) Last_Changed_On,
			dbo.RP__Reservation_Make_Time.ResMadeTime Res_Made_On
	
	FROM		Reservation INNER JOIN
                      dbo.RP__Reservation_Make_Time ON dbo.Reservation.Confirmation_Number = dbo.RP__Reservation_Make_Time.Confirmation_Number

	WHERE	Reservation.Confirmation_Number = @iConfirmNum
	
RETURN @@ROWCOUNT


GO
