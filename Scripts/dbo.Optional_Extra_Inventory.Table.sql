USE [GISData]
GO
/****** Object:  Table [dbo].[Optional_Extra_Inventory]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Optional_Extra_Inventory](
	[Unit_Number] [varchar](12) NOT NULL,
	[Serial_Number] [varchar](12) NOT NULL,
	[Optional_Extra_ID] [int] NOT NULL,
	[Owning_Location] [smallint] NULL,
	[Deleted_Flag] [bit] NULL,
	[Optional_Extra_Type] [varchar](20) NULL,
	[Owning_Company_ID] [int] NULL,
	[Current_Item_Status] [char](1) NULL,
	[Status_Effective_On] [datetime] NULL,
	[Purchase_Date] [datetime] NULL,
	[Shop] [varchar](25) NULL,
	[Invoice_Number] [varchar](25) NULL,
	[Deleted_On] [datetime] NULL,
	[Last_Update_By] [varchar](30) NULL,
	[Last_Update_On] [datetime] NULL,
	[Expiry_Date] [datetime] NULL,
 CONSTRAINT [PK_Optional_Extra_Inventory] PRIMARY KEY CLUSTERED 
(
	[Unit_Number] ASC,
	[Optional_Extra_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Optional_Extra_Inventory] ADD  CONSTRAINT [DF_GPS_Deleted_Flag]  DEFAULT (0) FOR [Deleted_Flag]
GO
ALTER TABLE [dbo].[Optional_Extra_Inventory] ADD  CONSTRAINT [DF_Optional_Extra_Inventory_Owning_Company_ID]  DEFAULT (7425) FOR [Owning_Company_ID]
GO
ALTER TABLE [dbo].[Optional_Extra_Inventory] ADD  CONSTRAINT [DF_Optional_Extra_Inventory_Current_Item_Status]  DEFAULT ('d') FOR [Current_Item_Status]
GO
ALTER TABLE [dbo].[Optional_Extra_Inventory] ADD  CONSTRAINT [DF_Optional_Extra_Inventory_Item_Status_Effective_On]  DEFAULT (getdate()) FOR [Status_Effective_On]
GO
ALTER TABLE [dbo].[Optional_Extra_Inventory] ADD  CONSTRAINT [DF_Optional_Extra_Inventory_Last_Update_On]  DEFAULT (getdate()) FOR [Last_Update_On]
GO
