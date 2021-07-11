USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[FA_GetLoanFirstMonthPrincipalRate]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[FA_GetLoanFirstMonthPrincipalRate]
   @RateID Varchar(20)
As
SELECT top 1 Principal_Rate, Principal_Rate_Amount, Start_Month, End_Month
FROM         dbo.FA_Loan_Principal_Rate_Detail
Where Rate_ID= Convert(Int, @RateID)
Order By Start_Month
GO
