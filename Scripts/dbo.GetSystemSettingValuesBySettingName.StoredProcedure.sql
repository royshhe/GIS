USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetSystemSettingValuesBySettingName]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*PURPOSE: 	To retrieve setting values
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetSystemSettingValuesBySettingName]
(
	@SettingName varchar(50)
)
AS
	SELECT    dbo.SystemSettingValues.ValueName, dbo.SystemSettingValues.SettingValue
	FROM    dbo.SystemSetting INNER JOIN
	dbo.SystemSettingValues ON dbo.SystemSetting.SettingID = dbo.SystemSettingValues.SettingID
	WHERE (dbo.SystemSetting.SettingName = @SettingName)

  RETURN 1

GO
