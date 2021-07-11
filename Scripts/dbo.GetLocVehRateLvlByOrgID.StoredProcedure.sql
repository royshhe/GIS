USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetLocVehRateLvlByOrgID]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetLocVehRateLvlByOrgID    Script Date: 2/18/99 12:12:09 PM ******/
/****** Object:  Stored Procedure dbo.GetLocVehRateLvlByOrgID    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetLocVehRateLvlByOrgID    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetLocVehRateLvlByOrgID    Script Date: 11/23/98 3:55:33 PM ******/
CREATE PROCEDURE [dbo].[GetLocVehRateLvlByOrgID]
@OrgId Varchar(10), @PickUpDate varchar(20)
AS
	/* return org corp rates that have not been terminated as of now */
	SELECT	ORG.Rate_ID, LVRL.Rate_Selection_Type
	FROM	Organization_Rate ORG,
		Rate_Level RL,
		Location_Vehicle_Rate_Level LVRL
	WHERE	ORG.Organization_ID  = Convert(int, @OrgId)
	AND	RL.Rate_Level = LVRL.Rate_Level
	AND	ORG.Rate_ID = RL.Rate_ID
	AND	ORG.Rate_ID = LVRL.Rate_ID
	AND	ORG.Valid_From <= Convert(datetime, @PickUpDate)
	AND	ORG.Valid_To >= Convert(datetime, @PickUpDate)
	AND	LVRL.Valid_From <= Convert(datetime, @PickUpDate)
	AND	LVRL.Valid_To >= Convert(datetime, @PickUpDate)
	AND	ORG.Termination_Date = 'Dec 31 2078 11:59PM'
        AND	RL.Termination_Date = 'Dec 31 2078 11:59PM'
 	
	RETURN 1












GO
