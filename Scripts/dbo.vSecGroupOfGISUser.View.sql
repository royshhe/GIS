USE [GISData]
GO
/****** Object:  View [dbo].[vSecGroupOfGISUser]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO







--------------------------------------------
-- Programmer:  Jack Jian
-- Date:	           Aug 01, 2001
-- Details:         Get the group list of the user 	
--------------------------------------------

CREATE VIEW [dbo].[vSecGroupOfGISUser]
AS
SELECT u.user_id, ug.group_name, is_NT_account, u.active
FROM gisusers u JOIN
    gisusergroup ug ON u.user_id = ug.user_id




GO
