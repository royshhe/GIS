USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctVehOnContractCurr]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*
PURPOSE: To retrieve vehicle currently attached to Contract from vehicle on contract.
	 - current vehicle is the latest VOC record
MOD HISTORY:
Name    Date        	Comments
CPY	Jan 25 2000	Changed the order by use business_transaction_id desc
*/
CREATE PROCEDURE [dbo].[GetCtrctVehOnContractCurr]
	@ContractNum Varchar(10)
AS
	/* 02/16/99 - cpy - get vehicle currently attached to Contract from VOC
			  - current vehicle is the latest VOC record */
	/* Nov 01 - Moved data conversion code with NULLIF out of the where clause */

	SET ROWCOUNT 1

	DECLARE	@nContractNum Integer
	SELECT	@nContractNum = Convert(Int, NULLIF(@ContractNum,""))

	SELECT	VOC.Unit_Number,
		V.Vehicle_Class_Code,
		Convert(Varchar(1), VMY.Diesel),
		v.current_licencing_prov_state,
		l.City,
		l.LocationName 

	FROM	Vehicle_On_Contract VOC,
		Vehicle_Model_Year VMY,
		Vehicle V,
		location L

	WHERE	VOC.Contract_Number = @nContractNum
	AND	VOC.Unit_Number = V.Unit_Number
	AND	V.Vehicle_Model_Id = VMY.Vehicle_Model_Id
	and voc.Pick_Up_Location_ID=l.Location_id
	ORDER BY 
		--VOC.Checked_Out DESC, 
		VOC.Business_Transaction_Id DESC

	RETURN @@ROWCOUNT
GO
