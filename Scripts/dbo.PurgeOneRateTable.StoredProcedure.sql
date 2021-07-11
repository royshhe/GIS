USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[PurgeOneRateTable]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Date :	   	Sept 29,  2004
--Details:	This sp is used to purge one rate-related table based on the records in Contract and Researvation tables. 
--		The rate related table must have following fields:  Rate_Id, Effective_date and Termination_date
--		The purge rule is:  
--			1)    Contract and Researvations tables are already purged clean
--			2)   compare  each  record  with outdated termination date in purging table with both Contract and
--			    Researvation Tables , if there is no record with assigned date being between effective date and 
--			    Termination date, this record in purging table should be removed to its archive table
--		The example tables inculde :  Wehicle_rate,  Rate_Availability, .........
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[PurgeOneRateTable] 

@TableName varchar(20)

 AS

set nocount on

--if the tablename is not here then exit 
exec ( 'if not exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[' + @tableName + ']'') and OBJECTPROPERTY(id, N''IsUserTable'') = 1) 
		  return -1
	')
              
 --to create a new archive table , if exists, use it
exec ( 'if not exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[' + @tableName + '_arc]'') and OBJECTPROPERTY(id, N''IsUserTable'') = 1)
	select * into [dbo].[' + @tableName + '_arc] from  ' + 
        @TableName + '  where rate_id= -1'
      )  


--since cursor processing is slow, we can do some SQL processing first to save time
-- we can remove all rate_id records with maxmium termination date less than current 
--dates and no records in Contract and Reservation tables related to them ( all records
-- with that rate_id should be removed)

--create a temporary table,  since  real temporary table doesn't work with dynamic sql processing, 
--a normal table is created here, which will be dropped at the end 
if  exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[MyTemptable]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table  dbo.MyTemptable

exec ( 'select tn.rate_id into MyTemptable  from ' +  @TableName + '  tn 
where tn.rate_id not in (select a.rate_id from ' + @TableName + '  a inner join contract b on a.rate_id=b.rate_id ) 
and tn.rate_id not in (select a.rate_id from ' + @TableName + '  a inner join reservation b on a.rate_id=b.rate_id)
group by tn.rate_id
having max(termination_date)<=getdate()' )

--make a copy to archive table
--exec ('insert into ' + @tablename + '_arc select * from '+ @Tablename + ' where rate_id in (select distinct rate_id from MyTemptable)')

--delete from @TableName table
exec('delete from ' + @TableName + ' where exists ( select * from MyTemptable
 where ' + @TableName + '.rate_id=rate_id)')

drop table MyTemptable

--Now do cursor processing  (above processing could be removed if time comsuming is not a concern)
DECLARE @RateId int
DECLARE @EffectiveDate datetime
Declare @TerminationDate datetime

exec('DECLARE My_cursor CURSOR FOR 
SELECT Rate_Id, Effective_date, Termination_date FROM ' + @TableName + ' 
OPEN My_cursor ')

FETCH NEXT FROM My_cursor 
INTO @RateId, @EffectiveDate, @TerminationDate

-- Check @@FETCH_STATUS to see if there are any more rows to fetch.
WHILE @@FETCH_STATUS = 0

BEGIN

--if there is a contract/reservation with assigned date in this rate_id peroid then keep it
-- otherwise, remove it if the termination_date is less than the current date
if @TerminationDate<=getdate() 
    	and not exists(select distinct rate_id from reservation where rate_id=@rateid and 
	date_rate_assigned >= @EffectiveDate and date_rate_assigned<=@TerminationDate )
	and not exists(select distinct rate_id from contract where rate_id=@rateid and 
	rate_assigned_date >= @EffectiveDate and rate_assigned_date<=@TerminationDate )

	begin  -- delete this record
		
	--make a copy

	declare @sql varchar(500)
	
	/*set @SQL=' insert into '+ @TableName + '_arc select * from ' + @TableName + ' where rate_id= ' + 'convert(int, '''+ convert(varchar(10), @RateId) +''' )' +' and effective_Date=' + 
	 ' convert(datetime, '''+ convert(char(25), @EffectiveDate, 13 ) +''')'  + ' and termination_date= convert(datetime, '''+ convert(char(25), @TerminationDate,13) +''')' 
	    exec(@sql)
	*/

		--delete this record
	set @SQL= ' delete from ' + @Tablename + ' where rate_id= ' + 'convert(int, '''+ convert(varchar(10), @RateId) +''' )' +' and effective_Date=' + 
	                 ' convert(datetime, '''+ convert(varchar(25),@EffectiveDate,13) +''')'  + ' and termination_date= convert(datetime, '''+ convert(varchar(25),@TerminationDate,13) +''')'
	exec( @SQL)
	
	end

   -- This is executed as long as the previous fetch succeeds.
   FETCH NEXT FROM My_cursor
   INTO @RateId, @EffectiveDate, @TerminationDate


END

CLOSE My_cursor
DEALLOCATE My_cursor

return 1

GO
