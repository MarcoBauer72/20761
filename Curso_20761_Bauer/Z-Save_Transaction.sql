create table  #pessoas (
	id int primary key , 
	nome varchar(50)
	)
	
Begin try 
	begin transaction a1
		insert into #pessoas select 1 , 'Rafael'
		insert into #pessoas select 2 , 'Antonio'
		
		save transaction a1
		Begin try 		
				insert into #pessoas select 2 , 'Maria'
				
		end try 
		begin catch
			print 'rollback save a1'
			rollback transaction a1
		end catch
	print 'commit a1'
	commit transaction a1
end try 
begin catch
	print 'rollback a1'
	rollback transaction a1
end catch

--select * from #pessoas
--select @@TRANCOUNT
--drop table #pessoas
--delete from #pessoal

