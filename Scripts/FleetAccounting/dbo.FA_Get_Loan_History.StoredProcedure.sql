USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[FA_Get_Loan_History]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[FA_Get_Loan_History]
@UnitNumber int
as

SELECT     Fin_Code,Principal_Rate_ID,Override_Principal_Rate, Loan_Amount, Trans_Month, 

CONVERT(VarChar, Finance_Start_Date, 111) Finance_Start_Date,
CONVERT(VarChar, Finance_End_Date, 111) Finance_End_Date,

--Finance_Start_Date, Finance_End_Date, 
Payout_Amount, Payout_Date, Last_Update_On
FROM         dbo.FA_Loan_History
where Unit_number=@UnitNumber
GO
