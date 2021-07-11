USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[OM_LoadCRTransReport]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO










CREATE Procedure [dbo].[OM_LoadCRTransReport] --'\\svbhq030\Cclog\EigenArchivedLog\BUDGET16022010.txt' 
	@filePath varchar(150)
AS


declare @path varchar(150)
declare @sqlString varchar(300)
--select @filePath='\\svbhq027\AirMilesEFT\test.txt' 

select @path=''''+ @filePath +'''' 

select @sqlString=
'BULK INSERT  Eigen_CRTransReport 
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
--print @sqlString
execute(@sqlString)


GO
