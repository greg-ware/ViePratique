use <../phgUtils_v2.scad>

$fn=64;

haut=15;
long=40.8;
larg=9.8;

pos_encoche=20.2;
larg_encoche=4.2;
haut_encoche=9.2;

diam_tige=4.3;
haut_tige=haut_encoche+diam_tige/2;
prof_tige=larg/2;//-diam_tige/2;

pos_evid=20.2+larg_encoche+1;
prof_evid=prof_tige+diam_tige/2;
haut_evid=haut-haut_encoche;

mirror([0,1,0])
difference() {
    cube([long,larg,haut]);
    trcube(pos_encoche,-$EPS(),0,larg_encoche,larg+2*$EPS(),haut_encoche);
    trcube(pos_evid,-$EPS(),haut-haut_evid,long-pos_evid+$EPS(),
    prof_evid,haut_evid+$EPS());
    tr(0,prof_tige,haut_tige) rotY() trcyl(0,0,0,diam_tige,long,center=false);
}