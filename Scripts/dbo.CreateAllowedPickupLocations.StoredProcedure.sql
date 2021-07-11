USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateAllowedPickupLocations]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE [dbo].[CreateAllowedPickupLocations]
@LocID varchar(25),
@Location varchar(25),
@ChangedBy varchar(20)
AS
Declare @thisDate datetime
Declare @ThisLocationID smallint
If @ChangedBy = ''
	Select @ChangedBy = 'No name provided'
Select @thisDate = getDate()

Select @ThisLocationID = (Select Distinct Location_ID
			  From Location
			  Where Location=@Location)
Insert Into AllowedPickupLocation
	(LocationID,AllowedPickUPLocationID,comments)
Values
	(Convert(int,@LocID),Convert(int,@ThisLocationID),'')

--update Location audit info
/*Update
	Location
Set
	Last_Updated_By=@ChangedBy,
	Last_Updated_On=@thisDate
Where
	Location_ID=Convert(int,@LocID)	*/
Return 1
GO
