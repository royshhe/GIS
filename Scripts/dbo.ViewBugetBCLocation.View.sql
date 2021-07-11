USE [GISData]
GO
/****** Object:  View [dbo].[ViewBugetBCLocation]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE VIEW [dbo].[ViewBugetBCLocation]
AS
SELECT *
FROM Location
WHERE (Owning_Company_ID in (select code from Lookup_Table where Category='BudgetBC Company')) AND delete_Flag <> 1 --AND     Rental_location = 1


GO
