USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Adhoc_Get_Claim_Detail_By_UnitNumber]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








CREATE PROCEDURE [dbo].[RP_SP_Adhoc_Get_Claim_Detail_By_UnitNumber]  --'195577'

(
	@paramUnitNum varchar(10)=''	
)
AS


select	a.file_no,
		convert(varchar(11),Accid_date,100) Accid_date,
		veh.vehicle_class_name,
		Model,
		contract_n,
		 case when lt.value like '2-LDW Ded $' 
					then rtrim(lt.value) +  replace(ltrim(rtrim(a.cover_amt)),'$','')
					else lt.value
		end  as CoverageValue,

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
		(Case When ISNUMERIC(replace(replace(NULLIF(Dam_amt_es,''), '$',''),',',''))=0 Then 0
			Else Convert(decimal(9,2),replace(replace(NULLIF(Dam_amt_es,''), '$',''),',','') )
		End) as Estimate,
--		a.billedamt as Billed,
--		 (a.billedamt-a.paid_amt) as Outstanding, 
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
		end as location	--,	
		--remarks2,
--		br.result
		
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
		
WHERE a.UNIT_NO=@paramUnitNum
 order by a.file_no










GO
