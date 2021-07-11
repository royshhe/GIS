USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetNonGISRateDropOffCharge]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetNonGISRateDropOffCharge    Script Date: 2/18/99 12:11:46 PM ******/
/****** Object:  Stored Procedure dbo.GetNonGISRateDropOffCharge    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetNonGISRateDropOffCharge    Script Date: 1/11/99 1:03:16 PM ******/
CREATE PROCEDURE [dbo].[GetNonGISRateDropOffCharge]
	@QuotedRateId Varchar(10)
AS
	SELECT
		QVR.Authorized_DO_Charge
	FROM
		Quoted_Vehicle_Rate QVR
	WHERE
		QVR.Quoted_Rate_Id = Convert(Int, @QuotedRateId)
	RETURN @@ROWCOUNT












GO
