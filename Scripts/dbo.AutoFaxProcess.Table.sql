USE [GISData]
GO
/****** Object:  Table [dbo].[AutoFaxProcess]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AutoFaxProcess](
	[rbr_date] [datetime] NOT NULL,
	[process_status] [int] NOT NULL,
	[process_times] [int] NULL,
	[last_updated_by] [char](20) NULL,
	[last_updated_on] [datetime] NULL,
	[timestamp] [timestamp] NULL,
 CONSTRAINT [PK_AutoFaxProcess] PRIMARY KEY CLUSTERED 
(
	[rbr_date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AutoFaxProcess]  WITH CHECK ADD  CONSTRAINT [FK_processstatus_process] FOREIGN KEY([process_status])
REFERENCES [dbo].[AutoFaxMsg] ([message_number])
GO
ALTER TABLE [dbo].[AutoFaxProcess] CHECK CONSTRAINT [FK_processstatus_process]
GO
