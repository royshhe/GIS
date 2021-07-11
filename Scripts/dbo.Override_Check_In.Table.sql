USE [GISData]
GO
/****** Object:  Table [dbo].[Override_Check_In]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Override_Check_In](
	[Overridden_Contract_Number] [int] NOT NULL,
	[Unit_Number] [int] NOT NULL,
	[Checked_Out] [datetime] NOT NULL,
	[Override_Contract_Number] [int] NOT NULL,
	[Drop_Off_Location_ID] [smallint] NOT NULL,
	[Check_In] [datetime] NOT NULL,
	[Km_In] [int] NULL,
	[Fuel_Level] [char](6) NULL,
	[Fuel_Remaining] [decimal](5, 2) NULL,
	[Checked_In_By] [varchar](20) NOT NULL,
 CONSTRAINT [PK_Override_Check_In] PRIMARY KEY CLUSTERED 
(
	[Overridden_Contract_Number] ASC,
	[Unit_Number] ASC,
	[Checked_Out] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Override_Check_In]  WITH NOCHECK ADD  CONSTRAINT [FK_Contract15] FOREIGN KEY([Override_Contract_Number])
REFERENCES [dbo].[Contract] ([Contract_Number])
GO
ALTER TABLE [dbo].[Override_Check_In] CHECK CONSTRAINT [FK_Contract15]
GO
ALTER TABLE [dbo].[Override_Check_In]  WITH NOCHECK ADD  CONSTRAINT [FK_Location25] FOREIGN KEY([Drop_Off_Location_ID])
REFERENCES [dbo].[Location] ([Location_ID])
GO
ALTER TABLE [dbo].[Override_Check_In] CHECK CONSTRAINT [FK_Location25]
GO
ALTER TABLE [dbo].[Override_Check_In]  WITH NOCHECK ADD  CONSTRAINT [FK_Vehicle_On_Contract4] FOREIGN KEY([Overridden_Contract_Number], [Unit_Number], [Checked_Out])
REFERENCES [dbo].[Vehicle_On_Contract] ([Contract_Number], [Unit_Number], [Checked_Out])
NOT FOR REPLICATION 
GO
ALTER TABLE [dbo].[Override_Check_In] NOCHECK CONSTRAINT [FK_Vehicle_On_Contract4]
GO
