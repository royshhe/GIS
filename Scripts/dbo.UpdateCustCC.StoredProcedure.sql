USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateCustCC]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.UpdateCustCC    Script Date: 2/18/99 12:11:57 PM ******/
/****** Object:  Stored Procedure dbo.UpdateCustCC    Script Date: 2/16/99 2:05:44 PM ******/
/****** Object:  Stored Procedure dbo.UpdateCustCC    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.UpdateCustCC    Script Date: 11/23/98 3:55:34 PM ******/
/*
PROCEDURE NAME: UpdateCustCC
PURPOSE: To update a credit card
AUTHOR: Cindy Yee
DATE CREATED: ?
CALLED BY: Customer
REQUIRES:
MOD HISTORY:
Name    Date        	Comments
Don K	Oct 30 1998 	Changed to use CCKey and no Primary_Card
Don K	Nov 4 1998  	Removed Type, Number, First and Last Name from update
Don K	Mar 8 1999	Expanded CCExpiry to 5
Don K	Mar 9 1999	Removed CCExpiry
*/
CREATE PROCEDURE [dbo].[UpdateCustCC]
	@CCKey Varchar(11),
	@CustId Varchar(11),
	@UserName varchar(20)
AS
	/* 4/07/99 - cpy modified - only update audit info if update affected some row
				- if @CustId is null, don't overwrite customer_id with null;
				  just leave it untouched */

Declare @iCustId  Int
Declare @iCCKey Int

	SELECT	@iCustId = Convert(int, NULLIF(@CustId,'')),
		@iCCKey = Convert(Int, NULLIF(@CCKey,''))

	-- if CustId is provided, unlink customer from any CC linked to him
	IF @iCustId IS NOT NULL
		UPDATE	Credit_Card
		   SET	Customer_ID = NULL
		 WHERE	Customer_ID = @iCustId

	-- link this credit card (key) with this customer
	UPDATE	Credit_Card
	SET	Customer_ID = ISNULL(@iCustId, Customer_ID)
	WHERE	Credit_Card_Key = @iCCKey

	/* Update Audit Info */
	IF @@ROWCOUNT > 0
		Update	Customer
		Set	Last_Changed_By=@UserName,
			Last_Changed_On=getDate()
		Where	Customer_ID = @iCustId

	RETURN @iCCKey










GO
