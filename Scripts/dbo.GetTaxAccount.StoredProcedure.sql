USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetTaxAccount]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.GetTaxAccount    Script Date: 2/18/99 12:11:48 PM ******/
/****** Object:  Stored Procedure dbo.GetTaxAccount    Script Date: 2/16/99 2:05:43 PM ******/
CREATE PROCEDURE [dbo].[GetTaxAccount]   -- 'GST','01 mar 2013'
	@TaxType	VarChar(10),
	@Datetime	VarChar(24)=''
AS
Set Rowcount 1
DECLARE @dtDatetime datetime
SELECT @dtDatetime=case @Datetime
					when '' then getdate()
					else CONVERT(datetime, @Datetime)
				end

if (@dtDatetime>=convert(datetime,'2010-07-01 00:00') And @dtDatetime<convert(datetime,'2013-04-01 00:00')) and upper(@taxtype)='GST'
  begin
	select @TaxType='HST'
  end
  
 
SELECT
	Payables_Clearing_Account
 FROM
	Tax_Rate
WHERE
	Tax_Type = @TaxType
	And @dtDatetime BETWEEN Valid_From AND Valid_To
RETURN 1
GO
