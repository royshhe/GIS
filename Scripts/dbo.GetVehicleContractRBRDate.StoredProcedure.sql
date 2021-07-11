USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetVehicleContractRBRDate]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetVehicleContractRBRDate    Script Date: 2/18/99 12:12:17 PM ******/
/****** Object:  Stored Procedure dbo.GetVehicleContractRBRDate    Script Date: 2/16/99 2:05:43 PM ******/
CREATE PROCEDURE [dbo].[GetVehicleContractRBRDate]
@ContractNumber varchar(10)
AS
Declare @thisCheckedOutDate datetime
Select @thisCheckedOutDate =
	(Select
		Min(Checked_Out)
	From
		Vehicle_On_Contract
	Where
		Contract_Number = Convert(int, @ContractNumber)
		And Checked_Out <> ISNULL(Actual_Check_In, ''))


	SELECT
		 Convert(Varchar(20), Max(RBR_Date),106)--RBR_Date
	FROM
		RBR_Date
	WHERE
		@thisCheckedOutDate BETWEEN Budget_Start_Datetime AND ISNULL(Budget_Close_Datetime, '31 Dec 2078')	  
RETURN @@ROWCOUNT

GO
