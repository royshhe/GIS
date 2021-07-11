USE [GISData]
GO
/****** Object:  View [dbo].[BellBCDTrans]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[BellBCDTrans]
as

Select Con.Contract_Number, (CASE WHEN Con.BCD_Rate_Organization_id IS NOT NULL 
                      THEN Con.Organization WHEN res.BCD_number IS NOT NULL THEN res.Organization ELSE NULL END) AS Organization_Name,  
                      (CASE WHEN Con.BCD_Rate_Organization_id IS NOT NULL THEN Con.BCD_number WHEN res.BCD_number IS NOT NULL 
                      THEN res.BCD_number ELSE NULL END) AS BCD_numberfrom, Company_Name,
 Res.Confirmation_Number, Res.Status From
(SELECT  c.Contract_Number, c.Confirmation_Number,   c.First_Name, c.Last_Name, c.Pick_Up_Location_ID, c.Drop_Off_Location_ID, c.Pick_Up_On, 
 c.Company_Name,   BCD_Rate_Organization.Organization, o.Org_Type,   BCD_Rate_Organization.BCD_number , c.BCD_Rate_Organization_ID 
FROM         dbo.Contract AS c WITH (NOLOCK) LEFT OUTER JOIN
                      dbo.Organization AS o ON o.Organization_ID = c.Referring_Organization_ID LEFT OUTER JOIN
                      dbo.Organization AS BCD_Rate_Organization ON BCD_Rate_Organization.Organization_ID = c.BCD_Rate_Organization_ID 
 Where c.Pick_Up_On>='2009-01-01' and c.Pick_Up_On<='2009-07-01'
) Con

FULL OUTER JOIN
  (SELECT     dbo.Reservation.Confirmation_Number, dbo.Reservation.Status, dbo.Organization.BCD_Number, dbo.Organization.Organization
                FROM          dbo.Reservation LEFT OUTER JOIN
                                       dbo.Organization ON dbo.Reservation.BCD_Number = dbo.Organization.BCD_Number
  Where dbo.Reservation.Pick_Up_On>='2009-01-01' and dbo.Reservation.Pick_Up_On<='2009-07-01'
     ) Res ON 
          con.Confirmation_Number = Res.Confirmation_Number


WHERE     (Con.Company_Name LIKE '%Bell%') OR

                      (Con.BCD_Rate_Organization_ID IN
                          (SELECT     Organization_ID
                            FROM          dbo.Organization  
                            WHERE      (Organization LIKE 'Bell%'))) OR
                      (Con.BCD_Number  IN ('A161400', 'BCD 9001')) Or
                      (Res.Organization LIKE '%Bell%') OR
                      (Res.BCD_Number IN ('A161400', 'BCD 9001'))


 
GO
