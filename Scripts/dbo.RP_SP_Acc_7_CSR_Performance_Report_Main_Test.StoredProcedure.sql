USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Acc_7_CSR_Performance_Report_Main_Test]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[RP_SP_Acc_7_CSR_Performance_Report_Main_Test]
(
	@Vehicle_Type		VARCHAR(5)  	= 'Car',	
	@Location_ID		VARCHAR(10) 	= '*',	
	@Check_In_Or_Out	VARCHAR(9)     	= 'Check In',
	@RBR_Start_Date 	varchar(10) 	= '1999/04/23',
	@RBR_End_Date 	varchar(10) 	= '1999/04/23',
	@CSR_Name		VARCHAR(20) 	= '*',
	@Rate_Name		VARCHAR(25) 	= '*'
)	

AS

-- convert strings to datetime
DECLARE @startDate datetime,
	@endDate datetime

SELECT	@startDate	= CONVERT(datetime, @RBR_Start_Date + ' 00:00:00'),
	@endDate	= CONVERT(datetime, @RBR_End_Date + ' 23:59:59')	

print @startDate


GO
