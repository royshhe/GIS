USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[ExistAMAdjustment]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*
PURPOSE: Check to see if Adjustment Exists
MOD HISTORY:
Name    Date        Comments
Roy He - Feb 05 2008
*/

Create PROCEDURE [dbo].[ExistAMAdjustment]
	@ContractNumber varchar(20), 	
	@MissingNumber 	varchar(20)	
AS

Declare @iCtrctNum Int

Select @iCtrctNum = Convert(int, NULLIF(@ContractNumber,'')),
        @MissingNumber=NULLIF(@MissingNumber,'')

       select count(*) from     
       (
	SELECT     Missing_Number Card_Number
	FROM         dbo.Air_Miles_Points_Adjustment
	where  Missing_Number is not null and  Contract_Number=@iCtrctNum
	--GROUP BY Missing_Number, Contract_Number
        union 
        SELECT     FF_Member_Number Card_Number
	FROM         dbo.Contract
	where  FF_Member_Number is not null and  Contract_Number=@iCtrctNum and Frequent_Flyer_Plan_ID=10
       ) AMRecords
       GROUP BY Card_Number


      RETURN @@ROWCOUNT


GO
