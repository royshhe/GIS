USE [GISData]
GO
/****** Object:  View [dbo].[Contract_Vehicle_PST_Rate_vw]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Contract_Vehicle_PST_Rate_vw]
AS
SELECT				dbo.Contract.Contract_Number, 
                    dbo.Vehicle_On_Contract.actual_vehicle_class_code,
					vmy.pst_rate as PST,--dbo.Vehicle_Class.PST,
					dbo.Vehicle_On_Contract.checked_out as PickUpDate,
					case when dbo.Vehicle_On_Contract.actual_check_in is null 
							then dbo.Vehicle_On_Contract.expected_check_in
							else dbo.Vehicle_On_Contract.actual_check_in
					end as DropOffDate
--select *
FROM         dbo.Contract INNER JOIN
                      dbo.Vehicle_On_Contract ON dbo.Contract.Contract_Number = dbo.Vehicle_On_Contract.Contract_Number
				--inner join dbo.Vehicle_Class on dbo.Vehicle_On_Contract.actual_vehicle_class_code=dbo.Vehicle_Class.vehicle_class_code
					inner join dbo.vehicle V on v.unit_number=dbo.Vehicle_On_Contract.unit_number
					inner join dbo.vehicle_model_year vmy on v.vehicle_model_id=vmy.vehicle_model_id
GO
