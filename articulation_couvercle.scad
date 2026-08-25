use <../phgUtils_v2.scad>

$fn=64;
_EPSILON=0.1;
long=19.9;

larg=8.2;

haut_axe=8.0;

diam_axe=4.6;

haut_vis=4.0;
diam_vis=3.2;

diam_insert=4.3;
prof_insert=3;

diam_talon=4.0;
larg_talon=1.2;

difference() {
    union() {
        cub(long,larg,haut_axe);
        tr(0,larg/2,haut_axe) cylX(larg,long);
    }
    union() {
        // trou radial
        tr(-_EPSILON,larg/2,haut_axe) cylX(diam_axe,long+2*_EPSILON);
        // trou des inserts insets holes
        for (i=[1,-1]) {
            tr(long/2+i*long/4,-_EPSILON,haut_vis) cylY(diam_vis,larg+2*_EPSILON);
            tr(long/2+i*long/4,-_EPSILON,haut_vis) cylY(diam_insert,prof_insert+_EPSILON);
            tr(long/2+i*long/4,prof_insert,haut_vis) cylY(diam_talon,larg_talon);
        }
    }
}

