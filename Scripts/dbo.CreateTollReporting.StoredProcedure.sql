USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateTollReporting]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 

CREATE Procedure [dbo].[CreateTollReporting] 
	
	@ConfirmNum varchar(20)= '',
	@RANumber varchar(10) ='',
	@LastName varchar(50),
	@LicencePlate varchar(20) ='',
	@CrossingDate smalldatetime,
	@CrossingNumber smallint 
 
AS


INSERT INTO Toll_Reporting
		( [Confirmation_Number]
		  ,[Contract_number]
		  ,[Renter_Last_Name]
		  ,[Licence_Plate_Number]
		  ,[Crossing_Date]
		  ,[Number_Of_Crossing]
		  ,[Reporting_Time]
		)
	VALUES
		(
		NULLIF(@ConfirmNum,''),
		CONVERT(Int, NULLIF(@RANumber,'')),
		@LastName,		 
		NULLIF(@LicencePlate,''),
		CONVERT(smalldatetime,@CrossingDate),				
		CONVERT(SmallInt, @CrossingNumber),
		Getdate()
		)
RETURN 1
	
	
  
GO
