USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetAllAlternatePayMethods]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetAllAlternatePayMethods    Script Date: 2/18/99 12:11:43 PM ******/
/****** Object:  Stored Procedure dbo.GetAllAlternatePayMethods    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.GetAllAlternatePayMethods    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.GetAllAlternatePayMethods    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: 	To retrieve a list of alternate billing methods.
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetAllAlternatePayMethods]
AS
SELECT
	Billing_Method
FROM
	Billing_Method
WHERE
	Type = 'a'
RETURN 1













GO
