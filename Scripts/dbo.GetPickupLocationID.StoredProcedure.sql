USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetPickupLocationID]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO













/****** Object:  Stored Procedure dbo.GetPickupLocationID    Script Date: 2/18/99 12:12:09 PM ******/
/****** Object:  Stored Procedure dbo.GetPickupLocationID    Script Date: 2/16/99 2:05:42 PM ******/
CREATE PROCEDURE [dbo].[GetPickupLocationID]--'102428'
	@ContractNum	VarChar(10)
AS
SELECT
	Pick_Up_Location_ID,
	Pick_Up_On
FROM
	Contract
WHERE
	Contract_Number = Convert(int,@ContractNum)
RETURN 1













GO
