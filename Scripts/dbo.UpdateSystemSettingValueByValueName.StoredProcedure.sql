USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateSystemSettingValueByValueName]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*PURPOSE: 	To retrieve setting values
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[UpdateSystemSettingValueByValueName] 
(
	@SettingName varchar(50),	
	@ValueName varchar(50),
	@NewSettingValue varchar(50)
)
AS
	update dbo.SystemSettingValues
	set dbo.SystemSettingValues.SettingValue=@NewSettingValue
	FROM    dbo.SystemSetting INNER JOIN
	dbo.SystemSettingValues ON dbo.SystemSetting.SettingID = dbo.SystemSettingValues.SettingID
	WHERE (dbo.SystemSetting.SettingName = @SettingName) and (dbo.SystemSettingValues.ValueName=@ValueName)

  RETURN 1

GO
