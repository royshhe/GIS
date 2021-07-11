USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetValidClasses]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetValidClasses    Script Date: 2/18/99 12:11:57 PM ******/
/****** Object:  Stored Procedure dbo.GetValidClasses    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.GetValidClasses    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.GetValidClasses    Script Date: 11/23/98 3:55:34 PM ******/
CREATE PROCEDURE [dbo].[GetValidClasses]
@VehicleType varchar(20)
AS
Set Rowcount 2000
Select Distinct
	Vehicle_Class_Name,Vehicle_Class_Code
From
	Vehicle_Class
Where
	Vehicle_Type_ID=@VehicleType
Order By Vehicle_Class_Name
Return 1












GO
