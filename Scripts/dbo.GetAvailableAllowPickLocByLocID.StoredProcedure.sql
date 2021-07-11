USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetAvailableAllowPickLocByLocID]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Create By Roy He
*/

Create Procedure [dbo].[GetAvailableAllowPickLocByLocID]
 @currentLocationID VarChar(25)
As
SELECT      Location.Location
FROM        Location 
where 	Location.Owning_Company_ID In 
	(Select	Convert(smallint,Code)	From Lookup_Table Where Category = 'BudgetBC Company')
      	And  Location.Location_ID not in
      	(select AllowedPickUPLocationID FROM AllowedPickupLocation where LocationID= CONVERT(SmallInt,  @currentLocationID))
	And  Location.Delete_Flag = 0
	And Location.Rental_Location = 1
Order by  Location 
RETURN 1

GO
