USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCCIDByCCType]    Script Date: 2021-07-10 1:50:48 PM ******/
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
create PROCEDURE [dbo].[GetCCIDByCCType]
	@CCType varchar(20)
AS


	SELECT	Credit_Card_Type_ID
	  FROM	Credit_Card_type
	 WHERE	Credit_Card_type=@CCType
	RETURN @@ROWCOUNT
GO
