USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetRateLocationSetData]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetRateLocationSetData    Script Date: 2/18/99 12:11:47 PM ******/
/****** Object:  Stored Procedure dbo.GetRateLocationSetData    Script Date: 2/16/99 2:05:42 PM ******/
CREATE PROCEDURE [dbo].[GetRateLocationSetData]
@RateID varchar(20),
@RateLocationSetID varchar(20)
AS
Set Rowcount 1
Select
	Rate_Location_Set_ID,
	Convert(char(1),Allow_All_Auth_Drop_Off_Locs),
	(Case
		When Km_Cap IS NULL AND Override_Km_Cap_Flag = 1 Then
				'Unlimited'
			Else
				Convert(varchar, Km_Cap)
			End),
	Per_Km_Charge,
	Flat_Surcharge,
	Daily_Surcharge
From
	Rate_Location_Set
Where
	Rate_ID=Convert(int,@RateID)
	And Rate_Location_Set_ID=Convert(int,@RateLocationSetID)
	And Termination_Date='Dec 31 2078 11:59PM'
Order By
	Rate_Location_Set_ID
Return 1












GO
