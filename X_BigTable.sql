CREATE PROCEDURE XSP_BIGTABLE (@numrows int = 1000)
AS
BEGIN

	DECLARE @empid int = 1
	DECLARE @rows int = 0

	SET NOCOUNT ON;

	SELECT @rows = COUNT(*) FROM CONTATOS

	IF @rows > 0 
		BEGIN
			set @empid = @rows + 1
			if @rows > @numrows set @numrows = @rows * 2
		END

	WHILE @empid <= @numrows
		BEGIN

			INSERT CONTATOS (id,nome,celular,email) 
			VALUES (@empid,'NOME_' + CAST(@empid AS VARCHAR(45)),CAST(@empid AS VARCHAR(10)),'EMAIL_' + CAST(@empid AS VARCHAR(144)))
			
			SET @empid += 1;
		END;
		
	SET NOCOUNT OFF;
	
	SELECT COUNT(*) AS [LINHAS INSERIDAS] FROM CONTATOS			
END