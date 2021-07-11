USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[ValidateSerialNumber]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.ValidateSerialNumber    Script Date: 2/18/99 12:12:11 PM ******/
/****** Object:  Stored Procedure dbo.ValidateSerialNumber    Script Date: 2/16/99 2:05:44 PM ******/
/****** Object:  Stored Procedure dbo.ValidateSerialNumber    Script Date: 1/11/99 1:03:18 PM ******/
/****** Object:  Stored Procedure dbo.ValidateSerialNumber    Script Date: 11/23/98 3:55:35 PM ******/
/*
PURPOSE: To validate if the given serial number has been assigned to a unit number, and if not, return 0 and non-zero otherwise.
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[ValidateSerialNumber]
@SerialNumber varchar(30)
AS
Declare @ret int
	
Select @ret = 	(SELECT
			Top 1 Unit_Number
		FROM
			Vehicle
		WHERE
			Serial_Number=@SerialNumber
			And Deleted=0
		 Order by Unit_Number DESC

		)
               
If @ret = (null)
	Return 0
Return @ret
GO
