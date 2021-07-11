USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateTRProcessStatus]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[UpdateTRProcessStatus]  --'1609151', 'T1'
	@ContractNumber Varchar(20),
	@Issuer Varchar(10),
	@BusTrxID Varchar(20)
As
Update Toll_Reporting
	Set Processed =1,
	Business_Transaction_ID= Convert(int, NULLIF(@BusTrxID, '')) 	 
	FROM  dbo.Toll_Reporting AS TR
	LEFT OUTER JOIN
	(SELECT Con.Contract_Number, Res.Foreign_Confirm_Number
			FROM  dbo.Contract AS Con INNER JOIN
			dbo.Reservation AS Res 
			ON Con.Confirmation_Number = Res.Confirmation_Number
	) AS RA 
	ON TR.Confirmation_Number = RA.Foreign_Confirm_Number
	Where TR.Processed=0 
	And (RA.Contract_number=Convert(int,@ContractNumber) or TR.Contract_number=Convert(int,@ContractNumber) )
	And Issuer=@Issuer

GO
