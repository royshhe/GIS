USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCustPrefs]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetCustPrefs    Script Date: 2/18/99 12:11:45 PM ******/
/****** Object:  Stored Procedure dbo.GetCustPrefs    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetCustPrefs    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetCustPrefs    Script Date: 11/23/98 3:55:33 PM ******/
/* Nov 01 - Moved data conversion code with NULLIF out of the where clause */
/*  PURPOSE:		To retrieve the customer's preference for the given customer id.
     MOD HISTORY:
     Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetCustPrefs]
	@CustId Varchar(10)
AS
	DECLARE	@nCustId Integer
	SELECT	@nCustId = Convert(Int, NULLIF(@CustId,""))

	-- Get customer preferences
	SELECT 	Convert(Char(1), Add_LDW),
		Convert(Char(1), Add_PAI),
		Convert(Char(1), Add_PEC)
	FROM	Customer
	WHERE	Customer_Id = @nCustId
	
	RETURN @@ROWCOUNT














GO
