USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetGISUserTransactionFee]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[GetGISUserTransactionFee]-- '2012-10-01', '2012-10-01'
	@paraStartTransDate varchar(20),
	@paraEndTransDate varchar(20)
AS

DECLARE @startTransDate datetime
DECLARE @endTransDate datetime

SELECT  @startTransDate = convert(datetime, '00:00:00 ' + @paraStartTransDate)
SELECT  @endTransDate = convert(datetime, '00:00:00 ' + @paraEndTransDate )+1

SELECT     B.Transaction_Type, B.Transaction_Description, COUNT(*) AS NumberOfTrans,
	   A.Transaction_Rate AS Rate,COUNT(*)*A.Transaction_Rate AS Amount
FROM         Business_Transaction B,
	     UserFee_TransactionRate A
WHERE     (B.Transaction_Date >= @startTransDate ) AND (B.Transaction_Date < @endTransDate) 
	  AND (A.Transaction_Description = B.Transaction_Description) 
	  AND (A.Transaction_Type = B.Transaction_Type)
		and (B.confirmation_number is null or B.confirmation_number  not in 
				(select confirmation_number
						from reservation
						where right(rtrim(foreign_confirm_number),3)='VAN' and 
							update_ctrl>= @startTransDate and update_ctrl < @endTransDate))
GROUP BY B.Transaction_Description, B.Transaction_Type, A.Transaction_Rate

union

SELECT     'Online Truck Res' as Transaction_Type, B.Transaction_Description, COUNT(*) AS NumberOfTrans,
	   A.Transaction_Web_Rate AS Rate,COUNT(*)*A.Transaction_Web_Rate AS Amount
--select *
FROM         Business_Transaction B,
	     UserFee_TransactionRate A
WHERE     (B.Transaction_Date >= @startTransDate ) AND (B.Transaction_Date < @endTransDate) 
	  AND (A.Transaction_Description = B.Transaction_Description) 
	  AND (A.Transaction_Type = B.Transaction_Type)
		and (B.confirmation_number  in 
				(select confirmation_number
						from reservation
						where right(rtrim(foreign_confirm_number),3)='VAN' and 
							update_ctrl>= @startTransDate and update_ctrl < @endTransDate))
GROUP BY B.Transaction_Description, B.Transaction_Type, A.Transaction_Web_Rate



GO
