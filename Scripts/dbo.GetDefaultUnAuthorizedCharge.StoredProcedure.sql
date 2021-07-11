USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetDefaultUnAuthorizedCharge]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetDefaultUnAuthorizedCharge    Script Date: 2/18/99 12:11:53 PM ******/
/****** Object:  Stored Procedure dbo.GetDefaultUnAuthorizedCharge    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetDefaultUnAuthorizedCharge    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetDefaultUnAuthorizedCharge    Script Date: 11/23/98 3:55:33 PM ******/
/*  PURPOSE:		To retrieve the Default_Unauthorized_Charge for the given location id.
     MOD HISTORY:
     Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetDefaultUnAuthorizedCharge]
	@LocID	VarChar(10)
AS
	Set Rowcount 2000
	SELECT	Default_Unauthorized_Charge
	FROM	Location
	WHERE	Location_ID = CONVERT(SmallInt, @LocID)
RETURN 1













GO
