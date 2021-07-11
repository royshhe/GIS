USE [GISData]
GO
/****** Object:  Table [dbo].[FA_PDI_Performer]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FA_PDI_Performer](
	[Performer_Code] [char](25) NOT NULL,
	[AP_Vendor_Code] [varchar](12) NULL,
	[Performer_Name] [varchar](50) NULL,
 CONSTRAINT [PK_FA_PDI_Performer] PRIMARY KEY CLUSTERED 
(
	[Performer_Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
