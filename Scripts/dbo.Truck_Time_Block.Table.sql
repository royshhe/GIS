USE [GISData]
GO
/****** Object:  Table [dbo].[Truck_Time_Block]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Truck_Time_Block](
	[Owning_Company_ID] [int] NOT NULL,
	[Block_Type] [char](10) NOT NULL,
	[Block_Name] [char](10) NOT NULL,
	[Block_Time] [char](10) NULL,
	[Block_Start] [char](10) NULL,
	[Block_End] [char](10) NULL,
 CONSTRAINT [PK_Truck_Time_Block] PRIMARY KEY CLUSTERED 
(
	[Owning_Company_ID] ASC,
	[Block_Name] ASC,
	[Block_Type] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
