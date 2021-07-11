USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetAllCCType]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.GetAllCCType    Script Date: 2/18/99 12:11:43 PM ******/
/****** Object:  Stored Procedure dbo.GetAllCCType    Script Date: 2/16/99 2:05:40 PM ******/
/*
PURPOSE: 	To retrieve a list of credit card types.
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetAllCCType]
AS
SELECT
	Credit_Card_Type, Credit_Card_Type_ID
FROM
	Credit_Card_Type
where deleteflag <>1 and Credit_Card_Type <>'Debit Card'
ORDER BY
	Credit_Card_Type
RETURN 1
GO
