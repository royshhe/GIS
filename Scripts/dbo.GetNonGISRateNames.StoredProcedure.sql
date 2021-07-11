USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetNonGISRateNames]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO











/*
PURPOSE: retrieve details of Non GIS rates
MOD HISTORY:
Name	Date	    Comment
Don K	Aug 10 1999 Added Corporate responsibility
Don K	Aug 16 1999 Added RateStruct & CalendarDayRate
*/
CREATE PROCEDURE [dbo].[GetNonGISRateNames]
@QuotedRateId Varchar(10)
AS
	/* 3/08/99 - cpy modified - added extra field for quoted rate inclusion */
	/* 3/16/99 - cpy modified - added extra filler fields and rate_source at the
				end so that the # fields matches GetResRateNames */

SET ROWCOUNT 1
SELECT
	QVR.Quoted_Rate_Id,
	QVR.Rate_Name,
	QVR.Rate_Purpose_ID,
	Convert(char(1),QVR.Tax_Included),
	Convert(char(1),QVR.GST_Included),

	Convert(char(1),QVR.PST_Included),
	Convert(char(1),QVR.PVRT_Included),
	Convert(char(1),QVR.Location_Fee_Included),
	Convert(char(1),QVR.License_Fee_Included),
	Convert(char(1),QVR.ERF_Included),
	Convert(char(1),QVR.FPO_Purchased),
	QVR.Per_Km_Charge,

	QVR.Authorized_DO_Charge,
	Convert(char(1), QVR.Frequent_Flyer_Plans_Honoured),
	QVR.Other_Inclusions,	-- quoted rate inclusion,
	QVR.Corporate_Responsibility,
	'', 			-- used for original Drop_Off_Charge in save string

	QVR.Rate_Source,
	QVR.Rate_Structure,
	CONVERT(tinyint, QVR.Calendar_Day_Rate),
	'0' --CRC_Included
FROM
	Quoted_Vehicle_Rate QVR
WHERE
	QVR.Quoted_Rate_Id = Convert(Int, @QuotedRateId)
RETURN @@ROWCOUNT


























GO
