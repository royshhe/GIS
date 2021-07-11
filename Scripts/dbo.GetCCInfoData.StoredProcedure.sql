USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCCInfoData]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetCCInfoData    Script Date: 2/18/99 12:11:44 PM ******/
/****** Object:  Stored Procedure dbo.GetCCInfoData    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.GetCCInfoData    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.GetCCInfoData    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: 	To retrieve credit card info for the given credit card type.
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetCCInfoData]
@CCType Varchar(30)
AS
SELECT
	Floor_Limit, Authorization_Phone_Number
FROM
	Credit_Card_Type
WHERE
	Credit_Card_Type=@CCType
Return 1













GO
