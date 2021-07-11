USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetNonGISRateByBCDNum]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

/*
PURPOSE: To retrieve the corporate rates (rate id and level) that are currently
	 available for a given BCD organization during PickUpDate
MOD HISTORY:
Name	Date        	Comments
Don K	Apr 4 2000	Do date comparisons to the day
*/
CREATE PROCEDURE [dbo].[GetNonGISRateByBCDNum]
    @BCDNum varchar(10),
    @VehicleClassCode Char(1)
AS

Select Distinct
	   dbo.Quoted_Organization_Rate.Quoted_Rate_ID, dbo.Quoted_Organization_Rate.LDWID
FROM         dbo.Quoted_Organization_Rate INNER JOIN
                      dbo.Organization ON dbo.Quoted_Organization_Rate.BCD_Number = dbo.Organization.BCD_Number LEFT OUTER JOIN
                      dbo.Optional_Extra ON dbo.Quoted_Organization_Rate.LDWID = dbo.Optional_Extra.Optional_Extra_ID AND dbo.Optional_Extra.Delete_Flag = 0
Where
	dbo.Organization.BCD_Number = @BCDNum and Vehicle_Class_Code=@VehicleClassCode and   dbo.Organization.inactive=0 And (Tour_Rate_Account<>1 Or Tour_Rate_Account is null)
	
Return 1

--select * from   dbo.Organization
GO
