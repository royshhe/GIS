USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[Aeroplan_GET_EFT_Header]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
Procedure NAME: Aeroplan_GET_EFT_Header
PURPOSE: 
AUTHOR: Roy He
DATE CREATED: Feb 22, 2017
CALLED BY: Aeroplan EFT 
MOD HISTORY:
Name    Date        Comments
*/
CREATE procedure [dbo].[Aeroplan_GET_EFT_Header]   -- '2017-02-21','2017-02-21'
	@paramStartDate varchar(20) = '15 April 1999',
	@paramEndDate varchar(20) = '15 April 1999'
AS



-- convert strings to datetime
DECLARE @startDate datetime,
		@endDate datetime,		
		@SignedDigit Char(1),
		@TotalDetail int



SELECT	@startDate	= CONVERT(datetime, @paramStartDate),
				@endDate	= CONVERT(datetime, @paramEndDate)	

SELECT @TotalDetail=count(*)   FROM dbo.Aeroplan_EFT_Detail
Where   RBR_Date BETWEEN @startDate and  @endDate
  
SELECT  File_Creation_Number,

		File_Name+'_'+
		RIGHT(CONVERT(varchar(5), YEAR(File_CreatetionDate)), 4)+
		RIGHT(CONVERT(varchar(3), MONTH(File_CreatetionDate)+100),2) +
		RIGHT(CONVERT(varchar(3), DAY(File_CreatetionDate)+100),2)+
	    RIGHT(CONVERT(varchar(3),  datepart(hh, File_CreatetionDate)+100),2)+
		RIGHT(CONVERT(varchar(3),  datepart(mi, File_CreatetionDate)+100),2)	+
		RIGHT(CONVERT(varchar(3),  datepart(ss, File_CreatetionDate)+100),2)	
		as File_Name,    
		
		Record_Type+
		Source_Identifier+
		RIGHT(CONVERT(varchar(7),(@TotalDetail +1000000)),6)+
		RIGHT(CONVERT(varchar(5), YEAR(File_CreatetionDate)), 4)+
		RIGHT(CONVERT(varchar(3), MONTH(File_CreatetionDate)+100),2) +
		RIGHT(CONVERT(varchar(3), DAY(File_CreatetionDate)+100),2)+
		Partner_code+
		SPACE(67) 
		as Header_Record  
		
FROM         dbo.Aeroplan_EFT_Header
where Starting_RBR_Date=@startDate and  Ending_RBR_Date=@endDate

GO
