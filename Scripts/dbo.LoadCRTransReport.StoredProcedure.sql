USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[LoadCRTransReport]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO














CREATE Procedure [dbo].[LoadCRTransReport] --'\\svbhq030\Cclog\EigenCRTransLog\Vancouver\BGTN0308042011.txt','Eigen_CRTransReport','4/07/2011'
	@filePath varchar(150),
	@dataFile varchar(30)='Eigen_CRTransReport',
	@RBRDate varchar(24)
AS


declare @path varchar(150)
declare @sqlString varchar(400)
--select @filePath='\\svbhq027\AirMilesEFT\test.txt' 

select @path=''''+ @filePath +'''' 
select @dataFile=ISNULL(@dataFile,'Eigen_CRTransReport')

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
+
'
UPDATE '+@dataFile+
'
	SET	RBR_Date = '''+@RBRDate+''''+

'
FROM '+@dataFile+
'
WHERE RBR_Date is NULL'

--print @sqlString
execute(@sqlString)






GO
