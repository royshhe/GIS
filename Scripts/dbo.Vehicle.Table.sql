USE [GISData]
GO
/****** Object:  Table [dbo].[Vehicle]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Vehicle](
	[Unit_Number] [int] IDENTITY(140000,1) NOT NULL,
	[Foreign_Vehicle_Unit_Number] [varchar](20) NULL,
	[Owning_Company_ID] [smallint] NOT NULL,
	[Vehicle_Class_Code] [char](1) NOT NULL,
	[Vehicle_Model_ID] [smallint] NOT NULL,
	[Serial_Number] [varchar](30) NULL,
	[Dealer_ID] [smallint] NULL,
	[Key_Ignition_Code] [varchar](20) NULL,
	[Key_Trunk_Code] [varchar](20) NULL,
	[Program] [bit] NOT NULL,
	[Exterior_Colour] [varchar](15) NULL,
	[Interior_Colour] [varchar](15) NULL,
	[Do_Not_Rent_Past_Km] [int] NULL,
	[Maximum_Km] [int] NULL,
	[Minimum_Days] [smallint] NULL,
	[Maximum_Days] [smallint] NULL,
	[Do_Not_Rent_Past_Days] [smallint] NULL,
	[Turn_Back_Deadline] [datetime] NULL,
	[Reconditioning_Days_Allowed] [smallint] NULL,
	[Current_Vehicle_Status] [char](1) NOT NULL,
	[Current_Rental_Status] [char](1) NULL,
	[Vehicle_Status_Effective_On] [datetime] NOT NULL,
	[Rental_Status_Effective_On] [datetime] NULL,
	[Current_Condition_Status] [char](1) NULL,
	[Condition_Status_Effective_On] [datetime] NULL,
	[Current_Licence_Plate] [varchar](10) NULL,
	[Current_Licencing_prov_State] [varchar](30) NULL,
	[Foreign_Licence_Plate_Flag] [bit] NOT NULL,
	[Smoking_Flag] [bit] NOT NULL,
	[Licence_Plate_Attached_On] [datetime] NULL,
	[Current_Location_ID] [smallint] NOT NULL,
	[Current_Km] [int] NULL,
	[Total_Non_Revenue_Km] [int] NULL,
	[Maximum_Rental_Period] [smallint] NULL,
	[Ownership_Date] [datetime] NULL,
	[Drop_ShipDate] [datetime] NULL,
	[Deleted] [bit] NOT NULL,
	[Comments] [varchar](255) NULL,
	[Deleted_On] [datetime] NULL,
	[Next_Scheduled_Maintenance] [int] NULL,
	[Last_Update_By] [varchar](20) NULL,
	[Last_Update_On] [datetime] NULL,
	[MVA_Number] [varchar](20) NULL,
	[Risk_Type] [char](1) NULL,
	[Ownership] [varchar](25) NULL,
	[Year_Of_Agreement] [char](25) NULL,
	[Purchase_Cycle] [char](25) NULL,
	[Purchase_Price] [decimal](9, 2) NULL,
	[PDI_Amount] [decimal](9, 2) NULL,
	[PDI_Included_In_Price] [bit] NULL,
	[PDI_Performed_By] [varchar](20) NULL,
	[Volume_Incentive] [decimal](9, 2) NULL,
	[Incentive_Received_From] [varchar](20) NULL,
	[Rebate_Amount] [decimal](9, 2) NULL,
	[Rebate_From] [varchar](20) NULL,
	[Planned_Days_In_Service] [smallint] NULL,
	[Vehicle_Cost] [decimal](9, 2) NULL,
	[Mark_Down] [decimal](9, 2) NULL,
	[Excise_Tax] [decimal](9, 2) NULL,
	[Battery_Levy] [decimal](9, 2) NULL,
	[Own_Use] [bit] NULL,
	[Payment_Due_Date] [datetime] NULL,
	[Purchase_GST] [decimal](9, 2) NULL,
	[Purchase_PST] [decimal](9, 2) NULL,
	[Purchase_Process_Date] [datetime] NULL,
	[Payment_Type] [varchar](10) NULL,
	[Depreciation_Start_Date] [datetime] NULL,
	[Depreciation_End_Date] [datetime] NULL,
	[Depreciation_Rate_Amount] [decimal](9, 2) NULL,
	[Depreciation_Rate_Percentage] [decimal](9, 2) NULL,
	[Loan_Repaid_Max_KM] [int] NULL,
	[Loan_Repaid_Max_Ownership] [smallint] NULL,
	[Finance_By] [char](10) NULL,
	[Trans_Month] [smallint] NULL,
	[Loan_Amount] [decimal](9, 2) NULL,
	[Loan_Tax_Included] [bit] NULL,
	[Loan_Principal_Rate_ID] [int] NULL,
	[Override_Principal_Rate] [decimal](12, 8) NULL,
	[Financing_Start_Date] [datetime] NULL,
	[Financing_End_Date] [datetime] NULL,
	[Term] [smallint] NULL,
	[Payout_Amount] [decimal](9, 2) NULL,
	[Payount_Date] [datetime] NULL,
	[Loan_Setup_Fee] [decimal](9, 2) NULL,
	[Cap_Cost] [decimal](9, 2) NULL,
	[Price_Difference] [decimal](9, 2) NULL,
	[Deduction] [decimal](9, 2) NULL,
	[Damage_Amount] [decimal](9, 2) NULL,
	[Declaration_Amount] [decimal](9, 2) NULL,
	[KM_Reading] [int] NULL,
	[KM_Charge] [decimal](9, 2) NULL,
	[ISD] [datetime] NULL,
	[OSD] [datetime] NULL,
	[Idle_Days] [smallint] NULL,
	[Depreciation_Periods] [decimal](9, 2) NULL,
	[Selling_Monthly_AMO] [decimal](9, 2) NULL,
	[Depreciation_Type] [char](10) NULL,
	[Sales_Acc_Dep] [decimal](9, 2) NULL,
	[Selling_Price] [decimal](9, 2) NULL,
	[Sales_GST] [decimal](9, 2) NULL,
	[Sales_PST] [decimal](9, 2) NULL,
	[Sell_To] [char](12) NULL,
	[Sold_Date] [datetime] NULL,
	[Sales_Processed_date] [datetime] NULL,
	[Sales_Processed] [bit] NULL,
	[Amount_Paid] [decimal](9, 2) NULL,
	[Payment_Cheque_No] [varchar](50) NULL,
	[Payment_Date] [datetime] NULL,
	[Lessee_id] [smallint] NULL,
	[Initial_Cost] [decimal](9, 2) NULL,
	[Interest_Rate] [decimal](9, 2) NULL,
	[Principle_Rate] [decimal](9, 2) NULL,
	[Lease_Start_Date] [datetime] NULL,
	[Lease_End_Date] [datetime] NULL,
	[Private_Lease] [bit] NULL,
	[Market_Price] [decimal](9, 2) NULL,
	[Turn_Back_Message] [varchar](255) NULL,
	[FA_Remarks] [varchar](75) NULL,
	[Overrid_PM_Schedule_Id] [int] NULL,
	[TB_Expense] [decimal](9, 2) NULL,
 CONSTRAINT [PK_Vehicle] PRIMARY KEY NONCLUSTERED 
(
	[Unit_Number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Vehicle1]    Script Date: 2021-07-10 1:50:47 PM ******/
CREATE NONCLUSTERED INDEX [IX_Vehicle1] ON [dbo].[Vehicle]
(
	[Foreign_Vehicle_Unit_Number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Vehicle] ADD  CONSTRAINT [DF__Vehicle__Program__0FAF9117]  DEFAULT (0) FOR [Program]
GO
ALTER TABLE [dbo].[Vehicle] ADD  CONSTRAINT [DF__Vehicle__Foreign__10A3B550]  DEFAULT (0) FOR [Foreign_Licence_Plate_Flag]
GO
ALTER TABLE [dbo].[Vehicle] ADD  CONSTRAINT [DF__Vehicle__Smoking__1197D989]  DEFAULT (0) FOR [Smoking_Flag]
GO
ALTER TABLE [dbo].[Vehicle]  WITH NOCHECK ADD  CONSTRAINT [CK_Vehicle_Dates] CHECK  (([drop_shipdate] is null or ([licence_plate_attached_on] is null or [licence_plate_attached_on] >= [drop_shipdate]) and ([ownership_date] is null or [ownership_date] >= [drop_shipdate])))
GO
ALTER TABLE [dbo].[Vehicle] CHECK CONSTRAINT [CK_Vehicle_Dates]
GO
ALTER TABLE [dbo].[Vehicle]  WITH NOCHECK ADD  CONSTRAINT [CK_Vehicle_Licence] CHECK  ((((not(([current_licence_plate] = ' ' or [current_licence_plate] is null) and ([current_rental_status] = 'C' or [current_rental_status] = 'B'))))))
GO
ALTER TABLE [dbo].[Vehicle] CHECK CONSTRAINT [CK_Vehicle_Licence]
GO
