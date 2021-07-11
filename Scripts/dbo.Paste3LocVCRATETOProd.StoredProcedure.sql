USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[Paste3LocVCRATETOProd]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

--Steps to post GIS Rate info
--Create rate info for one location 
--import to table TmpLocationVehicleRateLevel
--check to make sure no null value 
--Run this procedure
--it is done!

CREATE PROCEDURE [dbo].[Paste3LocVCRATETOProd]
as

declare @Err int
set @Err=0
--check rate name
if not exists(select * from RMCheckRateExist_vw)

	begin

	--import to another table  LocationVehicleRateLevel

             delete from LocationVehicleRateLevel

	exec @err= RMImportLocVCRateDateFromXL
              if @err=0
		 begin
		

                             --backup first 

		--DELETE FROM Location_Vehicle_Rate_Levelbak

--                     insert into location_Vehicle_Rate_Levelbak
  --                 select * from Location_Vehicle_Rate_Level

                                  --airport
			update LocationVehicleRateLevel
			set location_id=16     --yvr airport
			
			exec PasteLocVCRateToProd
			if @@error<>0 
				begin
	                                                       print 'last step failed'
					set @err=@@error
	                                                     return @err
				end
		
			update LocationVehicleRateLevel
			set location_id=20     --Downtown
			
			exec PasteLocVCRateToProd
			
			update LocationVehicleRateLevel
			set location_id=23    --burrard
			
			exec PasteLocVCRateToProd
			
			print 'It is done successfully'


		end
                else
                begin
		print 'Import procedure failed'
		set @err=1000	
	end 
	
	end
	
	else
	
	begin
	
		print 'Rate name is invalid'
	              set @err=1000
	end

RETURN @err
GO
