USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateAMAdjustment]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*
PURPOSE: To insert a record into Air_Miles_Points_Adjustment.
MOD HISTORY:
Name    Date        Comments
Roy He - Feb 05 2008
*/

CREATE PROCEDURE [dbo].[CreateAMAdjustment]
	@ContractNumber varchar(20), 	
	@MissingNumber 	varchar(20), 
	@MssingPoint    varchar(10),
	@ProcessedBy 	varchar(50)
	--@ProcessedOn 	varchar(24), 
	
AS



Declare @thisRBRDate datetime
Declare @lastSeq int, @iCtrctNum Int, @iMissingPoint int
Declare @iMissingNumberCount int


	Select @iCtrctNum = Convert(int, NULLIF(@ContractNumber,'')),
        @MissingNumber=NULLIF(@MissingNumber,''),
	@iMissingPoint=Convert(int, NULLIF(@MssingPoint,''))
		

	-- get the current max sequence number
	Select 	@lastSeq = Max(Sequence)
	From	Air_Miles_Points_Adjustment
	Where	Contract_Number = @iCtrctNum

	If @lastSeq IS NULL
	Begin
		Select @lastSeq = -1
	End

	Select 	@thisRBRDate = Max(RBR_Date)
	From	RBR_Date

	SELECT   @iMissingNumberCount=  COUNT(*) 
	FROM         dbo.Air_Miles_Points_Adjustment
	where  Missing_Number=@MissingNumber and  Contract_Number=@iCtrctNum
	--GROUP BY Missing_Number, Contract_Number


if @iMissingPoint is not Null 
	Insert Into Air_Miles_Points_Adjustment
		(Contract_Number, Sequence,
		Missing_Number, Missing_Points, Processed_On,Processed_By,RBR_Date)
	Values
		(@iCtrctNum, (@lastSeq + 1),
		@MissingNumber, @iMissingPoint,
		getdate(), @ProcessedBy,
		@thisRBRDate)
else
 
      Begin

			if @iMissingNumberCount=0 
				Insert Into Air_Miles_Points_Adjustment
						(Contract_Number, Sequence,
						Missing_Number, Missing_Points, Processed_On,Processed_By,RBR_Date)
					Values
						(@iCtrctNum, (@lastSeq + 1),
						@MissingNumber, @iMissingPoint,
						getdate(), @ProcessedBy,
						@thisRBRDate)

      End


	Return (@lastSeq + 1)

GO
