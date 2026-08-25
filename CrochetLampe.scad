use <../phgUtils_v2.scad>

LARG=40;

DIAM_PLAQUE_EXT=70;
EP_PLAQUE_EXT=4;
DIAM_PLAQUE_INT=55;
EP_PLAQUE_INT=3;
EP_CONTOUR_INT=3;

DIAM_PERFO=5.6;

DIAM_VIS=3.6;
ECART_VIS=24.5;

HAUT_PUIT=12;
LARG_PUIT=25;
PROF_PUIT=12;
ECART_PUIT=15;
EP_PUIT=4;

EP_INCLINE=2;
ANGLE_PUIT=5;

DIAM_TETE_CROCHET=20;
DIAM_TETE_VIS=9.6;

$fn=64;

module enveloppe() {
    cube([LARG,DIAM_PLAQUE_EXT,1000],center=true);
}

module plaque_ext() {
    intersection() {
        cyl(DIAM_PLAQUE_EXT,EP_PLAQUE_EXT);
        enveloppe();
    }
}

module contour_int() {
    projection() intersection() {
        cyl(DIAM_PLAQUE_INT,EP_PLAQUE_INT);
        enveloppe();
    }
}

module shearY(angle) {
    multmatrix([
        [1,0,0,0],
        [0,1,sin(angle),0],
        [0,0,1,0]
    ]) children();
}

module plaque_int() {
    trZ(EP_PLAQUE_EXT)
    difference() {
        linear_extrude(EP_PLAQUE_INT) 
        difference() {  // contour
            contour_int();
            offset(-EP_CONTOUR_INT) contour_int();
        }
        // Encoches de puits
        for(i=[1,0])
            mirror([0,i,0])
            trcube(-LARG_PUIT/2+EP_PUIT,ECART_PUIT+EP_PUIT,0,
                    LARG_PUIT-2*EP_PUIT,PROF_PUIT,EP_PLAQUE_INT);
    }
}

module plaque() {
    ep=EP_PLAQUE_EXT+EP_PLAQUE_INT;
    difference() {
        union() {
            plaque_ext();
            plaque_int();
            trcyl(0,0,EP_PLAQUE_EXT,DIAM_TETE_CROCHET,EP_PLAQUE_INT);
        }
        // perforations
        cyl(DIAM_PERFO,ep);
        tr(0,ECART_VIS) cyl(DIAM_VIS,ep);
        tr(0,-ECART_VIS) cyl(DIAM_VIS,ep);
        // Tete vis
        trcyl(0,0,EP_PLAQUE_EXT,DIAM_TETE_VIS,EP_PLAQUE_INT,fn=6);
    }
}


module puit() {
    trZ(-EP_PLAQUE_INT)
    difference() {
        linear_extrude(HAUT_PUIT+EP_PLAQUE_INT)
            poly([0,0, LARG_PUIT/2,0,
                LARG_PUIT/2,PROF_PUIT,
                LARG_PUIT/2-EP_PUIT,PROF_PUIT,
                LARG_PUIT/2-EP_PUIT,EP_PUIT,
                -LARG_PUIT/2+EP_PUIT,EP_PUIT,
                -LARG_PUIT/2+EP_PUIT,PROF_PUIT,
                -LARG_PUIT/2,PROF_PUIT,
                -LARG_PUIT/2,0,
            ]);
        // parois inclinees puits
        shearY(-ANGLE_PUIT)
       trcube(-LARG_PUIT/2+EP_PUIT,EP_PUIT,0,
                    LARG_PUIT-2*EP_PUIT,EP_INCLINE,EP_PLAQUE_INT+HAUT_PUIT);
    }
}


plaque();
tr(0,ECART_PUIT,EP_PLAQUE_EXT+EP_PLAQUE_INT) puit();
tr(0,-ECART_PUIT,EP_PLAQUE_EXT+EP_PLAQUE_INT) mirror([0,1,0]) puit();

