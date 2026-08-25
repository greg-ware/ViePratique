// --- PARAMÈTRES RÉGLABLES ---
$fn = 100;                  // Résolution des cylindres

// Dimensions du tuyau
d_tuyau = 50;               // Diamètre extérieur du tuyau (mm)
epaisseur_bride = 4;        // Épaisseur du plastique autour du tuyau (mm)
largeur_bride = 18;         // Largeur de la bride (mm) - Augmentée pour la solidité

// Dimensions du passage de l'attache-câble (Colson / Serflex)
largeur_collier = 9;        // Largeur max du collier (mm)
epaisseur_collier = 2.5;    // Épaisseur max du collier (mm)

// Dimensions de l'embase de fixation (vis)
d_vis = 4.5;                // Diamètre du trou de vis (mm)
d_fraisage = 9;             // Diamètre de la tête de vis (mm)
profondeur_fraisage = 3;    // Profondeur du fraisage (mm)
hauteur_embase = 12;        // Augmentée pour loger les canaux du collier


// --- MODULES ---

// 1. Forme extérieure brute (Support mural élargi + anneau extérieur)
module forme_exterieure() {
    // Calcul de la largeur nécessaire pour l'embase pour intégrer les canaux du collier
    largeur_embase = d_tuyau + (epaisseur_bride * 2);
    
    union() {
        // Embase plate rectangulaire
        translate([-largeur_embase/2, -d_tuyau/2 - epaisseur_bride - hauteur_embase, 0])
            cube([largeur_embase, hauteur_embase + epaisseur_bride, largeur_bride]);
        
        // Corps cylindrique extérieur
        cylinder(d = d_tuyau + (epaisseur_bride * 2), h = largeur_bride);
    }
}

// 2. Volume intérieur du tuyau
module passage_tuyau() {
    translate([0, 0, -1])
        cylinder(d = d_tuyau, h = largeur_bride + 2);
}

// 3. Découpe pour insérer le tuyau par le haut
module ouverture_haute() {
    translate([-d_tuyau, 0, -1])
        cube([d_tuyau * 2, d_tuyau, largeur_bride + 2]);
}

// 4. Rainure extérieure guidant le collier autour du tuyau
module goulotte_exterieure_collier() {
    difference() {
        // Cylindre de la taille du collier
        translate([0, 0, (largeur_bride - largeur_collier) / 2])
            cylinder(d = d_tuyau + (epaisseur_bride * 2) + 2, h = largeur_collier);
        
        // On préserve l'épaisseur minimale de la bride
        translate([0, 0, -1])
            cylinder(d = d_tuyau + (epaisseur_collier * 2), h = largeur_bride + 2);
    }
}

// 5. NOUVEAU : Trous traversants dans l'embase pour bloquer et passer le collier
module canaux_passage_collier() {
    offset_x = (d_tuyau / 2) + (epaisseur_collier / 2);
    z_pos = (largeur_bride - largeur_collier) / 2;
    
    // Canal gauche
    translate([-offset_x - epaisseur_collier/2, -d_tuyau/2 - hauteur_embase - 1, z_pos])
        cube([epaisseur_collier, hauteur_embase + 2, largeur_collier]);
        
    // Canal droit
    translate([offset_x - epaisseur_collier/2, -d_tuyau/2 - hauteur_embase - 1, z_pos])
        cube([epaisseur_collier, hauteur_embase + 2, largeur_collier]);
}

// 6. Trou et fraisage pour la vis de fixation centrale
module trou_fixation() {
    translate([0, -d_tuyau/2 - hauteur_embase - 1, largeur_bride / 2])
        rotate([-90, 0, 0]) {
            // Passage du corps de la vis
            cylinder(d = d_vis, h = hauteur_embase + epaisseur_bride + 2);
            
            // Fraisage pour la tête de la vis
            h_fraisage_total = hauteur_embase + epaisseur_bride + 1;
            translate([0, 0, h_fraisage_total - profondeur_fraisage])
                cylinder(d1 = d_vis, d2 = d_fraisage, h = profondeur_fraisage + 0.1);
        }
}


// --- ASSEMBLAGE FINAL ---
module bride_complete() {
    difference() {
        forme_exterieure();
        
        passage_tuyau();
        ouverture_haute();
        goulotte_exterieure_collier();
        canaux_passage_collier(); // Ce module verrouille désormais le collier à la base
        trou_fixation();
    }
}

// Rendu de la pièce
bride_complete();
