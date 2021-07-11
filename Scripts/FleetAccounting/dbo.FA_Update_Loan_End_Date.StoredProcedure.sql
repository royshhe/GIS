USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[FA_Update_Loan_End_Date]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[FA_Update_Loan_End_Date]
As

Update Vehicle Set	 Financing_End_Date	   =LE.Loan_end_date
FROM  dbo.Vehicle V INNER JOIN
               dbo.FA_Loan_End_Date_Input LE ON V.Unit_Number = LE.Unit_Number
               
     
GO
