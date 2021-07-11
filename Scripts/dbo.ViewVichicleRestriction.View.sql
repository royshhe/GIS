USE [GISData]
GO
/****** Object:  View [dbo].[ViewVichicleRestriction]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[ViewVichicleRestriction]
AS
SELECT DISTINCT 
                      dbo.Vehicle.Unit_Number AS [Unit No.], dbo.Lookup_Table.value as [Current Status],dbo.Vehicle.Program AS [Program ?], dbo.Lookup_Table.[Value] AS [Veh. Status], 
                      dbo.Vehicle.Do_Not_Rent_Past_Km AS [Do Not Rent KM], dbo.Vehicle.Turn_Back_Deadline AS [TB Date], 
                      dbo.Vehicle.Do_Not_Rent_Past_Days AS [Do Not Rent Days], dbo.Vehicle_Location_Restriction.Unit_Number AS [With Restricted Loc.], 
                      dbo.Vehicle.Maximum_Km AS [TB KM], dbo.Vehicle.Minimum_Days, dbo.Vehicle.Maximum_Days, dbo.Location.Location AS [CURRENT Loc.]
FROM         dbo.Lookup_Table INNER JOIN
                      dbo.Vehicle ON dbo.Lookup_Table.Code = dbo.Vehicle.Current_Vehicle_Status INNER JOIN
                      dbo.Location ON dbo.Vehicle.Current_Location_ID = dbo.Location.Location_ID LEFT OUTER JOIN
                      dbo.Vehicle_Location_Restriction ON dbo.Vehicle.Unit_Number = dbo.Vehicle_Location_Restriction.Unit_Number
WHERE      (dbo.Lookup_Table.Category = 'Vehicle status') 
		and (
			dbo.Vehicle.Unit_Number not in  
		      (103106 ,103689,  103690 ,  103691 , 
                       104044 ,  104046 ,  104047 , 
                       110407 ,  110612 ,  110614 , 
                       110616 ,  115440 ,  116406 , 
                       116411 ,  116416 ,  116418 , 
                       116425 ,  116429 ,  116430 , 
                       116431 ,  116432 ,  116438 , 
                       116465 ,  116466 ,  116467 , 
                       116471 ,  116474 ,  116476 , 
                       116493 ,  116507 ,  116510 , 
                       116513 ,  116523 ,  116524 , 
                       116533 ,  116547 ,  116551 , 
                       116554 ,  116558 ,  116609 , 
                       116611 ,  116613 ,  116615 , 
                       116616 ,  116653 ,  116654 , 
                       116659 ,  116671 ,  116673 , 
                       116675 ,  116676 ,  116680 , 
                       116681 ,  116689 ,  116821 , 
                       116827 ,  116829 ,  116831 , 
                       116839 ,  116843 ,  116904 , 
                       116957 ,  116958 ,  116961 , 
                       116967 ,  116974 ,  116990 , 
                       117003 ,  117014 ,  117078 , 
                       117144 ,  117147 ,  117151 , 
                       117155 ,  117166 ,  117170 , 
                       117186 ,  119184 ,  107784 , 
                       115489 ,  116960 ,  117176 , 
                       118135 ,  118629 ,  119032 , 
                       119122 ,  119567 , 
                       119589 ,  119662 ,  119961 , 
                       119584 ,  120647 ,  120672 , 
                       120803 )
		)

GO
