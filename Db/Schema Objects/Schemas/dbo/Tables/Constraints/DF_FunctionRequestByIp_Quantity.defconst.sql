ALTER TABLE [dbo].[FunctionRequestByIp]
    ADD CONSTRAINT [DF_FunctionRequestByIp_Quantity] DEFAULT ((0)) FOR [Quantity];

