USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Con_18_IB_Wizard_RAs]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[RP_SP_Con_18_IB_Wizard_RAs]  --  '2008-01-01', '2015-02-28'     
	@StartingTrxDate Varchar(24),
	@EndingTrxDate Varchar(24)

As

Declare @dStartingTrxDate Datetime
Declare @dEndingTrxDate Datetime
Select @dStartingTrxDate=Convert(Datetime, NULLIF(@StartingTrxDate,''))
Select @dEndingTrxDate=Convert(Datetime, NULLIF(@EndingTrxDate,''))

SELECT WRA.Contract_Number, WRA.Wizard_RA_Number, PULoc.Location Pickup_Location, CON.Pick_Up_On, CON.Drop_Off_On, BU.Transaction_Date, BU.Transaction_Description, 
               DOLoc.Location AS DropOff_Location, OWC.Contact_Email_Address, OWC.Contact_Email_CC

FROM  dbo.Contract AS CON INNER JOIN
               dbo.Wizard_RA_Numbers AS WRA ON CON.Contract_Number = WRA.Contract_Number 
               INNER JOIN   dbo.Business_Transaction AS BU ON CON.Contract_Number = BU.Contract_Number 
               INNER JOIN   dbo.Location AS PULoc ON CON.Pick_Up_Location_ID = PULoc.Location_ID 
               INNER JOIN   dbo.Location AS DOLoc ON CON.Drop_Off_Location_ID = DOLoc.Location_ID
               INNER JOIN   dbo.Owning_Company AS OWC ON DOLoc.Owning_Company_ID = OWC.Owning_Company_ID
               where BU.Transaction_Date>=@dStartingTrxDate and BU.Transaction_Date<@dEndingTrxDate
               And BU.Transaction_Description<>'Open'
               Order by BU.Transaction_Description,WRA.Contract_Number 
 
GO
