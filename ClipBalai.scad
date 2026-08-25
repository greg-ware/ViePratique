/*  Clip Balai 
 *  Permet de clipper un balai et sa balayette ensemble...
 *
 *  Very simple parametric broom stick clip 
 *  Allows to clip a broom and its shovel together
 *
 * History
 * Date         Author      Description
 * 2018/05/07   Ph.Gregoire Initial and final design
 *
 *  This work is licensed under the 
 *  Creative Commons Attribution 3.0 Unported License.
 *  To view a copy of this license, visit
 *    http://creativecommons.org/licenses/by/3.0/ 
 *  or send a letter to 
 *    Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
    
*/

// Thickness
thk=5;

// Inner diameter of clip (outer diameter of sticks)
d=21.5;

// height
h=20;

// rounding diameter
rounding=2;

// Rotation
rot=3.8;

// Epsilon
eps=0.1;

// test flag
test=$preview;
test=false;
echo(test);

// Facets
$fn=test?8:24;
//$fn=24;

module mink() {
    if (test)
        children();
    else
    minkowski() {
        children();
        sphere(r=rounding);
    }
}

/* Make one clip */
module clip(trX,alpha) {
    h2=h*(1+2*sin(alpha));
    
    mink()
    //union() {
    intersection() {
        cube([d+thk*2,d+thk*2,h],center=true);
        rotate([alpha,0,0]) translate([0,0,-h2/2])
        difference() {
            // Main outer cylinder
            cylinder(d=d+2*thk-2*rounding,h=h2);
            
            // minus inner cylinder
            cylinder(d=d+2*rounding,h=h2+eps);
            
            // and side apertures
            translate([trX,0,0])
                cylinder(d=2*d,h=h2);
        }
    }
}

/* Assemble two clips back-to-back */
union() {
    translate([+d/2+thk/2,0,0]) color("green") clip(d,rot);
    translate([-d/2-thk/2,0,0]) color("blue") rotate([0,0,180]) clip(d,rot);
    
}

//rotate([7.6,0,0]) clipM(d);