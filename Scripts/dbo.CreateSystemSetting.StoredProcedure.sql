USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateSystemSetting]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*PURPOSE: 	To retrieve setting values
MOD HISTORY:
Name    Date        Comments
*/
create PROCEDURE [dbo].[CreateSystemSetting]
(
	@SettingName varchar(50), 
	@CreatedBy varchar(50), 
	@CreatedDate varchar(50)

)
AS
	INSERT INTO dbo.SystemSetting ( SettingName, CreatedBy, CreatedDate)
	VALUES (@SettingName, @CreatedBy, @CreatedDate)

  RETURN 1
GO
