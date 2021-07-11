USE [GISData]
GO
/****** Object:  Table [dbo].[Vehicle_On_Contract]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Vehicle_On_Contract](
	[Contract_Number] [int] NOT NULL,
	[Unit_Number] [int] NOT NULL,
	[Checked_Out] [datetime] NOT NULL,
	[Pick_Up_Location_ID] [smallint] NOT NULL,
	[Expected_Check_In] [datetime] NOT NULL,
	[Expected_Drop_Off_Location_ID] [smallint] NOT NULL,
	[Actual_Check_In] [datetime] NULL,
	[Actual_Drop_Off_Location_ID] [smallint] NULL,
	[Km_Out] [int] NOT NULL,
	[Km_In] [int] NULL,
	[Fuel_Level] [char](6) NULL,
	[Fuel_Remaining] [decimal](5, 2) NULL,
	[Fuel_Added_Dollar_Amt] [decimal](9, 2) NULL,
	[Fuel_Added_Litres] [decimal](5, 2) NULL,
	[Fuel_Price_Per_Litre] [decimal](9, 3) NULL,
	[Vehicle_Condition_Status] [char](1) NULL,
	[Vehicle_Not_Present_Reason] [varchar](20) NULL,
	[Vehicle_Not_Present_Location] [varchar](128) NULL,
	[Checked_In_By] [varchar](20) NULL,
	[Check_In_Reason] [varchar](20) NULL,
	[Actual_Vehicle_Class_Code] [char](1) NULL,
	[FPO_Purchased] [bit] NOT NULL,
	[Calculated_Fuel_Charge] [decimal](9, 2) NULL,
	[Calculated_Fuel_Litre] [decimal](9, 2) NULL,
	[Upgrade_Charge] [decimal](9, 2) NULL,
	[Calculated_Upgrade_Charge] [decimal](9, 2) NULL,
	[Foreign_FPO_Charge] [decimal](9, 2) NULL,
	[Replacement_Contract_Number] [varchar](20) NULL,
	[Business_Transaction_ID] [int] NOT NULL,
	[Last_Updated_On] [datetime] NULL,
 CONSTRAINT [PK_Vehicle_On_Contract] PRIMARY KEY CLUSTERED 
(
	[Contract_Number] ASC,
	[Unit_Number] ASC,
	[Checked_Out] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [_dta_index_Vehicle_On_Contract_5_657437416__K1_K3_K2_K7]    Script Date: 2021-07-10 1:50:47 PM ******/
CREATE NONCLUSTERED INDEX [_dta_index_Vehicle_On_Contract_5_657437416__K1_K3_K2_K7] ON [dbo].[Vehicle_On_Contract]
(
	[Contract_Number] ASC,
	[Checked_Out] ASC,
	[Unit_Number] ASC,
	[Actual_Check_In] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
/****** Object:  Index [_dta_index_Vehicle_On_Contract_5_657437416__K2_K3_K1_K7]    Script Date: 2021-07-10 1:50:47 PM ******/
CREATE NONCLUSTERED INDEX [_dta_index_Vehicle_On_Contract_5_657437416__K2_K3_K1_K7] ON [dbo].[Vehicle_On_Contract]
(
	[Unit_Number] ASC,
	[Checked_Out] ASC,
	[Contract_Number] ASC,
	[Actual_Check_In] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
/****** Object:  Index [IX_Vehicle_On_Contract1]    Script Date: 2021-07-10 1:50:47 PM ******/
CREATE NONCLUSTERED INDEX [IX_Vehicle_On_Contract1] ON [dbo].[Vehicle_On_Contract]
(
	[Unit_Number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
/****** Object:  Index [IX_Vehicle_On_Contract2]    Script Date: 2021-07-10 1:50:47 PM ******/
CREATE NONCLUSTERED INDEX [IX_Vehicle_On_Contract2] ON [dbo].[Vehicle_On_Contract]
(
	[Business_Transaction_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Vehicle_On_Contract] ADD  CONSTRAINT [DF__Vehicle_O__FPO_P__78E06F01]  DEFAULT (0) FOR [FPO_Purchased]
GO
ALTER TABLE [dbo].[Vehicle_On_Contract]  WITH CHECK ADD  CONSTRAINT [FK_Business_Transaction2] FOREIGN KEY([Business_Transaction_ID])
REFERENCES [dbo].[Business_Transaction] ([Business_Transaction_ID])
GO
ALTER TABLE [dbo].[Vehicle_On_Contract] CHECK CONSTRAINT [FK_Business_Transaction2]
GO
ALTER TABLE [dbo].[Vehicle_On_Contract]  WITH NOCHECK ADD  CONSTRAINT [FK_Contract01] FOREIGN KEY([Contract_Number])
REFERENCES [dbo].[Contract] ([Contract_Number])
GO
ALTER TABLE [dbo].[Vehicle_On_Contract] CHECK CONSTRAINT [FK_Contract01]
GO
ALTER TABLE [dbo].[Vehicle_On_Contract]  WITH NOCHECK ADD  CONSTRAINT [FK_Location6] FOREIGN KEY([Actual_Drop_Off_Location_ID])
REFERENCES [dbo].[Location] ([Location_ID])
GO
ALTER TABLE [dbo].[Vehicle_On_Contract] CHECK CONSTRAINT [FK_Location6]
GO
ALTER TABLE [dbo].[Vehicle_On_Contract]  WITH NOCHECK ADD  CONSTRAINT [FK_Location7] FOREIGN KEY([Pick_Up_Location_ID])
REFERENCES [dbo].[Location] ([Location_ID])
GO
ALTER TABLE [dbo].[Vehicle_On_Contract] CHECK CONSTRAINT [FK_Location7]
GO
ALTER TABLE [dbo].[Vehicle_On_Contract]  WITH NOCHECK ADD  CONSTRAINT [FK_Location8] FOREIGN KEY([Expected_Drop_Off_Location_ID])
REFERENCES [dbo].[Location] ([Location_ID])
GO
ALTER TABLE [dbo].[Vehicle_On_Contract] CHECK CONSTRAINT [FK_Location8]
GO
ALTER TABLE [dbo].[Vehicle_On_Contract]  WITH NOCHECK ADD  CONSTRAINT [FK_Vehicle1] FOREIGN KEY([Unit_Number])
REFERENCES [dbo].[Vehicle] ([Unit_Number])
GO
ALTER TABLE [dbo].[Vehicle_On_Contract] CHECK CONSTRAINT [FK_Vehicle1]
GO
