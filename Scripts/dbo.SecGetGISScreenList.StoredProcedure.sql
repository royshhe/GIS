USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[SecGetGISScreenList]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







-------------------------------------------------------------------------------------------------------------------
----  Programmer:  Jack Jian
----  Date: 	 Mar 18, 2002
----  Details:	 Get GIS User list
-------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[SecGetGISScreenList]

as

	SET NOCOUNT ON	

	select *
	from gisscreenIDs
	where screen_type >= 0 
	order by screen_number

	SET NOCOUNT Off



GO
