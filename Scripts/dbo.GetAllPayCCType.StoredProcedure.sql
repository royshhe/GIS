USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetAllPayCCType]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.GetAllPayCCType    Script Date: 2/18/99 12:11:44 PM ******/
/****** Object:  Stored Procedure dbo.GetAllPayCCType    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.GetAllPayCCType    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.GetAllPayCCType    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: 	To retrieve a list of credit card types.
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetAllPayCCType]
AS
SELECT
	Credit_Card_Type,
	Credit_Card_Type_ID,
	Electronic_Authorization,
	Mod_10_Check,
	isnull(Mask_Required,'1') Mask_Required
FROM
	Credit_Card_Type
where DeleteFlag<>1 and Credit_Card_Type <>'Debit Card'
ORDER BY
	Credit_Card_Type
RETURN 1
GO
