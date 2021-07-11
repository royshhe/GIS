USE [GISData]
GO
/****** Object:  View [dbo].[Vehicle_Purchase_Invovice_vw]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[Vehicle_Purchase_Invovice_vw]
As
-- Used by Lasherfiche
SELECT     V.Unit_Number, VMY.Model_Name, VMY.Model_Year, Dealer.Dealer, Manufacturer.Manufacturer, V.Serial_Number, dbo.FA_Dealer.Vendor_Code
FROM         dbo.Vehicle V INNER JOIN
                      dbo.Vehicle_Model_Year VMY ON V.Vehicle_Model_ID = VMY.Vehicle_Model_ID INNER JOIN
                          (SELECT     Code Manufacturer_ID, Value Manufacturer
                            FROM          Lookup_Table
                            WHERE      Category = 'Manufacturer') Manufacturer ON VMY.Manufacturer_ID = Manufacturer.Manufacturer_ID INNER JOIN
                          (SELECT     Code Dealer_ID, Value Dealer
                            FROM          Lookup_Table
                            WHERE      Category = 'Dealer') Dealer ON V.Dealer_ID = Dealer.Dealer_ID LEFT OUTER JOIN
                      dbo.FA_Dealer ON V.Dealer_ID = dbo.FA_Dealer.Dealer_Code
GO
