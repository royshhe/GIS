USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[PurgeGISRates]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[PurgeGISRates]
as

--------------------------------------------------------
--Processing Vehicle_rate
----------------------------------------------------------
print 'Processing Vehicle_rate'
exec  PurgeOneRateTable Vehicle_Rate

--------------------------------------------------------
--Processing Rate_Availability
----------------------------------------------------------
print 'Processing Rate_Availability'
exec PurgeOneRateTable Rate_Availability

--------------------------------------------------------
--Processing Rate_Charge_Amount
----------------------------------------------------------
print 'Processing Rate_Charge_Amount'
exec PurgeOneRateTable Rate_Charge_Amount

--------------------------------------------------------
--Processing Rate_Drop_Off_Location
----------------------------------------------------------
print 'processing Rate_Drop_Off_Location'
 exec PurgeOneRateTable Rate_Drop_Off_Location

--------------------------------------------------------
--Processing Rate_LOR
----------------------------------------------------------
print 'Processing Rate_LOR'
exec  PurgeOneRateTable Rate_LOR

--------------------------------------------------------
--Processing Rate_Level
----------------------------------------------------------
print 'Processing Rate_Level'
exec PurgeOneRateTable Rate_Level

--------------------------------------------------------
--Processing Rate_Location_Set

----------------------------------------------------------
print 'Processing Rate_Location_Set'
exec PurgeOneRateTable Rate_Location_Set

--------------------------------------------------------
--Processing Rate_Location_Set_Member
----------------------------------------------------------
print 'Processing Rate_Location_Set_Member  '
exec PurgeOneRateTable Rate_Location_Set_Member
--------------------------------------------------------
--Processing Rate_Restriction

----------------------------------------------------------
print '  Processing Rate_Restriction'
exec PurgeOneRateTable Rate_Restriction
--------------------------------------------------------
--Processing Rate_Time_Period

----------------------------------------------------------
print 'Processing Rate_Time_Period'
exec  PurgeOneRateTable Rate_Time_Period
--------------------------------------------------------
--Processing Rate_Vehicle_Class

----------------------------------------------------------
print 'Processing Rate_Vehicle_Class  '
exec PurgeOneRateTable Rate_Vehicle_Class
GO
