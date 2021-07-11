USE [GISData]
GO
/****** Object:  Table [dbo].[AutoFaxSysError]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AutoFaxSysError](
	[control_ID] [int] IDENTITY(1,1) NOT NULL,
	[process_date] [datetime] NOT NULL,
	[last_error_number] [int] NULL,
	[last_error_source] [char](255) NULL,
	[error_message] [char](255) NULL,
	[last_updated_by] [char](20) NULL,
	[last_updated_on] [datetime] NULL,
	[timestamp] [timestamp] NULL,
 CONSTRAINT [PK_AutoFaxSysError] PRIMARY KEY CLUSTERED 
(
	[control_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [autofaxerrorlogprocessdateIX]    Script Date: 2021-07-10 1:50:47 PM ******/
CREATE NONCLUSTERED INDEX [autofaxerrorlogprocessdateIX] ON [dbo].[AutoFaxSysError]
(
	[process_date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
