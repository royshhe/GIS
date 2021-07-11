USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[DeleteSystemSetting]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create PROCEDURE [dbo].[DeleteSystemSetting]
	@SettingID Varchar(10)
AS
     DELETE FROM [SystemSetting]
      WHERE SettingID = @SettingID

	
	
RETURN 1
GO
