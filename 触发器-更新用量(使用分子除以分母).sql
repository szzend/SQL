create trigger bombatchedit_for_fdosage
on T_ENG_BOMCHILD
after update
as
begin
    --update T_ENG_BOMCHILD set FDOSAGE =FNUMERATOR/FDENOMINATOR;
	update T_ENG_BOMCHILD set FDOSAGE =FNUMERATOR/FDENOMINATOR where FENTRYID in(select FENTRYID from inserted);
	--select * from inserted;
	--select * from T_ENG_BOMCHILD where FENTRYID in(select FENTRYID from inserted);
end