select 
bom.FNUMBER as BOM_VER,1 as BOM_LEVEL,child.FMATERIALID,m.FNUMBER,
(select FNUMBER from T_ENG_BOM where FID=child.FBOMID) as child_bom_ver,
child.FUNITID,child.FNUMERATOR,FDENOMINATOR
from T_ENG_BOMCHILD child inner join T_ENG_BOM bom on bom.FID=child.FID
inner join T_BD_MATERIAL m on child.FMATERIALID=m.FMATERIALID
order by BOM_VER;