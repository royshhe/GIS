USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CheckResCustRentable]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CheckResCustRentable    Script Date: 2/18/99 12:11:40 PM ******/
/****** Object:  Stored Procedure dbo.CheckResCustRentable    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CheckResCustRentable    Script Date: 1/11/99 1:03:13 PM ******/
/****** Object:  Stored Procedure dbo.CheckResCustRentable    Script Date: 11/23/98 3:55:31 PM ******/
/*
PURPOSE: To check whether the customer has Do Not Rent flag set.  Return 1 if so.
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[CheckResCustRentable]
	@CustId Varchar(10)
AS
	SELECT	"1"
	FROM	Customer
	WHERE	Customer_ID = Convert(Int, @CustId)
	AND	Do_Not_Rent = 1
	RETURN @@ROWCOUNT













GO
