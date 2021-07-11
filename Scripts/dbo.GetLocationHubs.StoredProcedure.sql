USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetLocationHubs]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [dbo].[GetLocationHubs] --'British Columbia' --1 --'Down* airport office'
	@HubProvince varchar(50)='*'	
AS
	

SELECT DISTINCT dbo.Lookup_Table.code, dbo.Lookup_Table.[Value]
FROM         dbo.Location INNER JOIN
                      dbo.Lookup_Table ON dbo.Location.Hub_ID = dbo.Lookup_Table.Code
WHERE     (dbo.Lookup_Table.Category = 'hub') AND (dbo.Location.Delete_Flag = 0) AND (dbo.Location.Rental_Location = 1) AND 
                      ((dbo.Location.Province = @HubProvince) or (@HubProvince='*'))
GO
