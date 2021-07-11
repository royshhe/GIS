USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetConRenterDL]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetConRenterDL    Script Date: 2/18/99 12:12:14 PM ******/
/****** Object:  Stored Procedure dbo.GetConRenterDL    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.GetConRenterDL    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.GetConRenterDL    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: 	To retrieve the renter's driver licence information for the given contract.
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[GetConRenterDL]
	@ContractNum	Varchar(10)
AS
	/* 10/21/99 - do type conversion and nullif outside of SQL statements */

DECLARE	@iCtrctNum Int
	SELECT @iCtrctNum = Convert(Int, NULLIF(@ContractNum,''))

	SELECT 	Licence_Number,
		Jurisdiction,
		Expiry,
		Class
	FROM	Renter_Driver_Licence
	WHERE	Contract_Number = @iCtrctNum
	RETURN @@ROWCOUNT















GO
