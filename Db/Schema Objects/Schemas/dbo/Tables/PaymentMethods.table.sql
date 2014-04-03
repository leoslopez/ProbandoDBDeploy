CREATE TABLE [dbo].[PaymentMethods] (
    [IdPaymentMethod]   INT           IDENTITY (1, 1) NOT NULL,
    [PaymentMethodName] VARCHAR (50)  NULL,
    [DescriptionES]     VARCHAR (100) NULL,
    [DescriptionEN]     VARCHAR (100) NULL,
    [Active]            BIT           NOT NULL
);



