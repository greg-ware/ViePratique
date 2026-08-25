_rounding=1;
_width=10;
//_stepH=1.5;
//_stepCnt=5;
_stepH=2;
_stepCnt=5;
_dMin=6;
_dMax=10;
_dHole=4;
_hHollow=5;
_dHollow=6;
_htp=1;

module tipStepped(stepCnt,w,h,dMax,dMin) {
    for(e=[0:1:stepCnt-1]) {
        translate([0,0,e*h]) {
            cylinder(d1=dMax,d2=dMin,h);
        }
    }
}

module tipSpiral(stepCnt,w,h,dMax,dMin) {
    cylinder(d=dMin,h=h*stepCnt);
    linear_extrude(height = h*stepCnt, center = false, convexity = 10, twist = -360*stepCnt) {
        translate([dMin/2, 0, 0])
            circle(d = dMax-dMin,$fn=3);
    }
}

use <Screw_Library/Thread_Library.scad>;
module tipScrewed(stepCnt,w,h,dMax,dHole,htp) {
    difference() {
        intersection() {
            translate([0,0,-h])
            trapezoidThread(
                length=h*stepCnt+h, 			// axial length of the threaded rod 
                pitch=h, 			// axial distance from crest to crest
                pitchRadius=dMax/2-h/2*htp, 	// radial distance from center to mid-profile
                threadHeightToPitch=htp, 	// ratio between the height of the profile and the pitch 
                                    // std value for Acme or metric lead screw is 0.5
                profileRatio=0.0, 			// ratio between the lengths of the raised part of the profile and the pitch
                                    // std value for Acme or metric lead screw is 0.5
                threadAngle=90,			// angle between the two faces of the thread 
                                    // std value for Acme is 29 or for metric lead screw is 30
                RH=true, 				// true/false the thread winds clockwise looking along shaft, i.e.follows the Right Hand Rule
                clearance=0.1, 			// radial clearance, normalized to thread height
                backlash=0.1, 			// axial clearance, normalized to pitch
                stepsPerTurn=24 			// number of slices to create per turn
                );
            union() {
                s=dMax;
                //s=w;
                cylinder(d=s,h=h*stepCnt-h);
                translate([0,0,h*stepCnt-h]) cylinder(d1=s,d2=dHole,h=h);
            }
        }
    }
}

module bitonio(w=_width,h=_stepH,dMin=_dMin,dMax=_dMax,stepCnt=_stepCnt,dHole=_dHole,dHollow=_dHollow,hHollow=_hHollow,rounding=_rounding,htp=_htp) {
    difference() {
        union() {
            translate([-w/2+rounding,-w/2+rounding]) {
                minkowski() {
                    union() {
                        cube([w-2*rounding,w-2*rounding,w]);
                        steps=5;
                        for(z=[-1:steps-1]) {
                            dz=(steps-z)*rounding/steps;
                            translate([-rounding+dz/2,-rounding+dz/2,w-dz]) {
                                cube([w-dz,w-dz,rounding/steps]);
                            }
                        }
                    }
                    cylinder(r=rounding);
                }
            }
            translate([0,0,w]) {
                //tipStepped(stepCnt,w,h,dMax,dMin);
                //tipSpiral(stepCnt,w,h,dMax,dMin);
                tipScrewed(stepCnt,w,h,dMax,dHole,htp);
            }

        }
        $fn=24;
        cylinder(d=_dHole,h=w+stepCnt*h);
        cylinder(d=dHollow,h=hHollow);
        translate([0,0,hHollow]) {
            cylinder(d1=dHollow,d2=dHole,h=hHollow);
        }
    }
}

bitonio();

module test() {
linear_extrude(height = 10, center = false, convexity = 10, twist = -360*2, slices = 100)
translate([2, 1, 0]) rotate([45,0,0])
circle(r = 1);
}
//translate([0,0,_width+_stepH*_stepCnt]) test();
