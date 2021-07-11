USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateResChangeHist]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CreateResChangeHist    Script Date: 2/18/99 12:12:06 PM ******/
/****** Object:  Stored Procedure dbo.CreateResChangeHist    Script Date: 2/16/99 2:05:39 PM ******/
/*
PROCEDURE NAME: CreateResChangeHist
PURPOSE: To create a history record for a reservation

AUTHOR: Cindy Yee
DATE CREATED: ?
CALLED BY: Reservation
MOD HISTORY:
Name    Date        	Comments
Don K	Feb 17 1999	Use GETDATE() instead of @ChangedOn because rapid changes
			from Maestro can happen within one clock cycle.
*/
CREATE PROCEDURE [dbo].[CreateResChangeHist]
	@ConfirmNum 	Varchar(10),
	@ChangedBy 	Varchar(20),
	@ChangedOn 	Varchar(24),/* No Longer Used */
	@PULocId 	Varchar(5),
	@PUDatetime 	Varchar(24),
	@DOLocId 	Varchar(5),
	@DODatetime 	Varchar(24),
	@VehClassCode 	Varchar(1),
	@LastName 	Varchar(25),
	@FirstName 	Varchar(25),
	@RateId 	Varchar(10),
	@RateDate 	Varchar(24),
	@RateLevel 	Varchar(1),
	@Status 	Varchar(1)
AS
	
	SELECT 	@ConfirmNum  = NULLIF(@ConfirmNum,""),
		@ChangedBy = NULLIF(@ChangedBy,""),
		/*@ChangedOn = NULLIF(@ChangedOn,""), */
		@PULocId = NULLIF(@PULocId,""),
		@PUDatetime = NULLIF(@PUDatetime,""),
		@DOLocId = NULLIF(@DOLocId,""),
		@DODatetime = NULLIF(@DODatetime,""),
		@VehClassCode = NULLIF(@VehClassCode,""),
		@LastName = NULLIF(@LastName,""),
		@FirstName = NULLIF(@FirstName,""),
		@RateId = NULLIF(@RateId,""),
		@RateDate = NULLIF(@RateDate,""),
		@RateLevel = NULLIF(@RateLevel,""),
		@Status = NULLIF(@Status,"")
	INSERT INTO Reservation_Change_History
		(Confirmation_Number,
		 Changed_By, Changed_On,
		 Pick_Up_Location_ID,
		 Pick_Up_On,
		 Drop_Off_Location_ID,
		 Drop_Off_On,
		 Vehicle_Class_Code, Last_Name, First_Name,
		 Rate_ID, Date_Rate_Assigned,
		 Rate_Level,
		 Status )
	VALUES	(Convert(Int,@ConfirmNum),
		 @ChangedBy, GETDATE(),
		 Convert(SmallInt, @PULocId),
		 Convert(Datetime, @PUDatetime),
		 Convert(SmallInt, @DOLocId),
		 Convert(Datetime, @DODatetime),
		 @VehClassCode, @LastName, @FirstName,
		 Convert(Int, @RateId), Convert(Datetime, @RateDate),
		 @RateLevel,
		 @Status )
	RETURN @@ROWCOUNT










GO
