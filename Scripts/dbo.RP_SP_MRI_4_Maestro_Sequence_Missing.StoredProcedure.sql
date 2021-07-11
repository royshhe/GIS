USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_MRI_4_Maestro_Sequence_Missing]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO














/*
PROCEDURE NAME: RP_SP_MRI_1_Reservation_Error
PURPOSE: Select all the information needed for Maestro Reservation Error Report

AUTHOR:	Nenad Ukropina
DATE CREATED: 1999/01/01
USED BY: Maestro Reservation Error Report
MOD HISTORY:
Name 		Date		Comments
Joseph Tseung	Sep 24 1999	Add more filtering to improve performance
*/
/* add Rate_Name and BCD on Feb 18, 2005 , simon gong*/

CREATE PROCEDURE [dbo].[RP_SP_MRI_4_Maestro_Sequence_Missing]-- '2015/01/19 08:00','2015/01/20 08:00'
(	
	@FromDate varchar(24) = '1999/01/12 09:36',
	@ToDate varchar(24) = '1999/01/12 09:37'
)
AS

declare @Transaction_Date_Pre varchar(25),@Transaction_Date varchar(25), @Sequence_Number int,
		@Foreign_Confirm_Number varchar(20)
Declare @Current_Seq int, @SeqExist smallint
DECLARE @MissingString VARCHAR(1000)

DECLARE @dFrom datetime,
	@dTo datetime

SELECT 	@dFrom = CONVERT(datetime, @FromDate)
SELECT 	@dTo = CONVERT(datetime, @ToDate)

CREATE TABLE #Maestro_Seq_Missing(
	[Transaction_Date] [datetime] NOT NULL,
	[Missing_Sequence_Number] [char](20)NULL
) 

DECLARE ResSeq_cursor CURSOR FOR
select 
	Transaction_Date,        
	Sequence_Number ,
	--Confirmation_Number, 
	Foreign_Confirm_Number--,
	--GIS_Process_Date,
	--Update_Gis_Indicator
from maestro
where transaction_date between @dFrom and @dTo 
--and update_gis_indicator=1
group by Transaction_Date,        
	Sequence_Number ,
	--Confirmation_Number, 
	Foreign_Confirm_Number
order by transaction_date,sequence_number
	
OPEN ResSeq_cursor

select @Current_Seq=0
select @MissingString=''

FETCH NEXT FROM ResSeq_cursor
INTO @Transaction_Date,@Sequence_Number,@Foreign_Confirm_Number

select @Transaction_Date_Pre=@Transaction_Date
WHILE @@FETCH_STATUS = 0
BEGIN
   if @current_Seq=0 or @Sequence_Number=1
		begin
			 select  @Current_Seq=@Sequence_Number
		end

	--print cast(@Current_Seq as varchar(10)) + '-' + cast(@Sequence_Number as varchar(10))

   if  @Current_Seq<>@Sequence_Number 	
		Begin
			--select @MissingString=@MissingString+ cast(@Current_Seq as varchar(10)) + '-' + cast(@Sequence_Number-1 as varchar(10))+ ' // ' 
			if @Current_Seq=@Sequence_Number-1
				begin
					print @Transaction_Date_Pre
					print @Current_Seq
					select @SeqExist=count(*) from maestro where transaction_date =@Transaction_Date_Pre and Sequence_Number=@Current_Seq
					print 	@SeqExist
					if @SeqExist<=0 
						insert into #Maestro_Seq_Missing
							select @Transaction_Date,
									case when @Current_Seq=@Sequence_Number-1
											then cast(@Current_Seq as varchar(10))
										 else cast(@Current_Seq as varchar(10)) + '-' + cast(@Sequence_Number-1 as varchar(10))
									end as Missing_Sequence_Number
					end
				else
					begin
						insert into #Maestro_Seq_Missing
							select @Transaction_Date,
									case when @Current_Seq=@Sequence_Number-1
											then cast(@Current_Seq as varchar(10))
										 else cast(@Current_Seq as varchar(10)) + '-' + cast(@Sequence_Number-1 as varchar(10))
									end as Missing_Sequence_Number
					end
			select  @Current_Seq=@Sequence_Number
		end

   Select @Transaction_Date_Pre=@Transaction_Date

   FETCH NEXT FROM ResSeq_cursor
   INTO @Transaction_Date,@Sequence_Number,@Foreign_Confirm_Number
	 select  @Current_Seq=@Current_Seq+1
End

CLOSE ResSeq_cursor
DEALLOCATE ResSeq_cursor

select *
from #Maestro_Seq_Missing

drop table #Maestro_Seq_Missing
--Return @MissingString	
	


GO
