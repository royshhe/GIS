USE [GISData]
GO
/****** Object:  Table [dbo].[PM_Schedule_Service]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PM_Schedule_Service](
	[Schedule_Service_id] [int] IDENTITY(1,1) NOT NULL,
	[Schedule_ID] [int] NULL,
	[Service_Code] [char](10) NULL,
	[Type] [char](10) NULL,
	[Enabled] [bit] NOT NULL,
	[Mileage_Tracking] [bit] NOT NULL,
	[Recurring_Mileage] [int] NULL,
	[Advance_Notification_Mileage] [int] NULL,
	[Mileage_Overdue_Restrict] [bit] NULL,
	[Date_Tracking] [bit] NOT NULL,
	[Recurring_Time] [int] NULL,
	[Tracking_Time_Unit] [char](10) NULL,
	[Advance_Notification_Days] [int] NULL,
	[Date_Overdue_Restrict] [bit] NULL,
 CONSTRAINT [PK_VM_PM_Schedule_Service] PRIMARY KEY CLUSTERED 
(
	[Schedule_Service_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
