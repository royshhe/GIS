USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateTrackingRptTbl]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
--drop procedure createtrackingRptTbl
Create Procedure [dbo].[CreateTrackingRptTbl]
As
if exists (select * from sysobjects where id = object_id('tmp_contract')
 and OBJECTPROPERTY(id, 'IsUserTable')=1)
 drop table tmp_contract

if exists (select * from sysobjects where id=object_id('tmp_timecharge')
 and OBJECTPROPERTY(id, 'IsUserTable')=1)
 drop table tmp_timecharge

if exists (select * from sysobjects where id=object_id('tmp_kmcharge')
 and OBJECTPROPERTY(id, 'IsUserTable')=1)
  drop table tmp_kmcharge

if exists (select * from sysobjects where id=object_id('tmp_kmdriven')
 and OBJECTPROPERTY(id, 'IsUserTable')=1)
  drop table tmp_kmdriven

/* create report table */
create table tmp_contract
( contract_number int,
  actual_check_in datetime
)

create table tmp_timecharge
(
 contract_number int,
 tamount decimal(9,2)
)

create table tmp_kmcharge
( contract_number int,
  kamount decimal(9,2)
)

create table tmp_kmdriven
( contract_number int,
  kmdriven int,
  actualdays int
)

RETURN 

GO
