USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetOLResOptExtraByType]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*Created By: Roy He
  Date Created: 2003-09-04
  For Online Reservation
  Selling Additional Equipment Online
*/
            
CREATE PROCEDURE [dbo].[GetOLResOptExtraByType]    --'R','2012-03-25',1,'''ldw'',''pec'',''pai'',''other'''
	@VehClassCode Varchar(1),
	@PickupDate Varchar(24),
        @SellOnline char(1)=Null,
        @TypeList varchar(100)
        
AS
	DECLARE @dPickupDatetime Datetime
	DECLARE @dLastDatetime Datetime
	DECLARE @SQLString NVARCHAR(1800)

	--IF @VehClassCode = '' 	SELECT @VehClassCode = NULL
	--IF @Type = '' 	SELECT @Type = NULL
	

	--SELECT 	@dCurrDatetime = Convert(Datetime, NULLIF(@CurrDate,'')),
	--select	@dLastDatetime = Convert(Datetime, '31 Dec 2078 23:59')
        --select @SellOnline= Convert(bit,@SellOnline)

	--select @SQLString=
 --       N' SELECT A.Optional_Extra, A.Optional_Extra_ID,B.Daily_Rate, B.Weekly_Rate, CONVERT(int, B.gst_exempt), CONVERT(int, B.pst_exempt), '
	--+' A.Maximum_Quantity,A.Type, ''as Quantity, ''as RentalPeriod, CONVERT(Varchar(10) ,C.LDW_Deductible) as Deductible FROM LDW_Deductible C, '
	--+' Optional_Extra_Price B,Optional_Extra A WHERE	A.Optional_Extra_ID NOT IN ( '
	--+'	SELECT	Optional_Extra_ID FROM	Optional_Extra_Restriction'
	--+'	WHERE	Vehicle_Class_Code ='+ 'NULLIF('''+@VehClassCode +''','''''+')) '
	--+' AND A.Optional_Extra_ID *= C.Optional_Extra_ID AND	A.Optional_Extra_ID = B.Optional_Extra_ID '
	--+' AND A.Delete_Flag = 0 AND' 
 --       +' Convert(Datetime, NULLIF('''+@PickupDate+''',''''))' +'BETWEEN B.Optional_Extra_Valid_From '
 --	+' AND ISNULL(B.Valid_To,'+ 'Convert(Datetime, ''31 Dec 2078 23:59'')'+') AND	C.Vehicle_Class_Code ='''+ @VehClassCode+''''
	--+' And     A.type IN ('+@TypeList+') And     (A.SellOnline='+'Convert(bit,'''+@SellOnline+''')'+' or '+ 'Convert(bit,'''+@SellOnline+''')' +'is null)'
	--+' ORDER BY C.LDW_Deductible, A.Optional_Extra'
	--+' RETURN @@ROWCOUNT'
	
	
	
select @SQLString= 
 ' Select Optional_Extra_Name, Optional_Extra_ID,OptExtra.Description,Daily_Rate, Weekly_Rate, GST_Exempt, HST2_Exempt, PST_Exempt, Maximum_Quantity, Type, Quantity, RentalPeriod, Deductible from '
+' (   SELECT A.Optional_Extra_Name, A.Optional_Extra_ID,B.Daily_Rate, B.Weekly_Rate, '
+'	CONVERT(int, B.gst_exempt) GST_Exempt,CONVERT(int, B.hst2_exempt) HST2_Exempt, CONVERT(int, B.pst_exempt) PST_Exempt, '
+'	A.Maximum_Quantity,A.Type, ''''as Quantity, ''''as RentalPeriod, CONVERT(Varchar(10) ,C.LDW_Deductible) as Deductible, '
+'	NULLIF('''+@VehClassCode +''','''''+') as Vehicle_Class_Code, A.Description'
+'	FROM Optional_Extra A '
+'	Inner join Optional_Extra_Price B'
+'			On A.Optional_Extra_ID = B.Optional_Extra_ID  '
+'	Left Join LDW_Deductible C  '
+'			On A.Optional_Extra_ID = C.Optional_Extra_ID  AND C.Vehicle_Class_Code ='''+ @VehClassCode+''''
+' WHERE	'
+'	A.Optional_Extra_ID NOT IN '
+'	(SELECT	Optional_Extra_ID FROM	Optional_Extra_Restriction	WHERE	Vehicle_Class_Code ='+ 'NULLIF('''+@VehClassCode +''','''''+'))'
+'	And  '
+'	A.Delete_Flag = 0 '
+'	AND Convert(Datetime, NULLIF('''+@PickupDate+''','''')) BETWEEN B.Optional_Extra_Valid_From  AND ISNULL(B.Valid_To,Convert(Datetime, ''31 Dec 2078 23:59'')) '
+'	And A.type IN ('+@TypeList+')'
+'  And (A.SellOnline='+'Convert(bit,'''+@SellOnline+''')'+' or '+ 'Convert(bit,'''+@SellOnline+''')' +'is null)'
+' ) '
+' OptExtra '
+' Inner Join Vehicle_Class VC'
+'	On OptExtra.Vehicle_Class_code=VC.Vehicle_Class_code'
+' Where (Type=''LDW'' and Optional_Extra_ID=VC.Default_optional_Extra_ID) or (Type<>''LDW'' and 
               not (VC.Vehicle_Class_Code not in (''1'', ''F'') and OptExtra.Type=''WT'')) '
+' ORDER BY Deductible, Optional_Extra_Name'





--Print @SQLString
  Exec (@SQLString)
GO
