USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[DeleteSystemSettingValue]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create PROCEDURE [dbo].[DeleteSystemSettingValue]
	@SettingID Varchar(10),
	@ValueName Varchar(50)
AS
     DELETE FROM [SystemSettingValues]
      WHERE SettingID = @SettingID and ValueName = @ValueName

	
	
RETURN 1
GO
