USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[SecGetMainMenuItems]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE [dbo].[SecGetMainMenuItems] 
	@moduleName varchar(100) ='' 
 AS

SELECT DISTINCT MenuItem AS MenuID, MenuItem AS MenuName, '' AS ScreenId, '' AS ParentMenu
FROM         GISScreenIDs
WHERE     (screen_cat =@moduleName)

GO
