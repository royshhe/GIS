USE [GISData]
GO
/****** Object:  View [dbo].[tempplate]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

create view [dbo].[tempplate] as
select *
from vehicle v, vehicle_licence vl
where vl.Licence_Plate_Number = v.current_licence_plate 
and v.Owning_Company_ID = 7425

GO
