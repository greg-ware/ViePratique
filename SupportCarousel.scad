use <../phgUtils_v2.scad>

HAUTEUR = 30;
DIAM_INT = 20;
EPAISSEUR = 6;

DIAM_EMBASE = 50;
EP_EMBASE = 5;
DIAM_VIS_EMBASE = 4;
EP_AILETTE = 3;

DIAM_VIS = 3;

$fn=36;

module corps() {
        cyl(DIAM_INT + 2* EPAISSEUR, HAUTEUR);
}


module embase() {
    difference() {
        cyl(DIAM_EMBASE,EP_EMBASE);
        r=DIAM_INT/2+EPAISSEUR+(DIAM_EMBASE/2-DIAM_INT/2-EPAISSEUR)/2;
        for(a=[45,135]) {
            #tr(r*cos(a),r*sin(a),EP_EMBASE) rot(180) screw_well(DIAM_VIS_EMBASE,EP_EMBASE);
            tr(r*cos(a),r*sin(a)) cyl(DIAM_VIS_EMBASE,EP_EMBASE);
        }
    }
}

module support() {
    intersection() {
        union() {
            difference() {
            intersection() {
                union() {corps(); embase();}
                trcube(-DIAM_EMBASE/2,0,0,DIAM_EMBASE, DIAM_EMBASE/2, HAUTEUR);
            }
            cyl(DIAM_INT, HAUTEUR);
            }
        ailette();
        mirror([1,0,0]) ailette();
        }
        cyl(DIAM_EMBASE,HAUTEUR);
    }
}

module ailette() {
    _LARG_EMBASE=DIAM_EMBASE/2-DIAM_INT/2;
    tr(DIAM_INT/2,0,0)
    difference() {
        cub(_LARG_EMBASE,EP_AILETTE,HAUTEUR);
    
        for(h=[1/4,3/4])
            trrotcyl(EPAISSEUR/2+_LARG_EMBASE/2,0,HAUTEUR*h,-90,0,0,DIAM_VIS,EP_AILETTE);
     
    color("blue")
        #tr(_LARG_EMBASE,EP_AILETTE,HAUTEUR) rot() quarterCyl(5,EP_AILETTE);
    }
}


support();