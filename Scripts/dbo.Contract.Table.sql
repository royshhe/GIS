USE [GISData]
GO
/****** Object:  Table [dbo].[Contract]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Contract](
	[Contract_Number] [int] IDENTITY(388650,1) NOT NULL,
	[Confirmation_Number] [int] NULL,
	[Customer_ID] [int] NULL,
	[Referring_Organization_ID] [int] NULL,
	[Pick_Up_Location_ID] [smallint] NOT NULL,
	[Pick_Up_On] [datetime] NOT NULL,
	[Drop_Off_Location_ID] [smallint] NOT NULL,
	[Drop_Off_On] [datetime] NOT NULL,
	[Vehicle_Class_Code] [char](1) NOT NULL,
	[Last_Name] [varchar](25) NULL,
	[First_Name] [varchar](25) NULL,
	[Renter_Driving] [bit] NOT NULL,
	[Birth_Date] [datetime] NULL,
	[Gender] [char](1) NULL,
	[Phone_Number] [varchar](31) NULL,
	[Address_1] [varchar](50) NULL,
	[Address_2] [varchar](50) NULL,
	[City] [varchar](20) NULL,
	[Province_State] [varchar](20) NULL,
	[Country] [varchar](20) NULL,
	[Postal_Code] [varchar](10) NULL,
	[Fax_Number] [varchar](31) NULL,
	[Email_Address] [varchar](50) NULL,
	[Smoking_Non_Smoking] [char](1) NULL,
	[Company_Name] [varchar](30) NULL,
	[Company_Phone_Number] [varchar](31) NULL,
	[Local_Phone_Number] [varchar](31) NULL,
	[Local_Address_1] [varchar](50) NULL,
	[Local_Address_2] [varchar](20) NULL,
	[Local_City] [varchar](20) NULL,
	[Do_Not_Extend_Rental] [bit] NOT NULL,
	[Rate_ID] [int] NULL,
	[Rate_Assigned_Date] [datetime] NULL,
	[Rate_Level] [char](1) NULL,
	[Flex_Discount] [decimal](7, 4) NULL,
	[Member_Discount_ID] [char](1) NULL,
	[Frequent_Flyer_Plan_ID] [smallint] NULL,
	[Pre_Authorization_Method] [varchar](20) NULL,
	[BCD_Rate_Organization_ID] [int] NULL,
	[Customer_Program_Number] [varchar](15) NULL,
	[Do_Not_Replace_Vehicle] [bit] NOT NULL,
	[LDW_Declined_Reason] [varchar](20) NULL,
	[LDW_Declined_Details] [varchar](255) NULL,
	[IATA_Number] [varchar](10) NULL,
	[Referring_Employee_ID] [smallint] NULL,
	[Update_Ctrl] [datetime] NULL,
	[Print_Comment] [varchar](255) NULL,
	[Copied] [bit] NOT NULL,
	[Status] [char](2) NOT NULL,
	[Apply_Violation_Rate] [bit] NOT NULL,
	[Sub_Vehicle_Class_Code] [char](1) NULL,
	[Last_Update_By] [varchar](20) NOT NULL,
	[Last_Update_On] [datetime] NOT NULL,
	[Do_Not_Extend_Reason] [varchar](255) NULL,
	[FF_Member_Number] [varchar](20) NULL,
	[Quoted_Rate_ID] [int] NULL,
	[Foreign_Contract_Number] [varchar](20) NULL,
	[Contract_Currency_ID] [smallint] NULL,
	[Percentage_Tax1] [decimal](7, 4) NULL,
	[Percentage_Tax2] [decimal](7, 4) NULL,
	[Daily_Tax] [decimal](7, 4) NULL,
	[Interbranch_Balance] [decimal](9, 2) NULL,
	[GST_Exempt_Num] [varchar](15) NULL,
	[PST_Exempt_Num] [varchar](15) NULL,
	[Reservation_Revenue] [decimal](9, 2) NULL,
	[FF_Assigned_Date] [datetime] NULL,
	[Override_Minimum_Age] [bit] NOT NULL,
	[Opt_Out] [bit] NOT NULL,
	[FF_Swiped] [bit] NULL,
	[AM_Coupon_Code] [varchar](25) NULL,
	[Arrived_Through_AP] [bit] NULL,
	[PVRT_Exempt_Num] [varchar](15) NULL,
 CONSTRAINT [PK_Contract] PRIMARY KEY NONCLUSTERED 
(
	[Contract_Number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_Contract1]    Script Date: 2021-07-10 1:50:44 PM ******/
CREATE CLUSTERED INDEX [IX_Contract1] ON [dbo].[Contract]
(
	[Confirmation_Number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
/****** Object:  Index [_dta_index_Contract_5_1148635235__K1_K5]    Script Date: 2021-07-10 1:50:47 PM ******/
CREATE NONCLUSTERED INDEX [_dta_index_Contract_5_1148635235__K1_K5] ON [dbo].[Contract]
(
	[Contract_Number] ASC,
	[Pick_Up_Location_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [_dta_index_Contract_5_1148635235__K1_K5_K9_K10_K11]    Script Date: 2021-07-10 1:50:47 PM ******/
CREATE NONCLUSTERED INDEX [_dta_index_Contract_5_1148635235__K1_K5_K9_K10_K11] ON [dbo].[Contract]
(
	[Contract_Number] ASC,
	[Pick_Up_Location_ID] ASC,
	[Vehicle_Class_Code] ASC,
	[Last_Name] ASC,
	[First_Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [_dta_index_Contract_7_1148635235__K2_K6_K9_K5_K7_K51_K1_K49_K8_K39]    Script Date: 2021-07-10 1:50:47 PM ******/
CREATE NONCLUSTERED INDEX [_dta_index_Contract_7_1148635235__K2_K6_K9_K5_K7_K51_K1_K49_K8_K39] ON [dbo].[Contract]
(
	[Confirmation_Number] ASC,
	[Pick_Up_On] ASC,
	[Vehicle_Class_Code] ASC,
	[Pick_Up_Location_ID] ASC,
	[Drop_Off_Location_ID] ASC,
	[Sub_Vehicle_Class_Code] ASC,
	[Contract_Number] ASC,
	[Status] ASC,
	[Drop_Off_On] ASC,
	[BCD_Rate_Organization_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Contract] ADD  CONSTRAINT [DF__Contractx__Rente__0ABF281A]  DEFAULT (1) FOR [Renter_Driving]
GO
ALTER TABLE [dbo].[Contract] ADD  CONSTRAINT [DF__Contractx__Do_No__0CA7708C]  DEFAULT (0) FOR [Do_Not_Extend_Rental]
GO
ALTER TABLE [dbo].[Contract] ADD  CONSTRAINT [DF__Contractx__Flex___0D9B94C5]  DEFAULT (0) FOR [Flex_Discount]
GO
ALTER TABLE [dbo].[Contract] ADD  CONSTRAINT [DF__Contractx__Do_No__0E8FB8FE]  DEFAULT (0) FOR [Do_Not_Replace_Vehicle]
GO
ALTER TABLE [dbo].[Contract] ADD  CONSTRAINT [DF__Contractx__Copie__0F83DD37]  DEFAULT (0) FOR [Copied]
GO
ALTER TABLE [dbo].[Contract] ADD  CONSTRAINT [DF__Contractx__Apply__10780170]  DEFAULT (0) FOR [Apply_Violation_Rate]
GO
ALTER TABLE [dbo].[Contract] ADD  CONSTRAINT [DF_Contract_Override_Minimum_Age]  DEFAULT (0) FOR [Override_Minimum_Age]
GO
ALTER TABLE [dbo].[Contract] ADD  CONSTRAINT [Opt_Out_default]  DEFAULT (0) FOR [Opt_Out]
GO
ALTER TABLE [dbo].[Contract] ADD  CONSTRAINT [DF_Contract_Arrived_Through_AP]  DEFAULT (0) FOR [Arrived_Through_AP]
GO
ALTER TABLE [dbo].[Contract]  WITH NOCHECK ADD  CONSTRAINT [FK_Customer1] FOREIGN KEY([Customer_ID])
REFERENCES [dbo].[Customer] ([Customer_ID])
GO
ALTER TABLE [dbo].[Contract] CHECK CONSTRAINT [FK_Customer1]
GO
ALTER TABLE [dbo].[Contract]  WITH NOCHECK ADD  CONSTRAINT [FK_Discount2] FOREIGN KEY([Member_Discount_ID])
REFERENCES [dbo].[Discount] ([Discount_ID])
GO
ALTER TABLE [dbo].[Contract] CHECK CONSTRAINT [FK_Discount2]
GO
ALTER TABLE [dbo].[Contract]  WITH NOCHECK ADD  CONSTRAINT [FK_Location1] FOREIGN KEY([Drop_Off_Location_ID])
REFERENCES [dbo].[Location] ([Location_ID])
GO
ALTER TABLE [dbo].[Contract] CHECK CONSTRAINT [FK_Location1]
GO
ALTER TABLE [dbo].[Contract]  WITH NOCHECK ADD  CONSTRAINT [FK_Location2] FOREIGN KEY([Pick_Up_Location_ID])
REFERENCES [dbo].[Location] ([Location_ID])
GO
ALTER TABLE [dbo].[Contract] CHECK CONSTRAINT [FK_Location2]
GO
ALTER TABLE [dbo].[Contract]  WITH NOCHECK ADD  CONSTRAINT [FK_Organization8] FOREIGN KEY([BCD_Rate_Organization_ID])
REFERENCES [dbo].[Organization] ([Organization_ID])
GO
ALTER TABLE [dbo].[Contract] CHECK CONSTRAINT [FK_Organization8]
GO
ALTER TABLE [dbo].[Contract]  WITH NOCHECK ADD  CONSTRAINT [FK_Organization9] FOREIGN KEY([Referring_Organization_ID])
REFERENCES [dbo].[Organization] ([Organization_ID])
GO
ALTER TABLE [dbo].[Contract] CHECK CONSTRAINT [FK_Organization9]
GO
ALTER TABLE [dbo].[Contract]  WITH NOCHECK ADD  CONSTRAINT [FK_Quoted_Vehicle_Rate5] FOREIGN KEY([Quoted_Rate_ID])
REFERENCES [dbo].[Quoted_Vehicle_Rate] ([Quoted_Rate_ID])
GO
ALTER TABLE [dbo].[Contract] CHECK CONSTRAINT [FK_Quoted_Vehicle_Rate5]
GO
ALTER TABLE [dbo].[Contract]  WITH NOCHECK ADD  CONSTRAINT [FK_Referring_Employee1] FOREIGN KEY([Referring_Employee_ID])
REFERENCES [dbo].[Referring_Employee] ([Referring_Employee_ID])
GO
ALTER TABLE [dbo].[Contract] CHECK CONSTRAINT [FK_Referring_Employee1]
GO
ALTER TABLE [dbo].[Contract]  WITH NOCHECK ADD  CONSTRAINT [FK_Reservation1] FOREIGN KEY([Confirmation_Number])
REFERENCES [dbo].[Reservation] ([Confirmation_Number])
GO
ALTER TABLE [dbo].[Contract] NOCHECK CONSTRAINT [FK_Reservation1]
GO
ALTER TABLE [dbo].[Contract]  WITH NOCHECK ADD  CONSTRAINT [FK_Vehicle_Class3] FOREIGN KEY([Vehicle_Class_Code])
REFERENCES [dbo].[Vehicle_Class] ([Vehicle_Class_Code])
GO
ALTER TABLE [dbo].[Contract] CHECK CONSTRAINT [FK_Vehicle_Class3]
GO
