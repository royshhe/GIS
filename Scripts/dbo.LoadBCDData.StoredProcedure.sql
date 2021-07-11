USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[LoadBCDData]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create Procedure [dbo].[LoadBCDData] --'ORIONFL1-sample.txt', 'BCD_Data','24/11/2011'
	@fileName  varchar(100),
	@dataFile varchar(30)='BCD_Data'
	--@RBRDate varchar(24)
AS

Declare @filePath varchar(150)
declare @path varchar(150)
declare @sqlString varchar(400)
 
SELECT @filePath = dbo.SystemSettingValues.SettingValue
FROM  dbo.SystemSetting INNER JOIN
               dbo.SystemSettingValues ON dbo.SystemSetting.SettingID = dbo.SystemSettingValues.SettingID
WHERE (dbo.SystemSetting.SettingName = 'BCDData') AND (dbo.SystemSettingValues.ValueName = 'BCDFilePath')


--select @filePath='\\svbhq027\AirMilesEFT\test.txt' 

--select @path=''''+ @filePath +@fileName+'''' 
select @path=''''+ @fileName  +'''' 

select @dataFile=ISNULL(@dataFile,'BCD_Data')

select @sqlString=
'BULK INSERT '+@dataFile+' 
	FROM ' +@path
+ 
'    
	WITH 
	( 
		FIRSTROW =1, 
		MAXERRORS = 0, 
		FIELDTERMINATOR = ''\t'', 
		ROWTERMINATOR = ''\n''
	)
'
--+
--'
--UPDATE '+@dataFile+
--'
--	SET	RBR_Date = '''+@RBRDate+''''+

--'
--FROM '+@dataFile+
--'
--WHERE RBR_Date is NULL'

--print @sqlString
execute(@sqlString)
GO
