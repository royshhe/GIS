USE [GISData]
GO
/****** Object:  Table [dbo].[Reservation_Dep_Payment]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Reservation_Dep_Payment](
	[Confirmation_Number] [int] NOT NULL,
	[Collected_On] [datetime] NOT NULL,
	[Sequence] [smallint] NOT NULL,
	[Payment_Type] [varchar](20) NOT NULL,
	[Amount] [decimal](9, 2) NULL,
	[Collected_By] [varchar](20) NULL,
	[RBR_Date] [datetime] NULL,
	[Forfeited] [bit] NOT NULL,
	[Refunded] [bit] NOT NULL,
	[Collected_At_Location_ID] [smallint] NOT NULL,
	[Business_Transaction_ID] [int] NOT NULL,
	[Refunded_Receipt_Ref_Num] [varchar](20) NULL,
 CONSTRAINT [PK_Reservation_Dep_Payment] PRIMARY KEY CLUSTERED 
(
	[Confirmation_Number] ASC,
	[Collected_On] ASC,
	[Sequence] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Reservation_Dep_Payment] ADD  DEFAULT (0) FOR [Forfeited]
GO
ALTER TABLE [dbo].[Reservation_Dep_Payment] ADD  DEFAULT (0) FOR [Refunded]
GO
ALTER TABLE [dbo].[Reservation_Dep_Payment]  WITH CHECK ADD  CONSTRAINT [FK_Business_Transaction3] FOREIGN KEY([Business_Transaction_ID])
REFERENCES [dbo].[Business_Transaction] ([Business_Transaction_ID])
GO
ALTER TABLE [dbo].[Reservation_Dep_Payment] CHECK CONSTRAINT [FK_Business_Transaction3]
GO
ALTER TABLE [dbo].[Reservation_Dep_Payment]  WITH NOCHECK ADD  CONSTRAINT [FK_Location33] FOREIGN KEY([Collected_At_Location_ID])
REFERENCES [dbo].[Location] ([Location_ID])
GO
ALTER TABLE [dbo].[Reservation_Dep_Payment] CHECK CONSTRAINT [FK_Location33]
GO
ALTER TABLE [dbo].[Reservation_Dep_Payment]  WITH CHECK ADD  CONSTRAINT [FK_Reservation3] FOREIGN KEY([Confirmation_Number])
REFERENCES [dbo].[Reservation] ([Confirmation_Number])
GO
ALTER TABLE [dbo].[Reservation_Dep_Payment] CHECK CONSTRAINT [FK_Reservation3]
GO
