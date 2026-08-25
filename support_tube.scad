// --- PARAMÈTRES RÉGLABLES ---
$fn = 100;                  // Résolution des cylindres

// Dimensions du tuyau
d_tuyau = 50;               // Diamètre extérieur du tuyau (mm)
epaisseur_bride = 4;        // Épaisseur du plastique autour du tuyau (mm)
largeur_bride = 15;         // Largeur de la bride (mm)

// Dimensions du passage de l'attache-câble (Serflex / Colson)
largeur_collier = 9;        // Largeur max du collier (mm)
epaisseur_collier = 2.5;    // Épaisseur max du collier (mm)

// Dimensions de l'embase de fixation (vis)
d_vis = 4.5;                // Diamètre du trou de vis (mm)
d_fraisage = 9;             // Diamètre de la tête de vis (mm)
profondeur_fraisage = 3;    // Profondeur du fraisage (mm)
hauteur_embase = 8;         // Hauteur de la base sous le tuyau (mm)

// --- CODE DU MODÈLE ---
difference() {
    // 1. Forme extérieure globale (Embase + Corps arrondi)
    union() {
        // Base plate pour la fixation au mur
        translate([-largeur_bride/2, -d_tuyau/2 - epaisseur_bride - hauteur_embase, 0])
            cube([largeur_bride, hauteur_embase + epaisseur_bride, largeur_bride]);
        
        // Cylindre extérieur
        cylinder(d = d_tuyau + (epaisseur_bride * 2), h = largeur_bride, center = false);
    }
    
    // 2. Passage du tuyau (Cylindre intérieur)
    translate([0, 0, -1])
        cylinder(d = d_tuyau, h = largeur_bride + 2);
    
    // 3. Ouverture supérieure (Permet de clipser le tuyau)
    translate([-d_tuyau, 0, -1])
        cube([d_tuyau * 2, d_tuyau, largeur_bride + 2]);
    
    // 4. Canal de guidage pour l'attache-câble
    difference() {
        translate([0, 0, (largeur_bride - largeur_collier) / 2])
            cylinder(d = d_tuyau + epaisseur_collier * 2, h = largeur_collier);
        translate([0, 0, -1])
            cylinder(d = d_tuyau - 1, h = largeur_bride + 2);
    }
    
    // 5. Trou de fixation pour la vis (dans l'embase)
    translate([0, -d_tuyau/2 - hauteur_embase - 1, largeur_bride / 2])
        rotate([-90, 0, 0]) {
            // Trou débouchant pour le corps de la vis
            cylinder(d = d_vis, h = hauteur_embase + epaisseur_bride + 2);
            // Fraisage pour masquer la tête de vis
            translate([0, 0, hauteur_embase + epaisseur_bride + 1 - profondeur_fraisage])
                cylinder(d1 = d_vis, d2 = d_fraisage, h = profondeur_fraisage + 0.1);
        }
}
