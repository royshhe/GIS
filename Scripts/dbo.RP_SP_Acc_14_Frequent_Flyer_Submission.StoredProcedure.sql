USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Acc_14_Frequent_Flyer_Submission]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO













/*----------------------------------------------------------------------
PROCEDURE NAME: RP_SP_Acc_14_Frequent_Flyer_Submission
PURPOSE: Select all the information needed for Frequent Flyer Submission Report.
	
AUTHOR:	Vivian Leung
DATE CREATED: 2004/02/09
USED BY: Frequent Flyer Submission Report.
MOD HISTORY:
Name 		Date		Comments
------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[RP_SP_Acc_14_Frequent_Flyer_Submission]
(
	@paramStartBusDate varchar(20) = '23 Apr 2003',
	@paramEndBusDate varchar(20) = '23 Apr 2003',
	@paramPickUpLocationID varchar(20) = '*',
	@TypeList varchar(100)
)
AS
-- convert strings to datetime
DECLARE 	@startBusDate datetime,
		@endBusDate datetime,
		@SQLString nvarchar(1000)

--SELECT	@startBusDate	= CONVERT(datetime, '00:00:00 ' + @paramStartBusDate),
		--@endBusDate	= CONVERT(datetime, '23:59:59 ' + @paramEndBusDate)	

-- fix upgrading problem (SQL7->SQL2000)

DECLARE 	@tmpLocID varchar(20)

if @paramPickUpLocationID = '*'
	BEGIN
		SELECT @tmpLocID='0'
        	END
else
	BEGIN
		SELECT @tmpLocID = @paramPickUpLocationID
	END 


-- end of fixing the problem


select @SQLString=
        N'  SELECT distinct [Transaction Code], [RA Prefix], [RA Number], Location, [DBR Code], [Last Name], [First Init], [C/I Rate Code],'
	+ ' Vehicle_Class_Code, [BCD Number],' 
	+ ' substring(CONVERT(char(12), [Check In Date], 1),1,2)+substring(CONVERT(char(12),[Check In Date], 1),4,2)+substring(CONVERT(char(12), [Check In Date], 1),7,2) as  [Check In Date] , '
	+ ' substring(CONVERT(char(12), [Check Out Date], 1),1,2)+substring(CONVERT(char(12),[Check Out Date], 1),4,2)+substring(CONVERT(char(12), [Check Out Date], 1),7,2)as [Check Out Date], '
	+ '[FTP Code],UPPER([Frequent Flyer Number]),Length, [Gross T&M],[Net T&M], Coupon_Code ' 
	+ 'from RP_Acc_14_Frequent_Flyer_Submission_Main'
	+ ' Where rbr_Date between convert(datetime, ''00:00:00 '' + ''' + @paramStartBusDate +''')'
	+ ' And convert(datetime, ''23:59:59 '' + ''' + @paramEndBusDate + ''')'
	+ '  And     Frequent_Flyer_Plan_ID IN ('+@TypeList+')'
	+ ' And (''' + @paramPickUpLocationID + ''' = ''*'' OR Pick_Up_Location_ID = CONVERT(INT, '+@tmpLocID +'))'
	+ ' ORDER BY [FTP Code]'


--SELECT substring(CONVERT(char(12), [Check In Date], 1),1,2)+substring(CONVERT(char(12),[Check In Date], 1),4,2)+substring(CONVERT(char(12), [Check In Date], 1),7,2)

	--print @SQLString

       exec (@SQLString)


GO
