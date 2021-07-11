USE [GISData]
GO
/****** Object:  Table [dbo].[Vehicle_Licence_History]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Vehicle_Licence_History](
	[Unit_Number] [int] NOT NULL,
	[Licence_Plate_Number] [varchar](20) NOT NULL,
	[Attached_On] [datetime] NOT NULL,
	[Removed_On] [datetime] NULL,
	[Licencing_Province_State] [varchar](20) NOT NULL,
	[Comment] [varchar](255) NULL,
	[Changed_By] [varchar](25) NULL,
 CONSTRAINT [PK_Vehicle_Licence_History] PRIMARY KEY CLUSTERED 
(
	[Unit_Number] ASC,
	[Licence_Plate_Number] ASC,
	[Attached_On] ASC,
	[Licencing_Province_State] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [_dta_index_Vehicle_Licence_History_5_370100359__K1_K4_K3_K2]    Script Date: 2021-07-10 1:50:47 PM ******/
CREATE NONCLUSTERED INDEX [_dta_index_Vehicle_Licence_History_5_370100359__K1_K4_K3_K2] ON [dbo].[Vehicle_Licence_History]
(
	[Unit_Number] ASC,
	[Removed_On] ASC,
	[Attached_On] ASC,
	[Licence_Plate_Number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [_dta_index_Vehicle_Licence_History_5_370100359__K2_K1_K3_K4]    Script Date: 2021-07-10 1:50:47 PM ******/
CREATE NONCLUSTERED INDEX [_dta_index_Vehicle_Licence_History_5_370100359__K2_K1_K3_K4] ON [dbo].[Vehicle_Licence_History]
(
	[Licence_Plate_Number] ASC,
	[Unit_Number] ASC,
	[Attached_On] ASC,
	[Removed_On] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Vehicle_Licence_History]  WITH NOCHECK ADD  CONSTRAINT [FK_Vehicle10] FOREIGN KEY([Unit_Number])
REFERENCES [dbo].[Vehicle] ([Unit_Number])
GO
ALTER TABLE [dbo].[Vehicle_Licence_History] CHECK CONSTRAINT [FK_Vehicle10]
GO
