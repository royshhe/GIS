USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[FA_Get_Loan_Principal_Rate]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[FA_Get_Loan_Principal_Rate] -- '*'
	@FinCode Char(12)='',
    @FinanceStartDate Varchar(24)=''
AS

Declare @dFiananceStartDate DateTime
if @FinanceStartDate=''
	Select @dFiananceStartDate=Convert(DateTime, Convert(Varchar, Getdate(),111))
Else
	Select @dFiananceStartDate=Convert(DateTime, @FinanceStartDate)
  
Select @FinCode=NullIf(@FinCode,'')

	SELECT     Rate_Code, Rate_ID, Fin_Code
	FROM         dbo.FA_Loan_Principal_Rate
	WHERE     (@FinCode='*') or (Fin_Code = @FinCode) and @dFiananceStartDate between Effective_Date and ISNULL(Terminate_Date, Convert(Datetime, '2078-12-31'))

return 1
GO
