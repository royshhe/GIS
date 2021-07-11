USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[DeleteIncludedSalesAccessory]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.DeleteIncludedSalesAccessory    Script Date: 2/18/99 12:11:51 PM ******/
/****** Object:  Stored Procedure dbo.DeleteIncludedSalesAccessory    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.DeleteIncludedSalesAccessory    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.DeleteIncludedSalesAccessory    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: To logical delete record from Included_Sales_Accessory table by setting the Termination Date
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[DeleteIncludedSalesAccessory]
@RateID varchar(7),@OldID varchar(25),@ChangedBy varchar(20)
AS
Declare @thisDate datetime
If @ChangedBy = ''
	Select @ChangedBy = 'No name provided'
Select @thisDate = getDate()

Update
	Included_Sales_Accessory
Set
	Termination_Date=@thisDate
Where
	Rate_ID=Convert(int,@RateID)
	And Termination_Date='Dec 31 2078 11:59PM'
	And Sales_Accessory_ID=Convert(smallint,@OldID)

--Update vehicle rate audit info
Update
	Vehicle_Rate
Set
	Last_Changed_By=@ChangedBy,
	Last_Changed_On=@thisDate
Where
	Rate_ID=Convert(int,@RateID)
	And Termination_Date='Dec 31 2078 11:59PM'
Return Convert(int,@RateID)













GO
