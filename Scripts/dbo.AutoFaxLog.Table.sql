USE [GISData]
GO
/****** Object:  Table [dbo].[AutoFaxLog]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AutoFaxLog](
	[control_ID] [int] IDENTITY(1,1) NOT NULL,
	[message_ID] [int] NOT NULL,
	[process_date] [datetime] NOT NULL,
	[fax_control_id] [int] NULL,
	[contract_number] [int] NULL,
	[contract_rbr_date] [datetime] NULL,
	[try_times] [int] NULL,
	[fax_status_code] [char](10) NULL,
	[recieve_fax_no] [char](30) NULL,
	[add_error_msg] [char](200) NULL,
	[last_updated_by] [char](20) NULL,
	[last_updated_on] [datetime] NULL,
	[timestamp] [timestamp] NULL,
 CONSTRAINT [PK_autofaxlog] PRIMARY KEY CLUSTERED 
(
	[control_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [autofaxlogprocessdateIX]    Script Date: 2021-07-10 1:50:47 PM ******/
CREATE NONCLUSTERED INDEX [autofaxlogprocessdateIX] ON [dbo].[AutoFaxLog]
(
	[process_date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AutoFaxLog]  WITH CHECK ADD  CONSTRAINT [FK_processstatus_log] FOREIGN KEY([message_ID])
REFERENCES [dbo].[AutoFaxMsg] ([message_number])
GO
ALTER TABLE [dbo].[AutoFaxLog] CHECK CONSTRAINT [FK_processstatus_log]
GO
