USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[Aeroplan_Create_EFT_File]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- 250 base miles per rental

 

/*
PURPOSE: 
REQUIRES: 
AUTHOR: Roy He
DATE CREATED: Jan 14, 2017
CALLED BY: Schedule Job
MOD HISTORY:
Name    Date        Comments
*/

CREATE   PROCEDURE [dbo].[Aeroplan_Create_EFT_File]  -- '13 Sep 2010', '13 Sep 2010'
	@paramStartDate datetime = '15 April 1999',
	@paramEndDate datetime = '15 April 1999'
AS
--Generate Air Miles EFT Files
Delete Aeroplan_EFT_Header Where Starting_RBR_Date= @paramStartDate and Ending_RBR_Date =@paramEndDate 



Declare @dtToday datetime
Declare @PartnerCode varchar(3)
Declare @RecordTpye varchar(2)
Declare @BaseMCP varchar(4)
Declare @SourceID varchar(2)
Declare @FileName varchar(30)

Declare @FileCreationNumber int

--Transaciton Detail
Declare @Transaction_Type_Detail varchar(2)

Declare @CompanyID varchar(25)


Select @dtToday=getdate()
 
SELECT @PartnerCode= dbo.SystemSettingValues.SettingValue
                       FROM          dbo.SystemSetting INNER JOIN
                                              dbo.SystemSettingValues ON dbo.SystemSetting.SettingID = dbo.SystemSettingValues.SettingID
                       WHERE      (dbo.SystemSetting.SettingName = 'AeroPlanEFT') AND (dbo.SystemSettingValues.ValueName = 'PartnerCode')

Select @RecordTpye= dbo.SystemSettingValues.SettingValue
                       FROM          dbo.SystemSetting INNER JOIN
                                              dbo.SystemSettingValues ON dbo.SystemSetting.SettingID = dbo.SystemSettingValues.SettingID
                       WHERE      (dbo.SystemSetting.SettingName = 'AeroPlanEFT') AND (dbo.SystemSettingValues.ValueName = 'RecordType')
                       
Select @BaseMCP= dbo.SystemSettingValues.SettingValue
                       FROM          dbo.SystemSetting INNER JOIN
                                              dbo.SystemSettingValues ON dbo.SystemSetting.SettingID = dbo.SystemSettingValues.SettingID
                       WHERE      (dbo.SystemSetting.SettingName = 'AeroPlanEFT') AND (dbo.SystemSettingValues.ValueName = 'BaseMPC')
 

SELECT @SourceID= dbo.SystemSettingValues.SettingValue
                       FROM          dbo.SystemSetting INNER JOIN
                                              dbo.SystemSettingValues ON dbo.SystemSetting.SettingID = dbo.SystemSettingValues.SettingID
                       WHERE      (dbo.SystemSetting.SettingName = 'AeroPlanEFT') AND (dbo.SystemSettingValues.ValueName = 'SourceIdentifier')



SELECT @FileName= dbo.SystemSettingValues.SettingValue
                       FROM          dbo.SystemSetting INNER JOIN
                                              dbo.SystemSettingValues ON dbo.SystemSetting.SettingID = dbo.SystemSettingValues.SettingID
                       WHERE      (dbo.SystemSetting.SettingName = 'AeroPlanEFT') AND (dbo.SystemSettingValues.ValueName = 'FileName')
                       


--CREATE TABLE [dbo].[Aeroplan_EFT_Header](
--	[File_Creation_Number] [int] IDENTITY(1,1) NOT NULL,
--	[Starting_RBR_Date] [datetime] NULL,
--	[Ending_RBR_Date] [datetime] NULL,
--	[File_Name] [varchar](13) NULL,
--	[Record_Type] [varchar](2) NULL,
--	[Source_Identifier] [varchar](10) NULL,
--	[Record_Count] [int] NULL,
--	[File_CreatetionDate] [datetime] NULL,
--	[Partner_code] [varchar](3) NOT NULL
--) ON [PRIMARY]


Insert into Aeroplan_EFT_Header
	(
	Starting_RBR_Date ,
	Ending_RBR_Date,
	File_Name,
	Record_Type,
	Source_Identifier,
	File_CreatetionDate,
	Partner_code
	)
SELECT  @paramStartDate,
	@paramEndDate, 
	@FileName,
	@RecordTpye,
	@SourceID,
	@dtToday,
	@PartnerCode
	--convert(varchar(2),day(@dtToday))+convert(varchar(2),month(@dtToday))+ substring(convert(varchar(4),year(@dtToday)),3,2) as File_Creation_Date
 

Select @FileCreationNumber=@@IDENTITY


--Detail


--CREATE TABLE [dbo].[Aeroplan_EFT_Detail](
--	[Detail_ID] [int] IDENTITY(1,1) NOT NULL,
--	[File_Creation_number] [int] NOT NULL,
--	[Partner_Code] [varchar](3) NOT NULL,
--	[Card_Number] [varchar](9) NOT NULL,
--	[Alliance_Location_Name] [varchar](10) NULL,
--	[Invoice_Number] [varchar](10) NOT NULL,
--	[RBR_Date] [datetime] NOT NULL,
--	[Promo_Item_Code] [varchar](10) NULL,
--	[MPC] [varchar](4) NULL,
--	[Activity_Amount] [int] NULL,
--	[Source_Identifier] [varchar](2) NULL,
--	[Business_Transaction_ID] [int] NOT NUL
	
 
SELECT @CompanyID=Code from dbo.Lookup_Table
WHERE (dbo.Lookup_Table.Category = 'BudgetBC Company ') 


Delete Aeroplan_EFT_Detail Where (RBR_Date >= @paramStartDate) and (RBR_Date < @paramEndDate+1) 
	
Insert into Aeroplan_EFT_Detail ( 
File_Creation_number, 
Partner_Code,
Card_Number,
Alliance_Location_Name,
Invoice_Number, 
RBR_Date, 
Promo_Item_Code,
MPC,
Activity_Amount,
Source_Identifier,
Business_Transaction_ID
)
--select     Right(convert(varchar(15),(2300933 +10000000000)),10) AS Invoice_Number


SELECT @@IDENTITY as File_Creation_Number,
    @PartnerCode,
    Right(c.FF_Member_Number,9),    
    
    (Case When vc.Vehicle_Type_ID='Car' Then
		convert(varchar(5),PULoc.Car_StationNumber)+convert(varchar(5),DOLoc.Car_StationNumber) 
    Else
		convert(varchar(5),PULoc.TK_StationNumber)+convert(varchar(5),DOLoc.TK_StationNumber)
    End) Alliance_Location_Name,
    
    Right(convert(varchar(15),(c.Contract_Number +10000000000)),10) AS Invoice_Number, 
    bt.RBR_Date,
    NULL Promo_Item_Code,
    @BaseMCP,
    250 Activity_Amount,    
    @SourceID,
    bt.Business_Transaction_ID
    
	
FROM       

 	Contract c
	INNER JOIN
    	Business_Transaction bt 
		ON bt.Contract_Number = c.Contract_Number
    INNER JOIN 
	Vehicle_Class vc
		ON c.Vehicle_Class_Code = vc.Vehicle_Class_Code
	INNER JOIN dbo.Location PULoc
		ON c.Pick_Up_Location_ID = PULoc.Location_ID 
	INNER JOIN
   	RP__Last_Vehicle_On_Contract rlv
		ON c.Contract_Number = rlv.Contract_Number
	INNER JOIN dbo.Location DOLoc
		ON DOLoc.Location_ID = rlv.Actual_Drop_Off_Location_ID 
			
	LEFT OUTER JOIN dbo.Frequent_Flyer_Plan 
		ON c.Frequent_Flyer_Plan_ID = dbo.Frequent_Flyer_Plan.Frequent_Flyer_Plan_ID 

	
WHERE     
	(
			(dbo.Frequent_Flyer_Plan.Frequent_Flyer_Plan = 'Aeroplan') 
		AND (bt.RBR_Date >= @paramStartDate) 
		AND (bt.RBR_Date < @paramEndDate+1) 
		AND (PULoc.Owning_Company_ID=@CompanyID) 
		--and c.Pick_Up_On>='2007-01-08'  
			  
	)
	
	And 	
		(bt.Transaction_Type = 'con') 
	AND 
    	(bt.Transaction_Description = 'check in') 
    AND 
		c.Status not in ('vd', 'ca') 
	And 
		c.foreign_contract_number is null
	And 
		c.FF_Member_Number is not null
		
union


SELECT @@IDENTITY as File_Creation_Number,
    @PartnerCode,
    Right(APA.Missing_Number,9),    
    
    (Case When vc.Vehicle_Type_ID='Car' Then
		convert(varchar(5),PULoc.Car_StationNumber)+convert(varchar(5),DOLoc.Car_StationNumber) 
    Else
		convert(varchar(5),PULoc.TK_StationNumber)+convert(varchar(5),DOLoc.TK_StationNumber)
    End) Alliance_Location_Name,
    
    Right(convert(varchar(15),(c.Contract_Number +10000000000)),10) AS Invoice_Number, 
    APA.RBR_Date,
    NULL Promo_Item_Code,
    @BaseMCP,
    250 Activity_Amount,    
    @SourceID,
    NULL Business_Transaction_ID
    

	FROM       dbo.Aeroplan_Points_Adjustment APA
	Inner Join Contract c
		On APA.Contract_Number= c.Contract_Number
	
    INNER JOIN 
	Vehicle_Class vc
		ON c.Vehicle_Class_Code = vc.Vehicle_Class_Code
	INNER JOIN dbo.Location PULoc
		ON c.Pick_Up_Location_ID = PULoc.Location_ID 
	INNER JOIN
   	RP__Last_Vehicle_On_Contract rlv
		ON c.Contract_Number = rlv.Contract_Number
	INNER JOIN dbo.Location DOLoc
		ON DOLoc.Location_ID = rlv.Actual_Drop_Off_Location_ID 
			
			
			
Where  (RBR_Date >= @paramStartDate) 
		AND (RBR_Date < @paramEndDate+1)  		
					
					
			 
             
GO
