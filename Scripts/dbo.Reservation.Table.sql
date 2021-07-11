USE [GISData]
GO
/****** Object:  Table [dbo].[Reservation]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Reservation](
	[Confirmation_Number] [int] IDENTITY(1,1) NOT NULL,
	[Foreign_Confirm_Number] [varchar](20) NULL,
	[Marketing_Source_ID] [smallint] NULL,
	[Credit_Card_Type_ID] [char](3) NULL,
	[Drop_Off_Location_ID] [smallint] NOT NULL,
	[Pick_Up_Location_ID] [smallint] NOT NULL,
	[Vehicle_Class_Code] [char](1) NOT NULL,
	[Pick_Up_On] [datetime] NOT NULL,
	[Drop_Off_On] [datetime] NOT NULL,
	[Smoking_Non_Smoking] [char](1) NOT NULL,
	[Flight_Number] [varchar](10) NULL,
	[IATA_Number] [varchar](10) NULL,
	[First_Name] [varchar](25) NOT NULL,
	[Last_Name] [varchar](25) NOT NULL,
	[Business_Phone_Number] [varchar](31) NULL,
	[Contact_Phone_Number] [varchar](31) NULL,
	[Payment_Method] [varchar](20) NOT NULL,
	[Deposit_Method] [varchar](20) NULL,
	[Flex_Discount] [decimal](7, 4) NULL,
	[Special_Comments] [varchar](255) NULL,
	[Customer_ID] [int] NULL,
	[Referring_Employee_ID] [smallint] NULL,
	[Discount_ID] [char](1) NULL,
	[Rate_Level] [char](1) NULL,
	[Rate_ID] [int] NULL,
	[Date_Rate_Assigned] [datetime] NULL,
	[Status] [char](1) NOT NULL,
	[Cancellation_Reason] [varchar](255) NULL,
	[Fax_Number] [varchar](31) NULL,
	[Fax_Confirmation] [bit] NOT NULL,
	[Deposit_Waived] [bit] NOT NULL,
	[Maestro_Guarantee] [bit] NOT NULL,
	[Copied] [bit] NOT NULL,
	[PrePay_Indicator] [bit] NOT NULL,
	[Executive_Action_Indicator] [bit] NOT NULL,
	[BCD_Rate_Org_ID] [int] NULL,
	[Referring_Org_ID] [int] NULL,
	[Program_Number] [varchar](15) NULL,
	[Source_Code] [varchar](10) NOT NULL,
	[Fastbreak_Indicator] [bit] NOT NULL,
	[Applicant_Status_Indicator] [bit] NOT NULL,
	[Perfect_Drive_Indicator] [bit] NOT NULL,
	[Guaranteed_Rate_Indicator] [bit] NOT NULL,
	[Guarantee_Credit_Card_Key] [int] NULL,
	[Company_Name] [varchar](30) NULL,
	[Update_Ctrl] [datetime] NOT NULL,
	[Last_Changed_By] [varchar](20) NOT NULL,
	[Last_Changed_On] [datetime] NOT NULL,
	[Quoted_Rate_ID] [int] NULL,
	[Affiliated_BCD_Org_ID] [int] NULL,
	[Guarantee_Deposit_Amount] [decimal](9, 2) NULL,
	[Customer_Code] [varchar](15) NULL,
	[Swiped_Flag] [bit] NOT NULL,
	[Email_Address] [varchar](50) NULL,
	[BCD_Number] [char](30) NULL,
	[Coupon_Code] [varchar](50) NULL,
	[CID] [varchar](50) NULL,
	[Rate_Code] [varchar](10) NULL,
	[Res_Booking_City] [varchar](15) NULL,
	[Truck_Res_Type] [varchar](20) NULL,
	[Reservation_Revenue] [decimal](9, 2) NULL,
	[Flat_Discount] [decimal](9, 2) NULL,
	[Coupon_Description] [varchar](50) NULL,
 CONSTRAINT [PK_Reservation] PRIMARY KEY CLUSTERED 
(
	[Confirmation_Number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Reservation1]    Script Date: 2021-07-10 1:50:47 PM ******/
CREATE NONCLUSTERED INDEX [IX_Reservation1] ON [dbo].[Reservation]
(
	[Foreign_Confirm_Number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Reservation] ADD  CONSTRAINT [DF__Reservati__Smoki__52BAC619]  DEFAULT ('3') FOR [Smoking_Non_Smoking]
GO
ALTER TABLE [dbo].[Reservation] ADD  CONSTRAINT [DF__Reservati__Flex___53AEEA52]  DEFAULT (0) FOR [Flex_Discount]
GO
ALTER TABLE [dbo].[Reservation] ADD  CONSTRAINT [DF__Reservati__Fax_C__54A30E8B]  DEFAULT (0) FOR [Fax_Confirmation]
GO
ALTER TABLE [dbo].[Reservation] ADD  CONSTRAINT [DF__Reservati__Depos__559732C4]  DEFAULT (0) FOR [Deposit_Waived]
GO
ALTER TABLE [dbo].[Reservation] ADD  CONSTRAINT [DF__Reservati__Maest__568B56FD]  DEFAULT (0) FOR [Maestro_Guarantee]
GO
ALTER TABLE [dbo].[Reservation] ADD  CONSTRAINT [DF__Reservati__Copie__577F7B36]  DEFAULT (0) FOR [Copied]
GO
ALTER TABLE [dbo].[Reservation] ADD  CONSTRAINT [DF__Reservati__PrePa__58739F6F]  DEFAULT (0) FOR [PrePay_Indicator]
GO
ALTER TABLE [dbo].[Reservation] ADD  CONSTRAINT [DF__Reservati__Execu__5967C3A8]  DEFAULT (0) FOR [Executive_Action_Indicator]
GO
ALTER TABLE [dbo].[Reservation] ADD  CONSTRAINT [DF_Reservation_Swiped_Flag_1]  DEFAULT (0) FOR [Swiped_Flag]
GO
ALTER TABLE [dbo].[Reservation] ADD  CONSTRAINT [DF_Reservation_Truck_Res_Type]  DEFAULT ('Aroundtown') FOR [Truck_Res_Type]
GO
ALTER TABLE [dbo].[Reservation]  WITH NOCHECK ADD  CONSTRAINT [FK_AR_Credit_Authorization1] FOREIGN KEY([Customer_Code])
REFERENCES [dbo].[AR_Credit_Authorization] ([Customer_Code])
NOT FOR REPLICATION 
GO
ALTER TABLE [dbo].[Reservation] NOCHECK CONSTRAINT [FK_AR_Credit_Authorization1]
GO
ALTER TABLE [dbo].[Reservation]  WITH NOCHECK ADD  CONSTRAINT [FK_Credit_Card4] FOREIGN KEY([Guarantee_Credit_Card_Key])
REFERENCES [dbo].[Credit_Card] ([Credit_Card_Key])
GO
ALTER TABLE [dbo].[Reservation] CHECK CONSTRAINT [FK_Credit_Card4]
GO
ALTER TABLE [dbo].[Reservation]  WITH NOCHECK ADD  CONSTRAINT [FK_Customer3] FOREIGN KEY([Customer_ID])
REFERENCES [dbo].[Customer] ([Customer_ID])
GO
ALTER TABLE [dbo].[Reservation] CHECK CONSTRAINT [FK_Customer3]
GO
ALTER TABLE [dbo].[Reservation]  WITH NOCHECK ADD  CONSTRAINT [FK_Discount1] FOREIGN KEY([Discount_ID])
REFERENCES [dbo].[Discount] ([Discount_ID])
GO
ALTER TABLE [dbo].[Reservation] CHECK CONSTRAINT [FK_Discount1]
GO
ALTER TABLE [dbo].[Reservation]  WITH NOCHECK ADD  CONSTRAINT [FK_Organization10] FOREIGN KEY([Affiliated_BCD_Org_ID])
REFERENCES [dbo].[Organization] ([Organization_ID])
GO
ALTER TABLE [dbo].[Reservation] CHECK CONSTRAINT [FK_Organization10]
GO
ALTER TABLE [dbo].[Reservation]  WITH NOCHECK ADD  CONSTRAINT [FK_Organization4] FOREIGN KEY([BCD_Rate_Org_ID])
REFERENCES [dbo].[Organization] ([Organization_ID])
GO
ALTER TABLE [dbo].[Reservation] CHECK CONSTRAINT [FK_Organization4]
GO
ALTER TABLE [dbo].[Reservation]  WITH NOCHECK ADD  CONSTRAINT [FK_Organization5] FOREIGN KEY([Referring_Org_ID])
REFERENCES [dbo].[Organization] ([Organization_ID])
GO
ALTER TABLE [dbo].[Reservation] CHECK CONSTRAINT [FK_Organization5]
GO
ALTER TABLE [dbo].[Reservation]  WITH NOCHECK ADD  CONSTRAINT [FK_Quoted_Vehicle_Rate6] FOREIGN KEY([Quoted_Rate_ID])
REFERENCES [dbo].[Quoted_Vehicle_Rate] ([Quoted_Rate_ID])
GO
ALTER TABLE [dbo].[Reservation] CHECK CONSTRAINT [FK_Quoted_Vehicle_Rate6]
GO
ALTER TABLE [dbo].[Reservation]  WITH NOCHECK ADD  CONSTRAINT [FK_Referring_Employee2] FOREIGN KEY([Referring_Employee_ID])
REFERENCES [dbo].[Referring_Employee] ([Referring_Employee_ID])
GO
ALTER TABLE [dbo].[Reservation] CHECK CONSTRAINT [FK_Referring_Employee2]
GO
ALTER TABLE [dbo].[Reservation]  WITH NOCHECK ADD  CONSTRAINT [FK_Vehicle_Class13] FOREIGN KEY([Vehicle_Class_Code])
REFERENCES [dbo].[Vehicle_Class] ([Vehicle_Class_Code])
GO
ALTER TABLE [dbo].[Reservation] CHECK CONSTRAINT [FK_Vehicle_Class13]
GO
