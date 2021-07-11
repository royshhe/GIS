USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetVehClassCode]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetVehClassCode    Script Date: 2/18/99 12:12:04 PM ******/
/****** Object:  Stored Procedure dbo.GetVehClassCode    Script Date: 2/16/99 2:05:43 PM ******/
CREATE PROCEDURE [dbo].[GetVehClassCode]
	@ConfirmNum Varchar(10)
AS
SELECT
	Vehicle_Class_Code
FROM
	Reservation
WHERE
	Confirmation_Number = Convert(int, @ConfirmNum)
RETURN @@ROWCOUNT












GO
