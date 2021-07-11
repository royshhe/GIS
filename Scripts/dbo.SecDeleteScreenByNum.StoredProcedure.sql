USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[SecDeleteScreenByNum]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO




-------------------------------------------------------------------------------------------------------------------
----  Programmer:  Sharon Li
----  Date: 	 Jul 13, 2005
----  Details:	 Delete GIS Screen by Screen Number
-------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[SecDeleteScreenByNum]
	@screen_num varchar(255) 
as

	SET XACT_ABORT on
	SET NOCOUNT ON

	delete from GISScreenIDs 
	where screen_number = @screen_num
	
	delete from gisScreenFieldPermissions 
	where screen_number = @screen_num

	SET NOCOUNT Off
	SET XACT_ABORT off







GO
