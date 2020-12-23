CREATE TABLE [Master].[Warehouse] (
    [ID]                   INT   IDENTITY (1, 1) NOT NULL,
    [ProductsID]           INT   NULL,
    [ConfigurationModelId] INT   NULL,
    [ReceivingDate]        DATE  NULL,
    [StartVersion]         INT   NULL,
    [EndVersion]           INT   DEFAULT ((999999999)) NULL,
    [Price]                MONEY NULL
    CONSTRAINT [PK_Master_Warehouse] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_C_Version_Warehouse] FOREIGN KEY ([StartVersion]) REFERENCES [Config].[Version] ([Id]),
    CONSTRAINT [FK_G_Products_Warehouse] FOREIGN KEY ([ProductsID]) REFERENCES [Master].[Products] ([ID]),
    CONSTRAINT [FK_M_ConfigurationModels_Warehouse] FOREIGN KEY ([ConfigurationModelId]) REFERENCES [Master].[ConfigurationModels] ([Id])
);

