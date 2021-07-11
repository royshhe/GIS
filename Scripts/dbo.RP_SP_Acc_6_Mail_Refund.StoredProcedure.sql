USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Acc_6_Mail_Refund]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO










/*
PROCEDURE NAME: RP_SP_Acc_6_Mail_Refund
PURPOSE: Select all the information needed for Mail Refund Report.
	
AUTHOR:	Joseph Tseung
DATE CREATED: 1999/09/17
USED BY: Mail Refund Report
MOD HISTORY:
Name 		Date		Comments
*/

CREATE PROCEDURE [dbo].[RP_SP_Acc_6_Mail_Refund]
(
	@paramStartBusDate varchar(20) = '01 Jan 1999',
	@paramEndBusDate varchar(20) = '31 May 1999',
	@paramLocationID varchar(20) = '*'
)
AS
-- convert strings to datetime
DECLARE 	@startBusDate datetime,
		@endBusDate datetime

SELECT	@startBusDate	= CONVERT(datetime, '00:00:00 ' + @paramStartBusDate),
		@endBusDate	= CONVERT(datetime, '23:59:59 ' + @paramEndBusDate)	

-- fix upgrading problem (SQL7->SQL2000)

DECLARE  @tmpLocID varchar(20)

if @paramLocationID = '*'
	BEGIN
		SELECT @tmpLocID='0'
        END
else
	BEGIN
		SELECT @tmpLocID = @paramLocationID
	END 

-- end of fixing the problem


SELECT 	RBR_Date,
    	Document_Type,
    	Document_Number,
    	Foreign_Contract_Number,
   	Business_Transaction_ID,
    	Collected_At_Location_ID,
	Location_Name,
    	Customer_Name,
	Address,
	Amount

FROM	RP_Acc_6_Mail_Refund_L1_Main with(nolock)

WHERE 	
	(@paramLocationID = "*" OR Collected_At_Location_ID = CONVERT(INT, @tmpLocID))
	AND
	RBR_Date BETWEEN @startBusDate AND @endBusDate

GO
