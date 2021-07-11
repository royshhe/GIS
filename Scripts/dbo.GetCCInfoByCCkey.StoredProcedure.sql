USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCCInfoByCCkey]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*
PROCEDURE NAME: GetCCKey
PURPOSE: To retrieve a credit card based on the identifying fields
AUTHOR: Roy He
DATE CREATED: Mar 12, 2004
CALLED BY: Customer
*/
create PROCEDURE [dbo].[GetCCInfoByCCkey]
	@CCKey varchar(11)
AS


Declare @thisCreditCardKey int
Select @thisCreditCardKey = CONVERT(int, NULLIF(@CCKey, ''))
	SELECT	Credit_Card_Type_ID, Credit_Card_Number,Last_Name,First_Name,Expiry,Customer_ID,Sequence_Num
	  FROM	Credit_Card
	 WHERE	Credit_Card_Key=@thisCreditCardKey
	RETURN @@ROWCOUNT
GO
