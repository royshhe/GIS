USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[FA_GetDepLeaseMonthEnd]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create Procedure [dbo].[FA_GetDepLeaseMonthEnd]
@AMOMonth VarChar(24)
as


DECLARE @dAMOMonth  	Datetime
Declare @dMonthBeginning Datetime
Declare @dMonthEnd Datetime

SELECT	@dAMOMonth = Convert(Datetime, NULLIF(@AMOMonth,''))
Select @dMonthBeginning=@dAMOMonth-Day(@dAMOMonth)+1
Select @dMonthEnd=DATEADD(month,1, @dMonthBeginning)-1


SELECT       Vehicle_AMO_Date, Lease_AMO_Date
FROM         dbo.FA_Dep_Lease_Month_End
Where  FA_Month between @dMonthBeginning and @dMonthEnd
GO
