USE [GISData]
GO
/****** Object:  Table [dbo].[RP_ACC_17_CSR_Incremental_Incentive_Revenue]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RP_ACC_17_CSR_Incremental_Incentive_Revenue](
	[RBR_date] [datetime] NOT NULL,
	[EmployeeID] [varchar](20) NULL,
	[EmployeeStatus] [varchar](5) NULL,
	[Location_ID] [varchar](10) NOT NULL,
	[Location] [varchar](35) NULL,
	[Vehicle_Type_ID] [varchar](10) NOT NULL,
	[Vehicle_Class_Code] [char](10) NULL,
	[CSR_Name] [varchar](30) NOT NULL,
	[Contract_In] [int] NULL,
	[Walk_Up] [int] NULL,
	[Rental_Days] [decimal](9, 2) NULL,
	[Upgrade] [decimal](9, 2) NULL,
	[Up_Sell] [decimal](9, 2) NULL,
	[All_Level_LDW] [decimal](9, 2) NULL,
	[Buydown] [decimal](9, 2) NULL,
	[PAI] [decimal](9, 2) NULL,
	[PEC] [decimal](9, 2) NULL,
	[ELI] [decimal](9, 2) NULL,
	[GPS] [decimal](9, 2) NULL,
	[FPO] [decimal](9, 2) NULL,
	[Additional_Driver_Charge] [decimal](9, 2) NULL,
	[All_Seats] [decimal](9, 2) NULL,
	[Driver_Under_Age] [decimal](9, 2) NULL,
	[Ski_Rack] [decimal](9, 2) NULL,
	[Seat_Storage] [decimal](9, 2) NULL,
	[Our_Of_Area] [decimal](9, 2) NULL,
	[All_Dolly] [decimal](9, 2) NULL,
	[All_Gates] [decimal](9, 2) NULL,
	[Blanket] [decimal](9, 2) NULL,
	[Snow_Tire] [decimal](9, 2) NULL,
	[KPO_Package] [decimal](9, 2) NULL,
	[Walkup_Rental_Days] [decimal](9, 2) NULL,
	[Walkup_TnM] [decimal](9, 2) NULL,
	[Upgrade_Count] [int] NULL,
	[All_Seats_Count] [int] NULL,
	[All_LDW_Count] [int] NULL,
	[Buydown_Count] [int] NULL,
	[PAI_Count] [int] NULL,
	[PEC_Count] [int] NULL,
	[ELI_Count] [int] NULL,
	[Additional_Driver_Count] [int] NULL,
	[Other_Extra_Count] [int] NULL,
	[Snow_Tire_Count] [int] NULL,
	[Walkup_Count] [int] NULL,
	[FPO_Contract_Count] [int] NULL,
	[FPOCount] [int] NULL,
	[Upgrade_Adj] [decimal](9, 2) NULL,
	[Up_Sell_Adj] [decimal](9, 2) NULL,
	[All_Level_LDW_Adj] [decimal](9, 2) NULL,
	[Buydown_Adj] [decimal](9, 2) NULL,
	[PAI_Adj] [decimal](9, 2) NULL,
	[PEC_Adj] [decimal](9, 2) NULL,
	[ELI_Adj] [decimal](9, 2) NULL,
	[GPS_Adj] [decimal](9, 2) NULL,
	[Additional_Driver_Charge_Adj] [decimal](9, 2) NULL,
	[All_Seats_Adj] [decimal](9, 2) NULL,
	[Driver_Under_Age_Adj] [decimal](9, 2) NULL,
	[Ski_Rack_Adj] [decimal](9, 2) NULL,
	[Seat_Storage_Adj] [decimal](9, 2) NULL,
	[Our_Of_Area_Adj] [decimal](9, 2) NULL,
	[All_Dolly_Adj] [decimal](9, 2) NULL,
	[All_Gates_Adj] [decimal](9, 2) NULL,
	[Blanket_Adj] [decimal](9, 2) NULL,
	[Snow_Tire_Adj] [decimal](9, 2) NULL,
	[KPO_Package_Adj] [decimal](9, 2) NULL,
	[FPOCount_Adj] [int] NULL,
 CONSTRAINT [PK_RP_ACC_17_CSR_Incremental_Incentive_Revenue] PRIMARY KEY CLUSTERED 
(
	[RBR_date] ASC,
	[Location_ID] ASC,
	[Vehicle_Type_ID] ASC,
	[CSR_Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[RP_ACC_17_CSR_Incremental_Incentive_Revenue] ADD  CONSTRAINT [DF_RP_ACC_17_CSR_Incremental_Incentive_Revenue_Upgrade_Adj]  DEFAULT (0) FOR [Upgrade_Adj]
GO
ALTER TABLE [dbo].[RP_ACC_17_CSR_Incremental_Incentive_Revenue] ADD  CONSTRAINT [DF_RP_ACC_17_CSR_Incremental_Incentive_Revenue_Up_Sell_Adj]  DEFAULT (0) FOR [Up_Sell_Adj]
GO
ALTER TABLE [dbo].[RP_ACC_17_CSR_Incremental_Incentive_Revenue] ADD  CONSTRAINT [DF_RP_ACC_17_CSR_Incremental_Incentive_Revenue_All_Level_LDW_Adj]  DEFAULT (0) FOR [All_Level_LDW_Adj]
GO
ALTER TABLE [dbo].[RP_ACC_17_CSR_Incremental_Incentive_Revenue] ADD  CONSTRAINT [DF_RP_ACC_17_CSR_Incremental_Incentive_Revenue_Buydown_Adj]  DEFAULT (0) FOR [Buydown_Adj]
GO
ALTER TABLE [dbo].[RP_ACC_17_CSR_Incremental_Incentive_Revenue] ADD  CONSTRAINT [DF_RP_ACC_17_CSR_Incremental_Incentive_Revenue_PAI_Adj]  DEFAULT (0) FOR [PAI_Adj]
GO
ALTER TABLE [dbo].[RP_ACC_17_CSR_Incremental_Incentive_Revenue] ADD  CONSTRAINT [DF_RP_ACC_17_CSR_Incremental_Incentive_Revenue_PEC_Adj]  DEFAULT (0) FOR [PEC_Adj]
GO
ALTER TABLE [dbo].[RP_ACC_17_CSR_Incremental_Incentive_Revenue] ADD  CONSTRAINT [DF_RP_ACC_17_CSR_Incremental_Incentive_Revenue_ELI_Adj]  DEFAULT (0) FOR [ELI_Adj]
GO
ALTER TABLE [dbo].[RP_ACC_17_CSR_Incremental_Incentive_Revenue] ADD  CONSTRAINT [DF_RP_ACC_17_CSR_Incremental_Incentive_Revenue_GPS_Adj]  DEFAULT (0) FOR [GPS_Adj]
GO
ALTER TABLE [dbo].[RP_ACC_17_CSR_Incremental_Incentive_Revenue] ADD  CONSTRAINT [DF_RP_ACC_17_CSR_Incremental_Incentive_Revenue_Additional_Driver_Charge_Adj]  DEFAULT (0) FOR [Additional_Driver_Charge_Adj]
GO
ALTER TABLE [dbo].[RP_ACC_17_CSR_Incremental_Incentive_Revenue] ADD  CONSTRAINT [DF_RP_ACC_17_CSR_Incremental_Incentive_Revenue_All_Seats_Adj]  DEFAULT (0) FOR [All_Seats_Adj]
GO
ALTER TABLE [dbo].[RP_ACC_17_CSR_Incremental_Incentive_Revenue] ADD  CONSTRAINT [DF_RP_ACC_17_CSR_Incremental_Incentive_Revenue_Driver_Under_Age_Adj]  DEFAULT (0) FOR [Driver_Under_Age_Adj]
GO
ALTER TABLE [dbo].[RP_ACC_17_CSR_Incremental_Incentive_Revenue] ADD  CONSTRAINT [DF_RP_ACC_17_CSR_Incremental_Incentive_Revenue_Ski_Rack_Adj]  DEFAULT (0) FOR [Ski_Rack_Adj]
GO
ALTER TABLE [dbo].[RP_ACC_17_CSR_Incremental_Incentive_Revenue] ADD  CONSTRAINT [DF_RP_ACC_17_CSR_Incremental_Incentive_Revenue_Seat_Storage_Adj]  DEFAULT (0) FOR [Seat_Storage_Adj]
GO
ALTER TABLE [dbo].[RP_ACC_17_CSR_Incremental_Incentive_Revenue] ADD  CONSTRAINT [DF_RP_ACC_17_CSR_Incremental_Incentive_Revenue_Our_Of_Area_Adj]  DEFAULT (0) FOR [Our_Of_Area_Adj]
GO
ALTER TABLE [dbo].[RP_ACC_17_CSR_Incremental_Incentive_Revenue] ADD  CONSTRAINT [DF_RP_ACC_17_CSR_Incremental_Incentive_Revenue_All_Dolly_Adj]  DEFAULT (0) FOR [All_Dolly_Adj]
GO
ALTER TABLE [dbo].[RP_ACC_17_CSR_Incremental_Incentive_Revenue] ADD  CONSTRAINT [DF_RP_ACC_17_CSR_Incremental_Incentive_Revenue_All_Gates_Adj]  DEFAULT (0) FOR [All_Gates_Adj]
GO
ALTER TABLE [dbo].[RP_ACC_17_CSR_Incremental_Incentive_Revenue] ADD  CONSTRAINT [DF_RP_ACC_17_CSR_Incremental_Incentive_Revenue_Blanket_Adj]  DEFAULT (0) FOR [Blanket_Adj]
GO
ALTER TABLE [dbo].[RP_ACC_17_CSR_Incremental_Incentive_Revenue] ADD  CONSTRAINT [DF_RP_ACC_17_CSR_Incremental_Incentive_Revenue_Snow_Tire_Adj]  DEFAULT (0) FOR [Snow_Tire_Adj]
GO
ALTER TABLE [dbo].[RP_ACC_17_CSR_Incremental_Incentive_Revenue] ADD  CONSTRAINT [DF_RP_ACC_17_CSR_Incremental_Incentive_Revenue_KPO_Package_Adj]  DEFAULT (0) FOR [KPO_Package_Adj]
GO
ALTER TABLE [dbo].[RP_ACC_17_CSR_Incremental_Incentive_Revenue] ADD  CONSTRAINT [DF_RP_ACC_17_CSR_Incremental_Incentive_Revenue_FPOCount_Adj]  DEFAULT (0) FOR [FPOCount_Adj]
GO
