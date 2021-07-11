USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateVehPMService]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/*
PURPOSE: To insert a record into PM_Service table.
MOD HISTORY:
Name    Date        Comments
 */

CREATE PROCEDURE [dbo].[CreateVehPMService]
	@UnitNum Varchar(10),	
	@PMService Char(10),
	@ServiceDate Varchar(24),
	@CurrKm Varchar(10),
	@ServicePerformedBy Varchar(30),
	@DocumentNumber Varchar(30),
	@Remarks Varchar(50),
	@LastUPdatedBy Varchar(30)
	
	
AS
DECLARE @iUnitNum Integer
	SELECT @iUnitNum = Convert(Int, NULLIF(@UnitNum,""))
	INSERT INTO PM_service_History
	    (Unit_Number, 
		Service_Code, 
		Service_Date, 
		KM_Reading, 
		Service_Performed_By, 
		Document_Number, 
		Remarks,
		Last_Updated_By,
		Last_Updated_On)
		
	VALUES(@iUnitNum,
		 NULLIF(@PMService,""),
		 Convert(Datetime, NULLIF(@ServiceDate,"")),
		 Convert(Int, NULLIF(@CurrKm,"")),
		 NULLIF(@ServicePerformedBy,""),
		 NULLIF(@DocumentNumber,""),
		 NULLIF(@Remarks,""),
		 NULLIF(@LastUPdatedBy,""),
		 getdate()
		 )
		 
	RETURN @iUnitNum













GO
