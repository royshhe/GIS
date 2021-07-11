USE [GISData]
GO
/****** Object:  View [dbo].[VOC_Vehicle]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO







/****** Object:  View dbo.VOC_Vehicle    Script Date: 2/18/99 12:11:39 PM ******/
/****** Object:  View dbo.VOC_Vehicle    Script Date: 2/16/99 2:05:38 PM ******/
CREATE VIEW [dbo].[VOC_Vehicle] AS
	SELECT  VOC.Contract_Number, 
		VOC.Unit_Number, 
		VOC.Checked_Out, 
		VOC.Actual_Check_In, 
		VOC.Expected_Check_In, 
		V.Current_Licence_Plate, 
		V.Owning_Company_Id
	FROM	Vehicle_On_Contract VOC, 
		Vehicle V
	WHERE	VOC.Unit_Number = V.Unit_Number







GO
