USE [GISData]
GO
/****** Object:  Table [dbo].[AutoFax]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AutoFax](
	[fax_control_ID] [int] IDENTITY(1,1) NOT NULL,
	[ref_control_ID] [int] NOT NULL,
	[create_date] [datetime] NOT NULL,
	[contract_number] [int] NOT NULL,
	[response_id] [int] NOT NULL,
	[reciever_fax_no] [char](30) NOT NULL,
	[reciever_id] [char](50) NULL,
	[reciever_name] [char](50) NULL,
	[process_status] [int] NOT NULL,
	[contract_rbr_date] [datetime] NOT NULL,
	[fax_type] [int] NOT NULL,
	[send_try_times] [int] NOT NULL,
	[contract_status] [char](2) NOT NULL,
	[expect_send_date] [datetime] NOT NULL,
	[latest_try_date] [datetime] NULL,
	[success_send_date] [datetime] NULL,
	[priority] [int] NOT NULL,
	[submit_status_code] [int] NULL,
	[fax_status_code] [char](10) NULL,
	[success_dele_file_falg] [char](1) NOT NULL,
	[fax_subject] [char](100) NULL,
	[sender_full_name] [char](100) NULL,
	[sender_comany_name] [char](100) NULL,
	[sender_tele_no] [char](100) NULL,
	[send_fax_no] [char](100) NULL,
	[sender_voice_no] [char](100) NULL,
	[pcl_file_name] [char](100) NULL,
	[send_device_name] [char](100) NULL,
	[control_status] [int] NOT NULL,
	[last_updated_by] [char](20) NULL,
	[last_updated_on] [datetime] NULL,
	[timestamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_autofax] PRIMARY KEY CLUSTERED 
(
	[fax_control_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_AutoFax]    Script Date: 2021-07-10 1:50:47 PM ******/
CREATE NONCLUSTERED INDEX [IX_AutoFax] ON [dbo].[AutoFax]
(
	[contract_number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AutoFax]  WITH CHECK ADD  CONSTRAINT [FK_faxtype_fax] FOREIGN KEY([fax_type])
REFERENCES [dbo].[AutoFaxType] ([type_ID])
GO
ALTER TABLE [dbo].[AutoFax] CHECK CONSTRAINT [FK_faxtype_fax]
GO
ALTER TABLE [dbo].[AutoFax]  WITH CHECK ADD  CONSTRAINT [FK_processstatus_fax] FOREIGN KEY([process_status])
REFERENCES [dbo].[AutoFaxMsg] ([message_number])
GO
ALTER TABLE [dbo].[AutoFax] CHECK CONSTRAINT [FK_processstatus_fax]
GO
ALTER TABLE [dbo].[AutoFax]  WITH CHECK ADD  CONSTRAINT [FK_refcontrolid_fax] FOREIGN KEY([ref_control_ID])
REFERENCES [dbo].[AutoFaxContract] ([control_ID])
GO
ALTER TABLE [dbo].[AutoFax] CHECK CONSTRAINT [FK_refcontrolid_fax]
GO
