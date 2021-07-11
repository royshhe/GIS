USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetVehicleRateSearchData]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/*
PURPOSE: To search and retrieve vehicle rates by the given params:
		- rate name 
		- availability dates between ValidFrom and ValidTo
		- purpose
		- PickUpLocation is a valid pick up location
		- DropOffLocation is a valid drop off location. 
		  If PickUpLocation is also supplied, then DropOffLocation
		  must be a valid drop off location for that PickUpLocation.
	 If one or more params is supplied, then all params must be matched
	 in order for a row to be returned.
MOD HISTORY:
Name	Date        	Comments
Don K	Mar 21 2000	Fixed join structure to avoid cross product when pick 
			up & drop off are specified 
*/

CREATE PROCEDURE [dbo].[GetVehicleRateSearchData]
	@RateName varchar(20),
	@ValidFrom varchar(20),
	@ValidTo varchar(20),
	@Purpose varchar(35),
	@PickUpLocation varchar(35),	-- location name
	@DropOffLocation varchar(35)	-- location name
AS
Set Rowcount 2000

	/* 02-Nov-99 - do type conversion and nullif outside of select */
	/* 09-Nov-99 - bug fix - was not defaulting ValidFrom and ValidTo to 
			proper dates */

DECLARE	@dValidFrom Datetime, 
	@dValidTo Datetime, 
	@dBeginDate Datetime, 
	@dEndDate Datetime,
	@sPickUpLocation Varchar(36),
	@sDropOffLocation Varchar(36), 
	@sRateName Varchar(21),
	@sPurpose Varchar(36)

SELECT	@dValidFrom = Convert(Datetime, NULLIF(@ValidFrom,'')),
	@dValidTo = Convert(Datetime, NULLIF(@ValidTo,'')), 
	@dBeginDate = Convert(Datetime, 'Jan 01 1900 00:00'), 
	@dEndDate = Convert(Datetime, 'Dec 31 2078 23:59'),
	@sPickUpLocation = @PickUpLocation + '%',
	@sDropOffLocation = @DropOffLocation + '%',
	@sRateName = LTrim(@RateName + '%'),
	@sPurpose = LTrim(@Purpose + '%')

Select Distinct
	VR.Rate_ID,
	VR.Rate_Name,
	RA.Valid_From,
	RA.Valid_To,
	RP.Rate_Purpose,
	VR.Contract_Remarks
From
	Vehicle_Rate VR,
	Rate_Purpose RP,
	Rate_Availability RA
Where
	VR.Termination_Date = @dEndDate
	And VR.Rate_Name Like @sRateName
	And RP.Rate_Purpose Like @sPurpose
	And VR.Rate_Purpose_ID = RP.Rate_Purpose_ID
	And RA.Termination_Date = @dEndDate
	-- if ValidFrom and ValidTo are provided, match them against Valid_From and Valid_To
	And ISNULL(RA.Valid_To, @dEndDate) >= ISNULL(@dValidFrom, @dBeginDate)
	And Convert(datetime, (Convert(varchar(11), RA.Valid_From) + ' 00:00')) <= ISNULL(@dValidFrom, @dEndDate)
	And ISNULL(RA.Valid_To, @dEndDate) >= ISNULL(@dValidTo, @dBeginDate)
	And Convert(datetime, (Convert(varchar(11), RA.Valid_From) + ' 00:00')) <= ISNULL(@dValidTo, @dEndDate)
	And VR.Rate_ID = RA.Rate_ID
	And
		((@PickupLocation = '')
		Or
			(@PickupLocation <> '' And @DropOffLocation <> '')
		Or
			/* only matching by PickUpLocation; retrieve rates that have 
			   this sPickUpLocation defined as a valid pick up loc */
			(@PickupLocation <> '' And @DropOffLocation = ''
			And
				VR.Rate_ID In
					(Select
						RLSM.Rate_ID
					From
						Rate_Location_Set_Member RLSM, Location L
					Where
						RLSM.Termination_Date = @dEndDate
						And L.Location Like @sPickUpLocation
						And RLSM.Location_ID = L.Location_ID)))
	And
		((@DropoffLocation = '')
		Or
			(@DropOffLocation <> '' And @PickupLocation <> '')
		Or
			/* only matching by DropOffLocation; retrieve rates that either allow
			   all drop off locs or have this sDropOffLocation defined as a 
			   valid pick up loc */
			(@DropoffLocation <> '' And @PickupLocation = ''
			And
				VR.Rate_ID In
					(Select
						RDOL.Rate_ID
					From
						Rate_Drop_Off_Location RDOL, Location L,
						Rate_Location_Set RLS
					Where
						RDOL.Termination_Date = @dEndDate
						And RLS.Rate_Location_Set_ID = RDOL.Rate_Location_Set_ID
						And RLS.Rate_ID = RDOL.Rate_ID
						And
							((RLS.Allow_All_Auth_Drop_Off_Locs = 1)
							Or
								(RLS.Allow_All_Auth_Drop_Off_Locs = 0
								And L.Location Like @sDropOffLocation
								And RDOL.Location_ID = L.Location_ID)))))
	And
		((@PickupLocation = '' Or @DropOffLocation = '')
		Or
			/* matching by PickUpLocation and DropOffLocation;
			   retrieve rates that have this sPickUpLocation defined as a 
			   valid pick up loc and either 
				- allow all drop off locs or 
				- have this sDropOffLocation defined as a valid drop off loc */
			(@PickupLocation <> '' And @DropoffLocation <> ''
			And
				VR.Rate_ID In
					(Select
						RLS.Rate_ID
					From
						Rate_Location_Set_Member RLSM,
						Location L1,
						Rate_Location_Set RLS
					Left
					Join
							Rate_Drop_Off_Location RDOL
						Join	Location L2
						On	L2.Location_ID = RDOL.Location_ID
							And L2.Location Like @sDropOffLocation 
					On
						RDOL.Termination_Date = @dEndDate
						And RLS.Rate_Location_Set_ID = RDOL.Rate_Location_Set_ID
						And RLS.Rate_ID = RDOL.Rate_ID
					Where
						RLS.Termination_Date = @dEndDate
						
						And RLSM.Termination_Date = @dEndDate
						And L1.Location Like @sPickUpLocation
						And RLSM.Location_ID = L1.Location_ID
						And RLS.Rate_Location_Set_ID = RLSM.Rate_Location_Set_ID
						And RLSM.Rate_ID = RLS.Rate_ID

						And (  (RLS.Allow_All_Auth_Drop_Off_Locs = 1)
						    Or RDOL.Location_ID IS NOT NULL
						    )
					)
			)
		)
Order By VR.Rate_Name

Return 1


GO
