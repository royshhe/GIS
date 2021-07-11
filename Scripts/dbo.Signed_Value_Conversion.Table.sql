USE [GISData]
GO
/****** Object:  Table [dbo].[Signed_Value_Conversion]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Signed_Value_Conversion](
	[Terminal_Value] [char](1) NOT NULL,
	[Unit_Value] [char](1) NULL,
	[Field_Value_Sign] [char](1) NULL,
 CONSTRAINT [PK_Signed_Value_Conversion] PRIMARY KEY CLUSTERED 
(
	[Terminal_Value] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
