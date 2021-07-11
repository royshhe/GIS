USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[ChangeReservationToMonthly]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO




/*
PROCEDURE NAME: ChangeReservationToMonthly '34085484us6'
PURPOSE: To update a reservation

select * from reservation where foreign_confirm_number='34085484us6'

AUTHOR: Cindy Yee
DATE CREATED: ?
CALLED BY: Reservation
MOD HISTORY:
Name    Date        	Comments
Don K	Nov 4 1998 	Added new fields for Maestro
Dan M	Dec 7 1998	Added GuarDepAmount, CustCode, SwipedFlag
CPY     Jan 12 1998     Renamed phone number columns
Don K	Feb 4 1999	Convert blank to NULL for @IATA parameter
Don K	Mar 10 2000	Delete quoted rate AFTER removing reference on reservation.
*/
create PROCEDURE [dbo].[ChangeReservationToMonthly]
	@ConfirmNum		Varchar(20)
AS

update reservation 
	set pick_up_location_id=(select (case when r1.pick_up_location_id=16
										 then '194'
										 when r1.pick_up_location_id=20
										 then '195'
										 else r1.pick_up_location_id
									  end) as pick_up_location_id
								from reservation r1 
								where r1.foreign_confirm_number=@ConfirmNum
								),
		drop_off_location_id=(select (case when r2.drop_off_location_id=16
										 then '194'
										 when r2.drop_off_location_id=20
										 then '195'
										 else r2.drop_off_location_id
									  end) as drop_off_location_id
								from reservation r2 
								where r2.foreign_confirm_number=@ConfirmNum
								),
		vehicle_class_code=(select (case when r3.vehicle_class_code='A'
										 then '5'
										 when r3.vehicle_class_code='B'
										 then 'J'
										 when r3.vehicle_class_code='F'
										 then 'J'
										 when r3.vehicle_class_code='C'
										 then 'L'
										 when r3.vehicle_class_code='E'
										 then 'N'
										 when r3.vehicle_class_code='D'
										 then 'N'
										 when r3.vehicle_class_code='K'
										 then 'O'
										 when r3.vehicle_class_code='G'
										 then 'P'
										 when r3.vehicle_class_code='H'
										 then 'Q'
										 when r3.vehicle_class_code='X'
										 then 'R'
										 when r3.vehicle_class_code='V'
										 then 'Y'
										 when r3.vehicle_class_code='W'
										 then 'Z'
										 else r3.vehicle_class_code
									  end) as vehicle_class_code
								from reservation r3
								where r3.foreign_confirm_number=@ConfirmNum
								)
from reservation
where foreign_confirm_number=@ConfirmNum


GO
