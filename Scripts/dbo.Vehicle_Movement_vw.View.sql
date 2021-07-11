USE [GISData]
GO
/****** Object:  View [dbo].[Vehicle_Movement_vw]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Vehicle_Movement_vw]
AS
SELECT	
	VM.Unit_Number, 
	VM.Movement_Out Time_Out,
	ISNULL(VM.Movement_In, OMC.Movement_In) Time_In, 		
	VM.Sending_Location_ID Location_Out,
	VM.Receiving_Location_ID Location_In,
	VM.Movement_Type Movement_Type
	FROM	Vehicle_Movement VM 		
	LEFT JOIN Override_Movement_Completion OMC
  	ON VM.Unit_Number = OMC.Unit_Number
 	AND VM.Movement_Out = OMC.Movement_Out	

UNION
	
	SELECT	VOC.Unit_number,		
	VOC.Checked_Out Time_Out,	
	Time_In =
	CASE
		WHEN VOC.Actual_Check_In IS NULL THEN			
			(SELECT	CASE 
				WHEN OCI.Check_In IS NULL THEN
					CONVERT(Varchar, VOC.Expected_Check_In, 108)
				ELSE
					CONVERT(VarChar, OCI.Check_In, 108)
			 	END)
		ELSE
			CONVERT(VarChar, VOC.Actual_Check_In, 108)
		END,		
	LocOut.Location_ID Location_Out,
	LocIn.Location_ID Location_In,
	CONVERT(VarChar, VOC.Contract_Number) Movement_Type
		
	FROM	Vehicle_On_Contract VOC WITH(NOLOCK)
		JOIN Location LocOut
		  ON VOC.Pick_Up_Location_ID = LocOut.Location_ID
		JOIN Location LocIn
		  ON ((VOC.Expected_Drop_Off_Location_ID = LocIn.Location_ID 
				AND VOC.Actual_Drop_Off_Location_ID IS NULL)
			OR
		      (VOC.Actual_Drop_Off_Location_ID = LocIn.Location_ID 
				AND NOT VOC.Actual_Drop_Off_Location_ID IS NULL))
		LEFT JOIN Override_Check_In OCI
		  ON VOC.Unit_Number = OCI.Unit_Number
		 AND VOC.Checked_Out = OCI.Checked_Out
		 And VOC.Contract_number=OCI.Overridden_Contract_Number
	










GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1[50] 2[25] 3) )"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1 [56] 4 [18] 2))"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      RowHeights = 220
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Vehicle_Movement_vw'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Vehicle_Movement_vw'
GO
