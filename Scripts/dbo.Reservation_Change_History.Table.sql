USE [GISData]
GO
/****** Object:  Table [dbo].[Reservation_Change_History]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Reservation_Change_History](
	[Confirmation_Number] [int] NOT NULL,
	[Changed_By] [varchar](20) NOT NULL,
	[Changed_On] [datetime] NOT NULL,
	[Pick_Up_Location_ID] [smallint] NULL,
	[Pick_Up_On] [datetime] NULL,
	[Drop_Off_Location_ID] [smallint] NULL,
	[Drop_Off_On] [datetime] NULL,
	[Vehicle_Class_Code] [char](1) NULL,
	[Last_Name] [varchar](25) NULL,
	[First_Name] [varchar](25) NULL,
	[Rate_ID] [int] NULL,
	[Date_Rate_Assigned] [datetime] NULL,
	[Rate_Level] [char](1) NULL,
	[Status] [char](1) NULL,
 CONSTRAINT [PK_Reservation_Change_History] PRIMARY KEY CLUSTERED 
(
	[Confirmation_Number] ASC,
	[Changed_By] ASC,
	[Changed_On] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [_dta_index_Reservation_Change_History_7_1861581670__K1_K14_K3]    Script Date: 2021-07-10 1:50:47 PM ******/
CREATE NONCLUSTERED INDEX [_dta_index_Reservation_Change_History_7_1861581670__K1_K14_K3] ON [dbo].[Reservation_Change_History]
(
	[Confirmation_Number] ASC,
	[Status] ASC,
	[Changed_On] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [_dta_index_Reservation_Change_History_7_1861581670__K14]    Script Date: 2021-07-10 1:50:47 PM ******/
CREATE NONCLUSTERED INDEX [_dta_index_Reservation_Change_History_7_1861581670__K14] ON [dbo].[Reservation_Change_History]
(
	[Status] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
/****** Object:  Index [_dta_index_Reservation_Change_History_7_1861581670__K3_K1]    Script Date: 2021-07-10 1:50:47 PM ******/
CREATE NONCLUSTERED INDEX [_dta_index_Reservation_Change_History_7_1861581670__K3_K1] ON [dbo].[Reservation_Change_History]
(
	[Changed_On] ASC,
	[Confirmation_Number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Reservation_Change_History]  WITH NOCHECK ADD  CONSTRAINT [FK_Reservation5] FOREIGN KEY([Confirmation_Number])
REFERENCES [dbo].[Reservation] ([Confirmation_Number])
GO
ALTER TABLE [dbo].[Reservation_Change_History] CHECK CONSTRAINT [FK_Reservation5]
GO
