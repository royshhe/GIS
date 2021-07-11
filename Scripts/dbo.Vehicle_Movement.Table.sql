USE [GISData]
GO
/****** Object:  Table [dbo].[Vehicle_Movement]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Vehicle_Movement](
	[Unit_Number] [int] NOT NULL,
	[Movement_In] [datetime] NULL,
	[Movement_Type] [varchar](30) NULL,
	[Sending_Location_ID] [smallint] NOT NULL,
	[Movement_Out] [datetime] NOT NULL,
	[Receiving_Location_ID] [smallint] NOT NULL,
	[Km_In] [int] NULL,
	[Km_Out] [int] NOT NULL,
	[Driver_Name] [varchar](25) NULL,
	[Remarks_Out] [varchar](255) NULL,
	[Remarks_In] [varchar](255) NOT NULL,
	[Approver_Name] [varchar](25) NOT NULL,
	[Billable] [bit] NOT NULL,
 CONSTRAINT [PK_Vehicle_Movement] PRIMARY KEY CLUSTERED 
(
	[Unit_Number] ASC,
	[Movement_Out] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [_dta_index_Vehicle_Movement_5_418100530__K5_K1_K2]    Script Date: 2021-07-10 1:50:47 PM ******/
CREATE NONCLUSTERED INDEX [_dta_index_Vehicle_Movement_5_418100530__K5_K1_K2] ON [dbo].[Vehicle_Movement]
(
	[Movement_Out] ASC,
	[Unit_Number] ASC,
	[Movement_In] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Vehicle_Movement]  WITH NOCHECK ADD  CONSTRAINT [FK_Location3] FOREIGN KEY([Receiving_Location_ID])
REFERENCES [dbo].[Location] ([Location_ID])
GO
ALTER TABLE [dbo].[Vehicle_Movement] CHECK CONSTRAINT [FK_Location3]
GO
ALTER TABLE [dbo].[Vehicle_Movement]  WITH NOCHECK ADD  CONSTRAINT [FK_Location4] FOREIGN KEY([Sending_Location_ID])
REFERENCES [dbo].[Location] ([Location_ID])
GO
ALTER TABLE [dbo].[Vehicle_Movement] CHECK CONSTRAINT [FK_Location4]
GO
ALTER TABLE [dbo].[Vehicle_Movement]  WITH NOCHECK ADD  CONSTRAINT [FK_Vehicle2] FOREIGN KEY([Unit_Number])
REFERENCES [dbo].[Vehicle] ([Unit_Number])
GO
ALTER TABLE [dbo].[Vehicle_Movement] CHECK CONSTRAINT [FK_Vehicle2]
GO
