USE [GISData]
GO
/****** Object:  Table [dbo].[Charge_Parameter]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Charge_Parameter](
	[Charge_Type] [char](3) NOT NULL,
	[Location_Fee] [bit] NOT NULL,
	[License_Fee] [bit] NOT NULL,
	[HST_Exempt] [bit] NOT NULL,
	[HST2_Exempt] [bit] NOT NULL,
	[PST_Exempt] [bit] NULL,
	[HST_Incl] [bit] NULL,
	[PST_Incl] [bit] NULL,
 CONSTRAINT [PK_Charge_Parameter] PRIMARY KEY NONCLUSTERED 
(
	[Charge_Type] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Charge_Parameter] ADD  CONSTRAINT [DF_Charge_Parameter_Location_Fee]  DEFAULT (0) FOR [Location_Fee]
GO
ALTER TABLE [dbo].[Charge_Parameter] ADD  CONSTRAINT [DF__Charge_Pa__Licen__00C0BC94]  DEFAULT (0) FOR [License_Fee]
GO
