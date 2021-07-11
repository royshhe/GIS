USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetSystemSettingValuesBySettingID]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*PURPOSE: 	To retrieve setting values
MOD HISTORY:
Name    Date        Comments
*/
create PROCEDURE [dbo].[GetSystemSettingValuesBySettingID]
(
	@SettingID varchar(10)
)
AS
	SELECT    dbo.SystemSettingValues.ValueName, dbo.SystemSettingValues.SettingValue, dbo.SystemSettingValues.description
	FROM    dbo.SystemSetting INNER JOIN
	dbo.SystemSettingValues ON dbo.SystemSetting.SettingID = dbo.SystemSettingValues.SettingID
	WHERE (dbo.SystemSetting.SettingID = @SettingID)

  RETURN 1
GO
