USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetPermission]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetPermission    Script Date: 2/18/99 12:11:46 PM ******/
/****** Object:  Stored Procedure dbo.GetPermission    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetPermission    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetPermission    Script Date: 11/23/98 3:55:33 PM ******/
CREATE PROCEDURE [dbo].[GetPermission]
@Groupid Varchar(12),
@Screenid Varchar(25)
AS
Declare @rc varchar(5)
Select
	*
From
	Access_Permission
where
	User_Group_id = @Groupid
	And Screen_id = @Screenid
Return 1












GO
