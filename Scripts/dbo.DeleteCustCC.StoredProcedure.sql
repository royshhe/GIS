USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[DeleteCustCC]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.DeleteCustCC    Script Date: 2/18/99 12:11:50 PM ******/
/****** Object:  Stored Procedure dbo.DeleteCustCC    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.DeleteCustCC    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.DeleteCustCC    Script Date: 11/23/98 3:55:32 PM ******/
/*
PROCEDURE NAME: DeleteCustCC
PURPOSE: To delete a credit card
AUTHOR: Cindy Yee
DATE CREATED: ?
CALLED BY: Customer
MOD HISTORY:
Name    Date        Comments
Don K	Oct 30 1998 Changed to use CCKey and no Primary_Card
*/
CREATE PROCEDURE [dbo].[DeleteCustCC]
	@CCKey Varchar(11),
	@CustId Varchar(11),
	@UserName varchar(20)
AS
	/* 10/08/99 - do type conversion and nullif outside of select */

DECLARE @iCustId Int,
	@iCCKey Int

	SELECT	@iCustId = CONVERT(Int, NULLIF(@CustId,'')),
		@iCCKey = CONVERT(int, NULLIF(@CCKey, ''))
/*
Delete From
	Credit_Card
Where
	Credit_Card_Key = CONVERT(int, NULLIF(@CCKey, ''))
*/
/* NP 	Apr. 08 1998 Cleard the customer id from credit card record instead of deleting the credit card record. */
Update	Credit_Card
Set	Customer_ID = NULL
Where	Credit_Card_Key = @iCCKey


/* Update Audit Info */
Update
	Customer
Set
	Last_Changed_By=@UserName,
	Last_Changed_On=getDate()
Where
	Customer_ID = @iCustId
RETURN 1














GO
