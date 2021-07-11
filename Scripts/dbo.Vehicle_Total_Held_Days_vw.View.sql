USE [GISData]
GO
/****** Object:  View [dbo].[Vehicle_Total_Held_Days_vw]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create VIEW [dbo].[Vehicle_Total_Held_Days_vw]
AS

SELECT     Unit_Number, SUM(
													DATEDIFF(d, HeldFrom, 
																	(Case When HeldTo is not Null  Then HeldTo
																			Else Getdate()
																	End)
													)
										) AS HeldDays
FROM         dbo.Vehicle_Held_Periods_vw
WHERE    --(HeldTo IS NOT NULL) AND 
(		
				(
				     DATEDIFF(d, HeldFrom, 
											(Case When HeldTo is not Null  Then HeldTo
													Else Getdate()
											End)
				      )
				)>= 1
)
GROUP BY Unit_Number
GO
