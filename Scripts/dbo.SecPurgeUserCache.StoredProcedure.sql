USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[SecPurgeUserCache]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO







-------------------------------------------------------------------------------------------------------------------
----  Programmer:  Jack Jian
----  Date: 	 Jan 27, 2002
----  Details:	 purge time-out user hash
-------------------------------------------------------------------------------------------------------------------

CREATE proc [dbo].[SecPurgeUserCache]
	 @offset int
as

	declare @err_code int

	set nocount on
	set xact_abort on

	create table #hashs_4_delete (
		user_hash uniqueidentifier not null primary key
	)

	begin tran

		declare @base_time datetime
		set @base_time = DATEADD(mi,-1 * @offset, getdate())
	
		insert into #hashs_4_delete
		select user_hash from gisusercache where last_updated_on < @base_time --and user_id<>'sbelzberg'   

		delete gisusercache
		from gisusercache uc, #hashs_4_delete d
		where	uc.user_hash = d.user_hash

	commit tran
	return 0

ErrorHandler:
	rollback tran
	return 1






GO
