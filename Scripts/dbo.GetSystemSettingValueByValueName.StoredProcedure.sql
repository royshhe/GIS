USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetSystemSettingValueByValueName]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[GetSystemSettingValueByValueName]
(
	@SettingName varchar(50),	
	@ValueName varchar(50)
)
AS
	SELECT    dbo.SystemSettingValues.SettingValue
	FROM    dbo.SystemSetting INNER JOIN
	dbo.SystemSettingValues ON dbo.SystemSetting.SettingID = dbo.SystemSettingValues.SettingID
	WHERE (dbo.SystemSetting.SettingName = @SettingName) and (dbo.SystemSettingValues.ValueName=@ValueName)

  RETURN 1

GO
