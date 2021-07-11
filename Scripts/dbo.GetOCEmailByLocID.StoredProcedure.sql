USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetOCEmailByLocID]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create Procedure [dbo].[GetOCEmailByLocID] --'20'
	@LocID varchar(100)	
As 


DECLARE	@nLocationID SmallInt
SELECT	@nLocationID = CONVERT(SmallInt, NULLIF(@LocID, ''))

SELECT  distinct   Owning_Company.Contact_Email_Address
FROM         Owning_Company INNER JOIN
                      Location ON Owning_Company.Owning_Company_ID = Location.Owning_Company_ID
Where Location_id=@nLocationID
GO
