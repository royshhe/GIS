USE [GISData]
GO
/****** Object:  Table [dbo].[Chargeable_Parameter]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Chargeable_Parameter](
	[Charge_Type] [char](2) NOT NULL,
	[Chargeable_Type] [char](2) NOT NULL
) ON [PRIMARY]
GO
