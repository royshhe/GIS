USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetConNonDrivingId]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetConNonDrivingId    Script Date: 2/18/99 12:12:14 PM ******/
/****** Object:  Stored Procedure dbo.GetConNonDrivingId    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.GetConNonDrivingId    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.GetConNonDrivingId    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: 	To retrieve the non driving renter id information for the given contract.
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetConNonDrivingId]
	@ContractNum Varchar(20)
AS
	/* 10/21/99 - do type conversion and nullif outside of SQL statements */

DECLARE	@iCtrctNum Int
	SELECT @iCtrctNum = Convert(Int, NULLIF(@ContractNum,''))

	SELECT	Type, Number, Expiry
	FROM		Non_Driving_Renter_ID
	WHERE	Contract_Number = @iCtrctNum
	RETURN @@ROWCOUNT















GO
