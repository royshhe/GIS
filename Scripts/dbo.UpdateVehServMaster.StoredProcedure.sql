USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateVehServMaster]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.UpdateVehServMaster    Script Date: 2/18/99 12:12:11 PM ******/
/****** Object:  Stored Procedure dbo.UpdateVehServMaster    Script Date: 2/16/99 2:05:44 PM ******/
/****** Object:  Stored Procedure dbo.UpdateVehServMaster    Script Date: 1/11/99 1:03:18 PM ******/
/****** Object:  Stored Procedure dbo.UpdateVehServMaster    Script Date: 11/23/98 3:55:35 PM ******/
/*
PURPOSE: To update a record in Vehicle table .
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[UpdateVehServMaster]
	@UnitNum Varchar(10),
	@ServiceDate Varchar(24),
	@CondStatus Varchar(1),
	@CurrKm Varchar(10),
	@SmokingFlag Varchar(1),
	@UserName Varchar(20)
AS
DECLARE @iUnitNum Integer
	SELECT @iUnitNum = Convert(Int, NULLIF(@UnitNum,""))
	UPDATE	Vehicle
	SET	Current_Condition_Status = NULLIF(@CondStatus,""),
		Condition_Status_Effective_On = Convert(Datetime, NULLIF(@ServiceDate,"")),
		Current_Km = Convert(Int, NULLIF(@CurrKm,"")),
		Smoking_Flag = Convert(Bit, @SmokingFlag),
		Last_Update_By = NULLIF(@UserName,""),
		Last_Update_On = GetDate()
	WHERE	Unit_Number = @iUnitNum
	RETURN @iUnitNum
GO
