USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetTaxRates]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO















/****** Object:  Stored Procedure dbo.GetTaxRates    Script Date: 2/18/99 12:11:48 PM ******/
/****** Object:  Stored Procedure dbo.GetTaxRates    Script Date: 2/16/99 2:05:43 PM ******/
CREATE PROCEDURE [dbo].[GetTaxRates] 
@ContractNum Varchar(10)
AS
Set Rowcount 1
Declare @GSTRate decimal(7,4)
Declare @PVRTRate decimal(7,4)
DECLARE @dtDatetime datetime
SELECT @dtDatetime=Pick_Up_ON
		from contract
		where contract.contract_number=@ContractNum


SELECT @GSTRate =
	(SELECT
		ISNULL(Tax_Rate, 0)
	FROM
		Tax_Rate
	WHERE
		(Tax_Type = 'GST'
		And @dtDatetime BETWEEN Valid_From AND Valid_To)
	  or (Tax_Type='HST'
			And @dtDatetime BETWEEN Valid_From AND Valid_To)
		)
SELECT @PVRTRate =
	(SELECT
		ISNULL(Tax_Rate, 0)
	FROM
		Tax_Rate
	WHERE
		Tax_Type = 'PVRT'
		And @dtDatetime BETWEEN Valid_From AND Valid_To)
SELECT @GSTRate, @PVRTRate
RETURN 1















GO
