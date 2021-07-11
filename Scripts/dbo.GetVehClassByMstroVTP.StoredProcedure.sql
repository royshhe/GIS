USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetVehClassByMstroVTP]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.GetVehClassByMstroVTP    Script Date: 2/18/99 12:11:57 PM ******/
/****** Object:  Stored Procedure dbo.GetVehClassByMstroVTP    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.GetVehClassByMstroVTP    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.GetVehClassByMstroVTP    Script Date: 11/23/98 3:55:34 PM ******/
/*
PROCEDURE NAME: GetVehClassByMstroVTP
PURPOSE: To retrieve the GIS vehicle class code for a maestro code.
AUTHOR: Roy He
DATE CREATED: Oct 22, 1998
CALLED BY: Fleet Control
MOD HISTORY:
Name    Date        Comments
Don K	Feb 23 1999 Added vehicle_class_name
*/
/* Oct 29 - Moved data conversion code with NULLIF out of the where clause */
-- obsolete
--$cmd=r~ICAR~C~V01~
--select * from location   YR4	  RH4
CREATE PROCEDURE [dbo].[GetVehClassByMstroVTP] -- 'ECAR', 'a',  'KM6' 
	@MstroVTP	varchar(6),
	@MstroCode	varchar(6),
	@Mnemonic varchar(4)
	
AS
    
	SELECT	@MstroVTP = NULLIF(@MstroVTP, '')
	SELECT	@MstroCode = NULLIF(@MstroCode, '')
	SELECT	@Mnemonic = NULLIF(@Mnemonic, '')
	
	Declare @iCountTruck Int
	Select @iCountTruck=count(*) from Location where TK_Mnemonic_Code=@Mnemonic
	
	
	if @iCountTruck=0 
		Begin
	  
	  -- Convert two door to four door---
	  
		   If @MstroVTP='SCAR'
				Select @MstroVTP='FCAR'

			SELECT	vehicle_class_code,
				vehicle_class_name
			  FROM	vehicle_class
			 WHERE	SIPP = @MstroVTP
				and vehicle_type_id='Car'
		End
	Else
		Begin
			
			SELECT	vehicle_class_code,
					vehicle_class_name
				  FROM	vehicle_class
				 WHERE maestro_code = @MstroCode
					and vehicle_type_id='Truck'
		End
		
	
	RETURN @@ROWCOUNT
GO
