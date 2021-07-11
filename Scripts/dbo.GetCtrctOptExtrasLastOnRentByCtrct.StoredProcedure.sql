USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctOptExtrasLastOnRentByCtrct]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
PURPOSE: 	To retrieve the optional extra information for the given contract.
		otherwise, return only the most current one.
MOD HISTORY:
Name    Date        Comments
Roy He 20-10
*/

  
CREATE PROCEDURE [dbo].[GetCtrctOptExtrasLastOnRentByCtrct]  --1316248
	@ContractNumber		VarChar(10)

AS
	
DECLARE @iCtrctNum Int,
	@dTermDate Datetime

	SELECT	@iCtrctNum = CONVERT(Int, NULLIF(@ContractNumber, '')),
		@dTermDate = CONVERT(DateTime, 'Dec 31 2078')

  
	SELECT	Distinct
		COE.Optional_Extra_ID,
		OEO.Optional_Extra,		
		COE.Unit_Number,	
		COE.Rent_From,
		LastCOE.Rent_To,	
		OEO.Type	
--select *
	FROM		Contract_Optional_Extra COE Inner Join 
	  Optional_Extra_Other OEO  on COE.Optional_Extra_ID = OEO.Optional_Extra_ID
		Inner Join Contract CON on  CON.Contract_Number = COE.Contract_Number
      Inner Join 
	  (SELECT	Distinct
				COE.Optional_Extra_ID,
				OEO.Optional_Extra,				
				Max(Rent_To) Rent_To,	
				OEO.Type	
			FROM		Contract_Optional_Extra COE Inner Join 
				Optional_Extra_Other OEO  on COE.Optional_Extra_ID = OEO.Optional_Extra_ID	 
				
				 
			WHERE	COE.Contract_Number = @iCtrctNum	 	 
			AND	COE.Termination_Date >= getdate() 
		   Group By COE.Optional_Extra_ID,
				OEO.Optional_Extra,		OEO.Optional_Extra,OEO.Type			
	) LastCOE	 
	On COE.Optional_Extra_ID=LastCOE.Optional_Extra_ID And COE.Rent_To=LastCOE.Rent_To
		 
	WHERE	COE.Contract_Number = @iCtrctNum	 	 
	AND	COE.Termination_Date >= getdate() and COE.Rent_To>Rent_From
	AND COE.Status='CO'
	AND  COE.Rent_To>= CON.Drop_Off_On and coe.quantity<>0
   	ORDER BY 
		OEO.Optional_Extra	 Desc

	RETURN @@ROWCOUNT

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON


--select * from Contract_Optional_Extra where contract_number=1316248
GO
