USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetBroadCastingMsgByLocName]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




/****** Object:  Stored Procedure dbo.GetLocIdByName    Script Date: 2/18/99 12:11:54 PM ******/
/****** Object:  Stored Procedure dbo.GetLocIdByName    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetLocIdByName    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetLocIdByName    Script Date: 11/23/98 3:55:33 PM ******/
CREATE PROCEDURE [dbo].[GetBroadCastingMsgByLocName]
	@LocName Varchar(25)
AS

	SELECT 	BroadcastMssg
	FROM	Location
	WHERE	Location = @LocName
	RETURN @@ROWCOUNT
















GO
