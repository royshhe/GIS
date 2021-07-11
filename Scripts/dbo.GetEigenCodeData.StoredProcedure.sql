USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetEigenCodeData]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetEigenCodeData    Script Date: 2/18/99 12:11:45 PM ******/
/****** Object:  Stored Procedure dbo.GetEigenCodeData    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetEigenCodeData    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetEigenCodeData    Script Date: 11/23/98 3:55:33 PM ******/
/*  PURPOSE:		To retrieve the Description from Eigen_Code for the given parameters.
     MOD HISTORY:
     Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetEigenCodeData]
@Type varchar(10),
@Code varchar(10)
AS
Set Rowcount 2000
Select
	Description
From
	Eigen_Codes
Where
	Type = @Type
	And Code = @Code
Return 1













GO
