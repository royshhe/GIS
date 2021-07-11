USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetAllCreditCardType]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
PURPOSE: 	To retrieve a list of credit card types.
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[GetAllCreditCardType]
AS

SELECT	Credit_Card_Type_ID,
		Credit_Card_Type

FROM		Credit_Card_Type
where Credit_Card_Type <>'Debit Card'

ORDER BY	Credit_Card_Type_ID

RETURN 1
GO
