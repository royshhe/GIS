USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetMstroCustByBCN]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetMstroCustByBCN    Script Date: 2/18/99 12:11:46 PM ******/
/****** Object:  Stored Procedure dbo.GetMstroCustByBCN    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetMstroCustByBCN    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetMstroCustByBCN    Script Date: 11/23/98 3:55:33 PM ******/
/*
PROCEDURE NAME: GetMstroCustByBCN
PURPOSE: To retrieve a customer with a given BCN
AUTHOR: Don Kirkby
DATE CREATED: Sep 17, 1998
CALLED BY: MaestroBatch
REQUIRES:
ENSURES: returns the customer's id.
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetMstroCustByBCN]
	@BCN varchar(15)
AS
	SELECT	customer_id
	  FROM	customer
	 WHERE	program_number = @BCN
	RETURN @@ROWCOUNT












GO
