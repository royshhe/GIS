USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[FA_GetLoanMonthEnde]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create Procedure [dbo].[FA_GetLoanMonthEnde] --'2008-01-01', 'BMO'
@AMOMonth VarChar(24),
@Fin_Code Char(10)
as


DECLARE @dAMOMonth  	Datetime
Declare @dMonthBeginning Datetime
Declare @dMonthEnd Datetime

SELECT	@dAMOMonth = Convert(Datetime, NULLIF(@AMOMonth,''))
Select @dMonthBeginning=@dAMOMonth-Day(@dAMOMonth)+1
Select @dMonthEnd=DATEADD(month,1, @dMonthBeginning)-1


SELECT       Loan_AMO_Date
FROM         dbo.FA_Loan_Month_End
Where  FA_Month between @dMonthBeginning and @dMonthEnd and Fin_code=@Fin_Code
GO
