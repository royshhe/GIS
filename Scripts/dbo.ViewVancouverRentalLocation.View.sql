USE [GISData]
GO
/****** Object:  View [dbo].[ViewVancouverRentalLocation]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ViewVancouverRentalLocation]
AS
SELECT     Location_ID, Location, Owning_Company_ID, Hub_ID, GIS_Member, Rental_Location
FROM         dbo.Location 
            inner join Lookup_Table on location.Owning_Company_ID=Lookup_Table.Code
WHERE     (Hub_ID = 1) AND (Rental_Location = 1) --AND (Owning_Company_ID = 7425) 
		AND (Delete_Flag = 0) and (Lookup_Table.Category = 'BudgetBC Company')
GO
