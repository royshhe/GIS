USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetSelectedAllowPickLocData]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Procedure [dbo].[GetSelectedAllowPickLocData]
 @currentLocationID VarChar(25)
As
SELECT      Location.Location
FROM        Location 
where 	
      	 Location.Location_ID  in
      	(select AllowedPickUPLocationID FROM AllowedPickupLocation where LocationID= CONVERT(SmallInt,  @currentLocationID))
	And  Location.Delete_Flag = 0
	And Location.Rental_Location = 1
Order by  Location 
RETURN 1


GO
