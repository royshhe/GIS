USE [GISData]
GO
/****** Object:  Table [dbo].[GISUsers]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GISUsers](
	[user_id] [char](20) NOT NULL,
	[user_name] [char](50) NOT NULL,
	[user_password] [char](20) NULL,
	[is_NT_account] [bit] NOT NULL,
	[active] [bit] NOT NULL,
	[user_description] [char](100) NULL,
	[EmployeeID] [char](20) NULL,
	[created_by] [char](50) NULL,
	[created_on] [datetime] NULL,
	[last_updated_by] [char](50) NULL,
	[last_updated_on] [datetime] NULL,
	[Department_ID] [smallint] NULL,
	[Hiring_Date] [datetime] NULL,
	[timestamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_GISUsers] PRIMARY KEY NONCLUSTERED 
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [IX_GISUsers] UNIQUE NONCLUSTERED 
(
	[user_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[GISUsers] ADD  CONSTRAINT [DF_GISUsers_Hiring_Date]  DEFAULT (getdate()) FOR [Hiring_Date]
GO
