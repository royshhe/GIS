USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[LoadingBCDMatrixRateMissing]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




Create PROCEDURE  [dbo].[LoadingBCDMatrixRateMissing]
AS


Declare @BCDNumber char(10)
Declare @CompanyName varchar(50)
Declare  @iCount int
Declare @QuotedRateID int
Declare @VehicleClassCode char(1)

-- Quoted Rate

Declare @RateSource varchar(10)
Declare @RateName varchar(25)
Declare @RPurposeId varchar(6)
Declare @RateStruct varchar(1)
Declare @DOCharge varchar(9)
Declare @TaxIncl varchar(1)
Declare @GSTIncl varchar(1)
Declare @PSTIncl varchar(1)
Declare @PVRTIncl varchar(1)
Declare @LocFeeIncl varchar(1)
Declare @LicFeeIncl varchar(1)
Declare @ERFIncl varchar(1)


Declare @PerKmCharge1 varchar(9)
Declare @PerKmCharge2 varchar(9)
Declare @PerKmCharge3 varchar(9)
Declare @PerKmCharge4 varchar(9)
Declare @PerKmCharge5 varchar(9)
Declare @PerKmCharge6 varchar(9)
Declare @PerKmCharge7 varchar(9)
Declare @PerKmCharge8 varchar(9)

Declare @CalendarDayRate varchar(1)
Declare @FPOPurchased varchar(1)
Declare @CommissionPaid varchar(1)
Declare @FFPH varchar(1)
Declare @OtherInclusions Varchar(255)
Declare @CorporateResponsibility varchar(11)

-- Time Period
Declare @Type		varchar(7)
Declare @Amount decimal(9, 2) 
Declare @Amount1 decimal(9, 2) 
Declare @Amount2 decimal(9, 2) 
Declare @Amount3 decimal(9, 2) 
Declare @Amount4 decimal(9, 2) 
Declare @Amount5 decimal(9, 2) 
Declare @Amount6 decimal(9, 2) 
Declare @Amount7 decimal(9, 2) 
Declare @Amount8 decimal(9, 2) 
Declare @sAmount varchar(11)
Declare @sKmCap varchar(6)
Declare @KmCap smallint
Declare @Coverage varchar(10)
Declare @LDWID varchar(5)
Declare @iCountBCD int
Declare @iBCDNumberFetchStatus int
Declare @iVCCodeFetchStatus int
Declare @VCCode char(1) 

---- Sychronize with Corporate BCD Matrix
--Update  dbo.Organization Set Organization=dbo.BCDMatrix.CompanyName
--FROM         dbo.Organization INNER JOIN
--                      dbo.BCDMatrix ON dbo.Organization.BCD_Number = dbo.BCDMatrix.BCD#
--
--
---- Deactivate the organizations that doesn't not exist in the new bcd matrix
--Update Organization Set Inactive =1 where BCD_Number in 
--(
--SELECT   BCDMatrixBak.BCD# 
--FROM         dbo.BCDMatrixBak where BCDMatrixBak.BCD#  not in (select dbo.BCDMatrix.BCD# from  dbo.BCDMatrix)
--)  and (Tour_Rate_account<>1 or Tour_Rate_account is null)
--
---- Activate those with local GIS Rate
--Update Organization Set Inactive=0
--FROM         dbo.Organization INNER JOIN
--                      dbo.Organization_Rate ON dbo.Organization.Organization_ID = dbo.Organization_Rate.Organization_ID
--where dbo.Organization.Inactive=1

DECLARE BCDNumber_cursor CURSOR FOR
SELECT BCD# from dbo.BCDMatrix  where BCD# not in (select BCD_Number from Quoted_Organization_Rate)
--SELECT	BCD# FROM	 dbo.BCDMatrix
--where BCD# not in (
--						SELECT      dbo.BCDMatrix.BCD# 
--						FROM         dbo.BCDMatrix INNER JOIN
--							  dbo.BCDMatrixBak ON dbo.BCDMatrix.BCD# = dbo.BCDMatrixBak.BCD# AND 
--							  dbo.BCDMatrix.RateCode = dbo.BCDMatrixBak.RateCode AND 
--							  dbo.BCDMatrix.KM_Cap = dbo.BCDMatrixBak.KM_Cap AND dbo.BCDMatrix.Class1 = dbo.BCDMatrixBak.Class1 AND 
--							  dbo.BCDMatrix.Mil1 = dbo.BCDMatrixBak.Mil1 AND dbo.BCDMatrix.Class2 = dbo.BCDMatrixBak.Class2 AND 
--							  dbo.BCDMatrix.Mil2 = dbo.BCDMatrixBak.Mil2 AND dbo.BCDMatrix.Class3 = dbo.BCDMatrixBak.Class3 AND 
--							  dbo.BCDMatrix.Mil3 = dbo.BCDMatrixBak.Mil3 AND dbo.BCDMatrix.Class4 = dbo.BCDMatrixBak.Class4 AND 
--							  dbo.BCDMatrix.Mil4 = dbo.BCDMatrixBak.Mil4 AND dbo.BCDMatrix.Class5 = dbo.BCDMatrixBak.Class5 AND 
--							  dbo.BCDMatrix.Mil5 = dbo.BCDMatrixBak.Mil5 AND dbo.BCDMatrix.Class6 = dbo.BCDMatrixBak.Class6 AND 
--							  dbo.BCDMatrix.Mil6 = dbo.BCDMatrixBak.Mil6 AND dbo.BCDMatrix.Class7 = dbo.BCDMatrixBak.Class7 AND 
--							  dbo.BCDMatrix.Mil7 = dbo.BCDMatrixBak.Mil7 AND dbo.BCDMatrix.Class8 = dbo.BCDMatrixBak.Class8 AND 
--							  dbo.BCDMatrix.Mil8 = dbo.BCDMatrixBak.Mil8
--)
OPEN BCDNumber_cursor



FETCH NEXT FROM BCDNumber_cursor
INTO @BCDNumber

-- Check @@FETCH_STATUS to see if there are any more rows to fetch.
Select @iBCDNumberFetchStatus=@@FETCH_STATUS
WHILE @iBCDNumberFetchStatus = 0
BEGIN

				SELECT  @CompanyName=CompanyName, 
								@RateSource= 'BCDMatrix' , 
								@RateName=RateCode, 
								@RPurposeId=5 , 
								@RateStruct='D', 
								@DOCharge=0.00 , 
								@TaxIncl=0, 
								@GSTIncl=0 , 
								@PSTIncl=  0, @PVRTIncl=0, @LocFeeIncl=0, @LicFeeIncl=0, @ERFIncl=0,
								@PerKmCharge1= (Case When KM_Cap<>'UNL' And Cap1='+'  then Mil1 
															Else 0
													 End) , 
								@PerKmCharge2= (Case When KM_Cap<>'UNL' And Cap1='+' then Mil2 
															Else 0
													 End) , 
								@PerKmCharge3= (Case When KM_Cap<>'UNL' And Cap1='+'  then Mil3 
															Else 0
													 End) , 
								@PerKmCharge4= (Case When KM_Cap<>'UNL'  And Cap1='+' then Mil4 
															Else 0
													 End) , 
								@PerKmCharge5= (Case When KM_Cap<>'UNL' And Cap1='+' then Mil5 
															Else 0
													 End) , 
								@PerKmCharge6= (Case When KM_Cap<>'UNL' And Cap1='+' then Mil6 
															Else 0
													 End) , 
								@PerKmCharge7= (Case When KM_Cap<>'UNL' And Cap1='+' then Mil7 
															Else 0
													 End) , 
								@PerKmCharge8= (Case When KM_Cap<>'UNL' And Cap1='+' then Mil8 
															Else 0
													 End) ,
								 
								@CalendarDayRate=0 ,
								@FPOPurchased=0 , 
								@FFPH= 1 , 
								@CommissionPaid=1, 
								@OtherInclusions='', 
								@CorporateResponsibility='',

								@Type	= 'Regular',
								@Amount1=Class1,
								@Amount2=Class2,
								@Amount3=Class3,
								@Amount4=Class4,
								@Amount5=Class5,
								@Amount6=Class6,
								@Amount7=Class7,
								@Amount8=Class8,
								@KmCap =(Case When KM_Cap='UNL' Then NULL
															Else KM_Cap
												  End),
								@Coverage=convert(varchar(10), coverage)

				FROM         dbo.BCDMatrix

				where BCD#=@BCDNumber

Select @LDWID=Value from  Lookup_Table where Category='BCDLDW' and code=@Coverage

Select
	@iCountBCD=count(*)
From
	Organization
Where
	BCD_Number = @BCDNumber

If @iCountBCD=0 
	exec CreateOrg @CompanyName, @BCDNumber, 'N/A', '', 'N/A', 'N/A', 'N/A', 'N/A', 'N/A', '', '', '', '', '', '', 'N', '', '', 'SQL Job', '1', '1', '0'

       
		DECLARE VCCode_cursor CURSOR FOR
		Select code from lookup_table where category='BCDRateClass' 
		OPEN VCCode_cursor

		FETCH NEXT FROM VCCode_cursor
		INTO @VCCode

		-- Check @@FETCH_STATUS to see if there are any more rows to fetch.
		Select @iVCCodeFetchStatus=@@FETCH_STATUS
		WHILE @iVCCodeFetchStatus = 0
		BEGIN

               SELECT @Amount=(Case 
												When @VCCode='1' Then @Amount1
												When @VCCode='2' Then @Amount2
												When @VCCode='3' Then @Amount3
												When @VCCode='4' Then @Amount4
												When @VCCode='5' Then @Amount5
												When @VCCode='6' Then @Amount6
												When @VCCode='7' Then @Amount7
												When @VCCode='8' Then @Amount8
											End)

				Select @VehicleClassCode=Value from lookup_table where category='BCDRateClass' and code=@VCCode
				
				IF @Amount<>0
				
				BEGIN
							EXEC CreateMstroQRate
										@RateSource, 
										@RateName, 
										@RPurposeId, 
										@RateStruct,
										@DOCharge, 
										@TaxIncl,
										@GSTIncl,
										@PSTIncl, 
										@PVRTIncl, 
										@LocFeeIncl, 
										@LicFeeIncl, 
										@ERFIncl,
										@PerKmCharge1, 
										@CalendarDayRate, 
										@FPOPurchased, 
										@CommissionPaid, 
										@FFPH, 
										@OtherInclusions, 
										@CorporateResponsibility

							Select @QuotedRateID=Convert(varchar(11),@@Identity)
			                            												
							EXEC CreateQRateCtgy @QuotedRateID, '06'
							Select @sAmount= Convert(varchar(11), @Amount)
            				Select @sKmCap=Convert(varchar(6),@KmCap)
							EXEC CreateQTPR @QuotedRateID, @Type, 'Day', '1', '9999', @sAmount, @sKmCap
							Select @sAmount= Convert(varchar(11), (@Amount/2+0.01))
							Select @sKmCap=Convert(varchar(6),(@KmCap/2))
							EXEC CreateQTPR @QuotedRateID, @Type, 'Hour', '25', '9999', @sAmount, @sKmCap
							Select @sAmount= Convert(varchar(11), (@Amount*6))
							Select @sKmCap=Convert(varchar(6),(@KmCap*7))
							EXEC CreateQTPR @QuotedRateID, @Type, 'Week',  '1', '9999', @sAmount, @sKmCap
							Select @sAmount= Convert(varchar(11), (@Amount*28))
							Select @sKmCap=Convert(varchar(6),(@KmCap*28))
							EXEC CreateQTPR @QuotedRateID, @Type, 'Month', '1', '9999',  @sAmount, @sKmCap

							Select @iCount=count(*) from Quoted_Organization_Rate where BCD_Number=@BCDNumber and Vehicle_Class_Code=@VehicleClassCode
			                       
							IF @iCount>0  
								Update Quoted_Organization_Rate set Quoted_Rate_ID=@QuotedRateID where BCD_Number=@BCDNumber and Vehicle_Class_Code=@VehicleClassCode
							ELSE
									Begin
											Insert Quoted_Organization_Rate  
											 (
												BCD_Number,
												Vehicle_Class_Code,
												Quoted_Rate_ID,
												LDWID
											)

											Values
											(  @BCDNumber, 
											   @VehicleClassCode,
											   @QuotedRateID,
											   @LDWID
											)
							END
			
			 END
			 
             ELSE
			 
			 BEGIN
							DELETE Quoted_Organization_Rate where BCD_Number=@BCDNumber and Vehicle_Class_Code=@VehicleClassCode
			 END

			 FETCH NEXT FROM VCCode_cursor	INTO @VCCode				  
			 Select @iVCCodeFetchStatus=@@FETCH_STATUS
	  END
     CLOSE VCCode_cursor
     DEALLOCATE VCCode_cursor
  
     FETCH NEXT FROM BCDNumber_cursor 	INTO @BCDNumber
      Select @iBCDNumberFetchStatus=@@FETCH_STATUS
END
CLOSE BCDNumber_cursor
DEALLOCATE BCDNumber_cursor






GO
