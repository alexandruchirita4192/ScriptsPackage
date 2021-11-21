if object_id('USP_GetConfigTableData') is not null
	drop procedure USP_GetConfigTableData;
go
create procedure USP_GetConfigTableData
as
begin 
	select * from ConfigTable
end
go
