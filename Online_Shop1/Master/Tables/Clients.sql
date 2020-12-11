CREATE TABLE [Master].[Clients] (
    [Id]        INT           IDENTITY (1, 1) NOT NULL,
    [FirstName] VARCHAR (50)  NULL,
    [LastName]  VARCHAR (50)  NULL,
    [Email]     VARCHAR (100) NULL,
    [Phone]     VARCHAR (30)  NULL,
    [AddressID] INT           NULL,
    CONSTRAINT [PK_Master_Clients] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_U_Clients_Address] FOREIGN KEY ([AddressID]) REFERENCES [Master].[Address] ([Id])
);

