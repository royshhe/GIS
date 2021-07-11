USE [GISData]
GO
/****** Object:  View [dbo].[Vehicle_Total_PFD_Days_vw]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[Vehicle_Total_PFD_Days_vw]
AS

SELECT     Unit_Number, SUM(
													DATEDIFF(d, PFDFrom, 
																	(Case When PFDTo is not Null  Then PFDTo
																			Else Getdate()
																	End)
													)
										) AS PFDDays, max(PFDFrom) LastPFDDate
FROM         dbo.Vehicle_PullForDisposal_Periods_vw
WHERE    --(HeldTo IS NOT NULL) AND 
(DATEDIFF(d, PFDFrom, 
						(Case When PFDTo is not Null  Then PFDTo
							Else Getdate()
						End)
					) >= 0
)
GROUP BY Unit_Number


GO
