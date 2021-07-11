USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[SecGetMenuItems]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



CREATE PROCEDURE [dbo].[SecGetMenuItems]
	@moduleName varchar(100) ='',
	@UserHash   varchar(100) ='' 
 AS

SELECT   distinct  dbo.GISScreenIDs.screen_id AS MenuID, dbo.GISScreenIDs.MenuSubItem AS MenuName, dbo.GISScreenIDs.screen_id AS ScreenId, 
                      dbo.GISScreenIDs.MenuItem AS ParentMenu
FROM         dbo.GISUsers INNER JOIN
                      dbo.GISUserCache ON dbo.GISUsers.user_id = dbo.GISUserCache.user_id INNER JOIN
                      dbo.GISUserGroup ON dbo.GISUsers.user_id = dbo.GISUserGroup.user_id INNER JOIN
                      dbo.GISUserGroupPermissions ON dbo.GISUserGroup.group_name = dbo.GISUserGroupPermissions.group_name INNER JOIN
                      dbo.GISScreenIDs ON dbo.GISUserGroupPermissions.screen_number = dbo.GISScreenIDs.screen_number
WHERE     (dbo.GISUserCache.user_hash = @UserHash) and  (screen_cat =@moduleName) and (dbo.GISScreenIDs.MenuSubItem is not null)
Order by dbo.GISScreenIDs.screen_id
GO
