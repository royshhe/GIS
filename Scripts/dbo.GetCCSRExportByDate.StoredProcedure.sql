USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCCSRExportByDate]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--------------------------------------------------------------------------------------------------------------------
--	Programmer:	Roy He
--	Date:		2003-12-19
--	Details		ccrs Export
--	Modification:		Name:		Date:		Detail:
--
---------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[GetCCSRExportByDate]
(
	@paramStartBusDate varchar(20) = '22 Apr 2001',
	@paramEndBusDate varchar(20) = '23 Apr 2001'
)
AS
-- convert strings to datetime
DECLARE 	@startBusDate datetime,
		@endBusDate datetime

SELECT	@startBusDate	= CONVERT(datetime, '00:00:00 ' + @paramStartBusDate),
		@endBusDate	= CONVERT( datetime,'00:00:00 ' + @paramEndBusDate)+1	

SELECT 	
	*
FROM 	ViewCCRSMain
WHERE	RBR_date >= @startBusDate and RBR_date<@endBusDate
GO
