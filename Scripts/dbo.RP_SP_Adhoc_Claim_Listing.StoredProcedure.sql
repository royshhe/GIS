USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Adhoc_Claim_Listing]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO










CREATE PROCEDURE [dbo].[RP_SP_Adhoc_Claim_Listing] --'01 may 2015', '28 jul 2015' ,'0'

(
	@paramStartDate varchar(20) = '15 April 1999',
	@paramEndDate varchar(20) = '15 April 1999',
	@paramOptions varchar(1)='0'		--0 is all,1 is only outstanding listing,other is Billing Audit
)
AS
-- convert strings to datetime
DECLARE
	@startDate datetime,
	@endDate datetime

SELECT	
	@startDate	= CONVERT(datetime, @paramStartDate),
	@endDate	= CONVERT(datetime, @paramEndDate)	

if @paramOptions='0' --or @paramOptions='1'
	begin
		select	a.file_no,
				a.unit_no,
				veh.vehicle_class_name,
				contract_n,
				 case when lt.value like '2-LDW Ded $' 
							then rtrim(lt.value) +  replace(ltrim(rtrim(a.cover_amt)),'$','')
							else lt.value
				end  as CoverageValue,

				Accid_date,
				Model,
				case when Liability='1'
							then 'Renter'
					 when Liability='2'
							then 'Third Party'
					 when Liability='3'
							then 'Employee'
					 when Liability='4'
							then 'Hit and Run'
					 when Liability='5'
							then 'Stolen'
					 when Liability='6'
							then 'Vandals'
					 when Liability='8'
							then 'Not Determined'
					 when rtrim(ltrim(Liability))=''
							then ''
					 when Liability='7' 
							then 'Others'	
						else 	Liability
				end as Liability,
--				(Case When ISNUMERIC(replace(replace(NULLIF(Dam_amt_es,''), '$',''),',',''))=0 Then '0'
--					--Else Convert(decimal(9,2),replace(replace(NULLIF(Dam_amt_es,''), '$',''),',','') )
--					Else convert(varchar(30),Dam_amt_es	)
--				End) as Estimate,
				convert(varchar(30),Dam_amt_es	)as Estimate,
				a.billedamt as Billed,
--				 (a.billedamt-a.paid_amt) as Outstanding, 
				a.paid_amt as PaidAmount,
				a.ppoi,
				case when status='O'
						then 'Open'
					 when status='C'
						then 'Close'
					 else ''
				end as Status,
				filecreatedby,
				postdate,
				lastmodified,
				case when con.location is not null 
						then con.location
					 else a.location	
				end as location	,	
				remarks2,
				br.result
				
		--select *	from svbvm007.cars.dbo.amaster where Dam_amt_es<>''
		 --and Dam_amt_es is not null and   ISNUMERIC(Dam_amt_es)=0
			 
		from svbvm007.cars.dbo.amaster a left join svbvm007.cars.dbo.Lookup_table lt on  a.Cover_code=lt.Code and lt.Category='Coverage'      
				left join
			 (select contract_number,l.Location 
				from contract c inner join location l 
				on c.pick_up_location_id=l.location_id) con on a.contract_N=con.contract_number
				left join 
					(select file_no,(select dbo.concate (file_no))as result
						from svbvm007.cars.dbo.BillingRemarks 
						group by file_no) BR
						on a.file_no=br.file_no	
				left join (

						SELECT     VC.Vehicle_Class_Name, V.Unit_Number
						FROM         dbo.Vehicle AS V INNER JOIN
											 dbo.Vehicle_Class AS VC ON V.Vehicle_Class_Code = VC.Vehicle_Class_Code

			   ) Veh On a.UNIT_NO=Convert(Varchar(30), Veh.Unit_Number)
				
		WHERE postdate BETWEEN @startDate AND @endDate
			and (@paramOptions='0' or (a.billedamt-a.paid_amt)<>0)
		 order by a.file_no
	end

	Else 
		Begin
		--------------
		if @paramOptions='1'
		begin
			select	a.file_no,
					a.unit_no,
					veh.vehicle_class_name,
					contract_n,
					 case when lt.value like '2-LDW Ded $' 
								then rtrim(lt.value) +  replace(ltrim(rtrim(a.cover_amt)),'$','')
								else lt.value
					end  as CoverageValue,

					Accid_date,
					Model,
					case when Liability='1'
								then 'Renter'
						 when Liability='2'
								then 'Third Party'
						 when Liability='3'
								then 'Employee'
						 when Liability='4'
								then 'Hit and Run'
						 when Liability='5'
								then 'Stolen'
						 when Liability='6'
								then 'Vandals'
						 when Liability='8'
								then 'Not Determined'
						 when rtrim(ltrim(Liability))=''
								then ''
						 when Liability='7' 
								then 'Others'	
							else 	Liability
					end as Liability,
	--				(Case When ISNUMERIC(replace(replace(NULLIF(Dam_amt_es,''), '$',''),',',''))=0 Then '0'
	--					--Else Convert(decimal(9,2),replace(replace(NULLIF(Dam_amt_es,''), '$',''),',','') )
	--					Else convert(varchar(30),Dam_amt_es	)
	--				End) as Estimate,
					convert(varchar(30),Dam_amt_es	)as Estimate,
					a.billedamt as Billed,
					 (a.billedamt-a.paid_amt) as Outstanding, 
					--a.paid_amt as PaidAmount,
					a.ppoi,
					case when status='O'
							then 'Open'
						 when status='C'
							then 'Close'
						 else ''
					end as Status,
					filecreatedby,
					postdate,
					lastmodified,
					case when con.location is not null 
							then con.location
						 else a.location	
					end as location	,	
					remarks2,
					br.result
					
			--select *	from svbvm007.cars.dbo.amaster where Dam_amt_es<>''
			 --and Dam_amt_es is not null and   ISNUMERIC(Dam_amt_es)=0
				 
			from svbvm007.cars.dbo.amaster a left join svbvm007.cars.dbo.Lookup_table lt on  a.Cover_code=lt.Code  and lt.Category='Coverage'    
					left join
				 (select contract_number,l.Location 
					from contract c inner join location l 
					on c.pick_up_location_id=l.location_id) con on a.contract_N=con.contract_number
					left join 
						(select file_no,(select dbo.concate (file_no))as result
							from svbvm007.cars.dbo.BillingRemarks 
							group by file_no) BR
							on a.file_no=br.file_no	
					left join (

							SELECT     VC.Vehicle_Class_Name, V.Unit_Number
							FROM         dbo.Vehicle AS V INNER JOIN
												 dbo.Vehicle_Class AS VC ON V.Vehicle_Class_Code = VC.Vehicle_Class_Code

				   ) Veh On a.UNIT_NO=Convert(Varchar(30), Veh.Unit_Number)
					
			WHERE postdate BETWEEN @startDate AND @endDate
				and (@paramOptions='1' and (a.billedamt-a.paid_amt)<>0)
			 order by a.file_no
		end	
		
	
	else

		select	a.file_no,
				a.unit_no,
				veh.vehicle_class_name,
				contract_n,
				 case when lt.value like '2-LDW Ded $' 
							then rtrim(lt.value) +  replace(ltrim(rtrim(a.cover_amt)),'$','')
							else lt.value
				end  as CoverageValue,

				Accid_date,
				Model,
				case when Liability='1'
							then 'Renter'
					 when Liability='2'
							then 'Third Party'
					 when Liability='3'
							then 'Employee'
					 when Liability='4'
							then 'Hit and Run'
					 when Liability='5'
							then 'Stolen'
					 when Liability='6'
							then 'Vandals'
					 when Liability='8'
							then 'Not Determined'
					 when rtrim(ltrim(Liability))=''
							then ''
					 when Liability='7' 
							then 'Others'	
						else 	Liability
				end as Liability,
--				(Case When ISNUMERIC(replace(replace(NULLIF(Dam_amt_es,''), '$',''),',',''))=0 Then 0
--					Else Convert(decimal(9,2),replace(replace(NULLIF(Dam_amt_es,''), '$',''),',','') )
--				End) as Estimate,
				convert(varchar(30),Dam_amt_es	)as Estimate,
				a.billedamt as Billed,
--				 (a.billedamt-a.paid_amt) as Outstanding, 
				a.paid_amt as PaidAmount,
				a.ppoi,
				case when status='O'
						then 'Open'
					 when status='C'
						then 'Close'
					 else ''
				end as Status,
				filecreatedby,
				postdate,
				lastmodified,
				case when con.location is not null 
						then con.location
					 else a.location	
				end as location	,	
				remarks2,
				br.result

		--select *	from svbvm007.cars.dbo.amaster where Dam_amt_es<>''
		 --and Dam_amt_es is not null and   ISNUMERIC(Dam_amt_es)=0
			 
		from svbvm007.cars.dbo.amaster a left join svbvm007.cars.dbo.Lookup_table lt on  a.Cover_code=lt.Code and lt.Category='Coverage'    
				left join
			 (select contract_number,l.Location 
				from contract c inner join location l 
				on c.pick_up_location_id=l.location_id) con on a.contract_N=con.contract_number
				left join 
					(select file_no,(select dbo.concate (file_no))as result
						from svbvm007.cars.dbo.BillingRemarks 
						group by file_no) BR
						on a.file_no=br.file_no	
				left join (

						SELECT     VC.Vehicle_Class_Name, V.Unit_Number
						FROM         dbo.Vehicle AS V INNER JOIN
											 dbo.Vehicle_Class AS VC ON V.Vehicle_Class_Code = VC.Vehicle_Class_Code

			   ) Veh On a.UNIT_NO=Convert(Varchar(30), Veh.Unit_Number)


				
		WHERE postdate BETWEEN @startDate AND @endDate
			and ( (Case When ISNUMERIC(replace(replace(NULLIF(Dam_amt_es,''), '$',''),',',''))=1 
						Then Convert(decimal(9,2),replace(replace(NULLIF(Dam_amt_es,''), '$',''),',','') )
					Else 0
				End) - convert(decimal(9,2),a.billedamt))>0
			and (left(rtrim(lt.value),1) in ('1','3','4','5','6') or left(rtrim(lt.value),1)='2' and billedamt=0 )
		 order by a.file_no

end









GO
