USE [GISData]
GO
/****** Object:  UserDefinedFunction [dbo].[GetBaseRate]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
 --select [dbo].[GetBaseRate] (329.93, 'Hertz', 'YVR', '2017-01-02',7)

CREATE Function  [dbo].[GetBaseRate]   
(
	  @InclusiveRate decimal(9,2),
	  @vendor varchar(20),
	  @Location varchar(20),
	  @ShopDate Datetime,
	  @LOR int,
	  @Ratetype varchar(20)
)  
RETURNS decimal(9,2) 
As

Begin
Declare @ERFPerDay decimal(9,2)
Declare @ERFFlat decimal(9,2)
Declare @VLF decimal(9,2)
Declare @PLS decimal(9,2)
Declare @PVRT decimal(9,2)
Declare @VM decimal(9,2)
Declare @PS decimal(9,2)
Declare @BaseRate decimal(9,2)

Declare @ERFGSTable bit
Declare @VLFGSTable bit
Declare @PLSGSTable bit
Declare @PVRTGSTable bit


Declare @ERFPSTable bit
Declare @VLFPSTable bit
Declare @PLSPSTable bit
Declare @PVRTPSTable bit


Declare @ERFAPFee bit
Declare @VLFAPFee bit


Select 
@ERFPerDay =ERF_Per_Day,
@ERFFlat =ERF_Flat,
@VLF =VLF,
@PLS =PLS,
@PVRT =PVRT,
@VM=isnull(Vehicle_Maint_Fee,0),
@PS=isnull(Parking_Surcharge,0),
@ERFGSTable=ERF_GSTable,
@VLFGSTable=VLF_GSTable,
@PLSGSTable=PLS_GSTable,
@PVRTGSTable=PVRT_GSTable,
@ERFPSTable=ERF_PSTable,
@VLFPSTable=VLF_PSTable,
@PLSPSTable=PLS_PSTable,
@PVRTPSTable=PVRT_PSTable,
@ERFAPFee=ERF_APFee,
@VLFAPFee= VLF_APFee

                          
from Rate_shop_settings where location=@Location and Vendor=@vendor
and @ShopDate>=Effective_Date and @ShopDate<Termination_Date  
 -- New Formular
 

--X=
--  (
--    (A-
--	(ERF*L+ERF_Flat)*(1+PLS/100)*(1+5%+7%) 
--        + P*L*(1+5%+7%)
--        +VM*(1+7%)
--        +PS*(1+5%+7%)
--        )
--    )
--    /
--    (1+PLS/100)*(1+5%+7%)
--    -VLF*L
--   )
--   /
--   L

	
	Select @BaseRate=
					 (
						(
							@InclusiveRate-
							(   							    
								(@ERFPerDay*@LOR+@ERFFlat)
								*(	1.00+
									(Case When @ERFAPFee=1 Then @PLS/100.00 Else 0.00 End)
									 
								 )*(1+0.05+0.07)
								 
								+@PVRT*@LOR*
								(1.00+
										(Case When @PVRTGSTable=1 Then 0.05 Else 0.00 End)
										+
										(Case When @PVRTPSTable=1 Then 0.07 Else 0.00 End)
								)
								+@VM*(1.00+0.07)
								+@PS*(1+0.05+0.07)
							)
							
						)
						/
						((1.00+@PLS/100.00)*(1.00+0.05+0.07))						
						-@VLF*@LOR
					 )
					 /
					 
					 (Case When @Ratetype='D' Then @LOR
						   When @Ratetype='W' Then 1						   
					 End)
	
	
 

Return @BaseRate

End


--Select * from gisusers where user_name like '%ani'


GO
