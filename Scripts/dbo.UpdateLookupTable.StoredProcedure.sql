USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateLookupTable]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.UpdLocHoursOfService    Script Date: 2/18/99 12:12:05 PM ******/
/****** Object:  Stored Procedure dbo.UpdLocHoursOfService    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.UpdLocHoursOfService    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.UpdLocHoursOfService    Script Date: 11/23/98 3:55:34 PM ******/
/*
PURPOSE: To update a record in Hours_Of_Service table .
MOD HISTORY:
Name    Date        Comments
*/
/* Oct 27 - Moved data conversion code out of the where clause */

CREATE PROCEDURE [dbo].[UpdateLookupTable]	
	@Value varchar(255),
	@Alias varchar(255) = '',
	@Category	VarChar(30),
	@Code char(25)
AS
if @Category='Reservation Standard Comment'
	begin
		UPDATE	Reservation_Standard_Comment
		SET	Reservation_Comment	= @Value

		WHERE	Reservation_Comment_ID	= @Code
	end
else
	begin
		UPDATE	Lookup_Table
		SET	Value	= @Value,
			Alias	= @Alias

		WHERE	Category	= @Category
		AND		Code	= @Code
	end
Return 1
GO
