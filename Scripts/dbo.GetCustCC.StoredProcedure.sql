USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCustCC]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.GetCustCC    Script Date: 2/18/99 12:11:53 PM ******/
/****** Object:  Stored Procedure dbo.GetCustCC    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetCustCC    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.GetCustCC    Script Date: 11/23/98 3:55:33 PM ******/
/* Nov 01 - Moved data conversion code with NULLIF out of the where clause */
/*  PURPOSE:		To retrieve credit card information for the given customer id
     MOD HISTORY:
     Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetCustCC]
	@CustId Varchar(10)
AS
	DECLARE	@nCustId Integer
	SELECT	@nCustId = Convert(Int, NULLIF(@CustId, ""))

	/* 981103 - cpy - removed Primary Card ind param, added
			  Credit_Card_Key as 1st field returned */
	/* 980924 - cpy - return CC type code, not description */
	-- 990309 - Don K - return Sequence_num
	SELECT 	Credit_Card_Key,
		Credit_Card_Type_ID,
		Credit_Card_Number,
		Expiry,
		Last_Name,
		First_Name,
		Sequence_Num,
		Short_Token
	FROM   	Credit_Card
	WHERE  	Customer_ID = @nCustId
GO
