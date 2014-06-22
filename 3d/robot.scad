$fn=100;

union() {
    //proteins
    translate([-70,-7.5,-3]) base_delantera(); //plataforma delantera
    translate([0,-7.5,-3]) base_trasera(); //plataforma trasera
    translate([-80,-7.5,0]) parachoques_delantero(); //protector delantero
    translate([55,-7.5,0]) parachoques_trasero(); //protector trasero
    translate([-59,73,-14]) direccion(); //sistema direccion
    translate([40,-7.5,3]) porta_arduino(); //base arduino
    translate([-77,-1.25,-35]) porta_sensor(); //portasensor izq
    translate([-77,35.25,-35]) porta_sensor(); //portasensor dch
    translate([99,4,-32]) rotate([0,-90,0]) porta_zumbador(); //sujecion zumbador
    translate([-20,-12.25,5]) porta_pilas(); //portapilas
    //vitamins
    translate([-59,-12.5,-14]) rotate([180,0,0]) rueda(); //rueda delantera izq
    translate([-59,57.5,-14]) rueda(); //rueda delantera dch
    translate([67.5,-17.2,-14]) rotate([180,0,0]) rueda(); //rueda trasera izq
    translate([67.5,62.2,-14]) rueda(); //rueda trasera dch
    translate([-93.5,44.75,-12.5]) rotate([180,0,0]) sharp(); //sensor frontal
    translate([-76,-4.5,-10]) rotate([0,-90,0]) led(); //luz frontal izq
    translate([-76,49.5,-10]) rotate([0,-90,0]) led(); //luz frontal dch
    translate([-75.5,16.5,0]) rotate([0,-90,-90]) servo(); //servomotor
    translate([30,-13,25]) rotate([0,0,90]) placa(); //placa motores
    translate([30,-13,55]) rotate([0,0,90]) placa(); //placa 7seg
    translate([41,-4.5,10]) arduino(); //arduino
    translate([95,3,-24]) zumbador(); //zumbador
    translate([-73.75,0.75,-34]) cny(); //sensor suelo izq
    translate([-73.75,37.25,-34]) cny(); //sensor suelo dch
    translate([9,-5,7]) pilas(); //bloque pilas
    translate([10,45,-3]) rotate([0,180,180]) motor(); //motor
    translate([91,-2.5,-10]) rotate([0,90,0]) led(); //luz trasera izq
    translate([91,47.5,-10]) rotate([0,90,0]) led(); //luz trasera dch
}

//print friendly
*union() {
    rotate([0,180,0]) base_delantera();
    base_trasera();
    rotate([0,-90,0]) parachoques_delantero();
    rotate([0,90,0]) parachoques_trasero();
    !porta_pilas();
    porta_arduino();
    porta_sensor();
    porta_zumbador(); 
    rotate([-90,0,0]) brazo();
    casquillo();
    rotula();
    rotate([0,180,0]) cuerno();
}

module base_delantera() {
    difference() {
	union() { //plataforma
            translate([0,5,0]) cube([80,50,3]);
            translate([50,-20-0]) cube([30,25,3]);
            translate([50,55,0]) cube([30,25,3]);
            translate([0,0,0]) cube([10,5,3]);
            translate([0,55,0]) cube([10,5,3]);
            translate([72.5,-17.5,-1]) cube([5,95,1]);
        }
        difference() {
            union() { 
                translate([70,-21,-2.5]) cube([11,102,4]); //escalon insercion
                translate([-1,23.75,-1]) cube([23,12.5,5]); //carcasa servo
                translate([21,28.25,-1]) cube([5,3.5,5]); //tornillo servo
                translate([5,5,-1]) cylinder(h=5, r=1.75); //montaje izq
                translate([5,55,-1]) cylinder(h=5, r=1.75); //montaje dch
                translate([54.5,-1,-1]) cylinder(h=5, r=1.75); //tornillo placa izq
                translate([54.5,61.5,-1]) cylinder(h=5, r=1.75); //tornillo placa dch
                for ( j = [ [25,7,-1],[25,50,-1],[57,-18,-1],[57,75,-1] ] ) { //fijacion carcasa
                    translate(j) cube([5,3,5]);
                }
            }
            union() {
                for ( i = [ -10,10,30,50,70 ]) { //pivotes insercion
                    translate([75,i,-1]) cylinder(h=3, r=1.5);
                }
            }
        }
    }
}

module base_trasera() {
    difference() {
        union() { //plataforma
            cube([90,60,3]);
            translate([0,60,0]) cube([40,20,3]);
            translate([0,-20,0]) cube([40,20,3]);
        }
        union() {
            translate([-1,-21,1.5]) cube([11,102,2]); //escalon insercion
            translate([20,5,-1]) cylinder(h=5, r=5); //pasacables
            translate([60.5,5.5,-1]) cylinder(h=5, r=1.75); //montaje izq
            translate([60.5,54.5,-1]) cylinder(h=5, r=1.75); //montaje dch
            translate([24.5,-1,-1]) cylinder(h=5, r=1.75); //tornillos placa izq
            translate([24.5,61.5,-1]) cylinder(h=5, r=1.75); //tornillo placa dch
            for ( i = [ -10,10,30,50,70 ]) { //agujeros insercion
                translate([5,i,-1]) cylinder(h=3, r=1.75);
            }
            for ( j = [ [25,-18,-1],[25,75,-1] ] ) { //fijacion carcasa
                translate(j) cube([5,3,5]);
            }
            translate([85,27.5,-1]) cube([3,5,5]); //fijacion carcasa
        }
    }
}

module parachoques_trasero() {
    difference() {
        union() { // cuerpo
            cube([40,60,3]); //superior
            translate([37,0,-32]) cube([3,60,32]); //trasero
        }
        union() {
            translate([-1,10,-1]) cube([38,40,5]); //espaciado entre aletas
            translate([5.5,5.5,-1]) cylinder(h=5, r=1.75); //montaje izq
            translate([5.5,54.5,-1]) cylinder(h=5, r=1.75); //montaje dch
            translate([36,5,-10]) rotate([0,90,0]) cylinder(h=5, r=2.75); //luz izq
            translate([36,55,-10]) rotate([0,90,0]) cylinder(h=5, r=2.75); //luz dch
            translate([36,27.75,-33]) cube([5,4.5,7]); //cables
            translate([36,39.25,-3.75]) rotate([0,90,0]) cylinder(h=5, r=1.75); //montaje buz sup
            translate([36,20.75,-29.25]) rotate([0,90,0]) cylinder(h=5, r=1.75); //montaje buz inf
        }
    }
}

module parachoques_delantero() {
    difference() {
        union() { //cuerpo
            cube([20,60,4]); //superior
            translate([0,0,-23]) cube([3,60,23]); //frontal
        }
        union() {
            translate([9,23.75,-1]) cube([12,12.5,6]); //carcasa de servo
            translate([3.5,24,-1]) cube([6,12,3]); //solapa de servo
            translate([5,28.25,1]) cube([5,3.5,4]); //tornillo de servo
            translate([6,15,-1]) cylinder(h=6, r=2); //pasacables superior
            translate([-1,20,-5]) rotate([0,90,0]) cylinder(h=5, r=2); //pasacables delantero
            translate([15,5,-1]) cylinder(h=6, r=1.75); //montaje izq
            translate([15,55,-1]) cylinder(h=6, r=1.75); //montaje dch
            translate([-1,11.75,-19.25]) rotate([0,90,0]) cylinder(h=5, r=1.75); //tornillo izq sharp
            translate([-1,48.25,-19.25]) rotate([0,90,0]) cylinder(h=5, r=1.75); //tornillo dch sharp
            translate([-1,3,-10]) rotate([0,90,0]) cylinder(h=5, r=2.75); //luz izq
            translate([-1,57,-10]) rotate([0,90,0]) cylinder(h=5, r=2.75); //luz dch
        }
    }
}

module porta_sensor() {
    difference() {
        union() {
            cube([1.5,11,30]); //rail
            cube([11,11,7]); //base
        }
        union() {
            translate([3,1.75,-1]) difference() {
                cube([7.5,7.5,9]); //cuerpo cny
                union() {
                    translate([-0.5,3.25,-1]) cube([1,1,9]); //mordido cny
                    translate([-1,0,0]) cube([2,8,2]); //escalon tope
                }
            }
            translate([-0.5,3.75,8]) cube([2.5,3.5,23]); //apertura rail
            translate([10,2.25,-1]) cube([2,6.5,9]); //pestaña
        }
    }
}

module porta_zumbador() {
    difference() {
        union() {
            cube([31,37,4]); //cuerpo
        }
        union() {
            translate([7.5,4.5,-1]) cube([18,28,6]); //hueco zumbador
            translate([7.5,-1,1.5]) cube([18,39,3]); //hueco aletas zumbador
            translate([3.5,18.5,4]) rotate([0,90,0]) cylinder(h=5, r=2); //hueco cables
            translate([3.5,18.5,4]) sphere(2); //hueco cables
            translate([2.75,9.25,-1]) cylinder(h=6, r=1.75); //montaje inf
            translate([28.25,27.75,-1]) cylinder(h=6, r=1.75); //montaje sup
        }
    }
}

module direccion() {
    translate([0,-4.5,0]) rotate([90,0,0]) cylinder(h=30, r=1.5); //eje izq
    translate([0,-66.5,0]) rotate([90,0,0]) cylinder(h=30, r=1.5); //eje dch
    for ( i = [-67, -29] ) { //tuerca prisionera
        translate([0,i,0]) rotate([90,0,0]) difference() {
            cylinder(h=5, r=4);
            translate([0,0,-1]) cylinder(h=7, r=1.55);
        }
    }
    translate([-10,-78.5,-3]) brazo(); //brazo dch
    translate([-10,-22.5,-3]) mirror([0,1,0]) brazo(); //brazo izq
    translate([-6,-25.5,2]) casquillo(); //casquillo izq
    translate([-6,-75.5,2]) casquillo(); //casquillo dch
    translate([7,-80.5,-6]) rotula(); //rotula
    translate([0,-54, 5]) cuerno(); //cuerno
}

module brazo() {
    difference() {
        union() {
            cube([25,6,6]); //cuerpo
            translate([10,0,3]) rotate([90,0,0]) cylinder(h=5.5, r=3); //casquillo espaciador
        }
        union() {
            translate([10,7,3]) rotate([90,0,0]) cylinder(h=13, r=1.9); //pasaejes
            translate([4,3,-1]) cylinder(h=8, r=1.75); //montaje pivotante
            translate([20,3,-1]) cylinder(h=8, r=1.75); //montaje rotula
        }
    }
}

module rotula() {
    difference() {
        union() {
            cube([6,60,3]); //cuerpo
            translate([6,25,0]) cube([3,10,3]); //añadido U leva
            translate([0,31.75,0]) cube([9,2,10]); // solapa leva dch
            translate([0,26.25,0]) cube([9,2,10]); // solapa leva izq
            translate([0,10,0]) cube([6,5,16.5]); // patin izq
            translate([0,45,0]) cube([6,5,16.5]); // patin dch
        }
        union() {
            translate([3,5,-1]) cylinder(h=5, r=1.75); //montaje izq
            translate([3,55,-1]) cylinder(h=5, r=1.75); //montaje dch
        }
    }
}

module cuerno() {
    difference() {
        union() {
            cube([15,7,3]); //cuerpo
        }
        union() {
            translate([-1,1.5,-0.5]) cube([10,4,2.5]); //comido servo
            translate([4,3.5,-1]) cylinder(h=5, r=0.5); //sujecion a servo
            translate([12,3.5,-1]) cylinder(h=5, r=1.75); //montaje leva
        }
    }
}

module casquillo() {
    difference() {
        cylinder(h=8.5, r=3);
        translate([0,0,-1]) cylinder(h=10, r=1.75);
    }
}

module motor() {
    union() {
        translate([0,3,0]) cube([75,39,23]);
        translate([36,0,0]) cube([39,45,23]);
        translate([45,-6,0]) difference() {
            cube([11,57,2]);
            translate([4,2,-1]) cube([3,53,4]);
        }
        translate([57.5,73.5,11]) rotate([90,0,0]) cylinder(h=102, r=1.5);
    }
}

module rueda() {
    translate([0,29,0]) rotate([90,0,0]) union() {
        translate([0,0,13]) difference() { //portaeje
            cylinder(h=17, r=3);
            translate([0,0,4.7]) cylinder(h=12.5, r=1.5);
        }
        translate([0,0,2]) difference() { //lanta
            cylinder(h=25, r=12);
            translate([0,0,-1]) cylinder(h=12, r=8.5);
        }
        difference() { //neumatico
            cylinder(h=29, r=25);
            translate([0,0,-1]) cylinder(h=31, r=12);
        }
    }
}

module pilas() {
    cube([26.5,46.5,17.5]); //cuerpo
    translate([6.7,0,8.75]) rotate([90,0,0]) cylinder(h=2, r=2.82); //positivo
    translate([19.8,0,8.75]) rotate([90,0,0]) cylinder(h=2, r=2.76, $fn=8); //negativo
}

module porta_pilas(){
    difference() {
        union() {
            cube([50,70,2]); //base
            translate([0,25,2]) cube([2,20,2.5]); //soportes
            translate([30,25,2]) cube([2,20,2.5]); //soportes
            translate([11.5,62,2]) cube([10,2,2.5]); //soportes
            translate([11.5,12.5,2]) cube([10,2,2.5]); //soportes
            
        }
        union() { //montaje
            translate([4.5,3.5,-1]) cylinder(h=4, r=2);
            translate([4.5,66,-1]) cylinder(h=4, r=2);
            translate([44.5,3.5,-1]) cylinder(h=4, r=2);
            translate([44.5,66,-1]) cylinder(h=4, r=2);
        }
    }
}

module porta_arduino() {
    difference() {
        union() {
            cube([70,60,2]); //cuerpo
            translate([13.5,5.5,2]) cylinder(h=5, r=2.5);
            translate([13.5,5.5,2]) cylinder(h=8, r=1.5);
            translate([65.5,10.5,2]) cylinder(h=5, r=2.5);
            translate([65.5,10.5,2]) cylinder(h=8, r=1.5);
            translate([30,55,2]) cube([10,3,5]);
            translate([30,56.5,2]) cube([10,,1.5,8]);
        }
        union() {
            translate([20.5,5.5,-1]) cylinder(h=4, r=1.75); //montaje izq
            translate([20.5,54.5,-1]) cylinder(h=4, r=1.75); //montaje dch
        }
    }
}

module sharp() {
    union() {
        translate([6.5,7.25,0]) cube([7,30,13]);
        translate([2,7.25,2.25]) cube([4.5,30,8.5]);
        translate([0,7.25,3]) difference() {
            cube([2,30,7]);
            union() {
                translate([-1,17,-1]) cube([4,4,9]);
                translate([-1,-0.5,-1]) cube([4,1,9]);
                translate([-1,29.5,-1]) cube([4,1,9]);
            }
        }
        translate([12,0,3]) difference() {
            cube([1.5,44.5,7.5]);
            union() {
                translate([-1,4,3.75]) rotate([0,90,0]) cylinder(h=4, r=1.5);
                translate([-1,40.5,3.75]) rotate([0,90,0]) cylinder(h=4, r=1.5);
            }
        }
        translate([4,17.5,-8]) cube([7,10,8]);
    }
}

module cny() {
    difference() {
        cube([7,7,6]);
        union() {
            translate([-0.5,3,-1]) cube([1,1,8]);
            translate([6.5,3,-1]) cube([1,1,8]);
        }
    }
}

module zumbador() {
    difference() {
        union() {
            cube([1,39,17]); //aletas
            translate([1,5,0]) cube([14,29,17]); //cuerpo
        }
        union() {
            translate([-1,-1,7.5]) cube([3,5,2]); //taladro izq
            translate([-1,35,7.5]) cube([3,5,2]); //taladro dch
        }
    }
}

module servo() {
    union() {
        translate([0,4.5,0]) cube([23,23,12]);
        difference() {
            cube([2,32,12]);
            translate([-1,2.5,6]) rotate([0,90,0]) cylinder(h=4, r=1);
            translate([-1,29.5,6]) rotate([0,90,0]) cylinder(h=4, r=1);
        }
        translate([-4,4.5,0]) cube([4,15,12]);
        translate([-7,10.5,6]) rotate([0,90,0]) cylinder(h=3, r=2);
        translate([-5,10.5,6]) rotate([-90,0,90]) difference() { //0,-90,0
            union() {
                translate([-16,-2,2.5]) cube([32,4,1.5]);
                translate([-2,-9.5,2.5]) cube([4,19,1.5]);
                cylinder(h=4, r=3.5);
            }
            union() {
                translate([14,0,1.5]) cylinder(h=3, r=0.5);
                translate([12,0,1.5]) cylinder(h=3, r=0.5);
                translate([10,0,1.5]) cylinder(h=3, r=0.5);
                translate([-10,0,1.5]) cylinder(h=3, r=0.5);
                translate([-12,0,1.5]) cylinder(h=3, r=0.5);
                translate([-14,0,1.5]) cylinder(h=3, r=0.5);
                translate([0,7.5,1.5]) cylinder(h=3, r=0.5);
                translate([0,5.5,1.5]) cylinder(h=3, r=0.5);
                translate([0,-7.5,1.5]) cylinder(h=3, r=0.5);
                translate([0,-5.5,1.5]) cylinder(h=3, r=0.5);
            }
        }
    }
}

module arduino() {
    difference() {
        union() {
            cube([69,53.5,1.7]); //arduino
            translate([-6.5,32,1.7]) cube([17,12,11]); //usb
            translate([-2,4.5,1.7]) cube([14,9,11]); //jack
            translate([8,-7,1.7]) cube([63,61,49]); //shield
        }
        union() {
            translate([15.5,51,-1]) cylinder(h=3, r=1.5); //montaje
            translate([66.5,8,-1]) cylinder(h=3, r=1.5); //montaje
            translate([12.5,2.5,-1]) cylinder(h=3, r=1.5); //montaje solo UNO
        }
    }
}

module placa() {
    difference() {
        union() {
            cube([71.5,51,1.25]); //base
            translate([6.25,2.5,1.25]) cube([59,44,25]); //carga
        }
        union() { //montaje
            translate([4.5,5.5,-0.25]) cylinder(h=2, r=1.5);
            translate([67,5.5,-0.25]) cylinder(h=2, r=1.5);
            translate([4.5,45.5,-0.25]) cylinder(h=2, r=1.5);
            translate([67,45.5,-0.25]) cylinder(h=2, r=1.5);
        }
    }
}

module led() {
    cylinder(h=1, r=3);
    cylinder(h=6.5, r=2.5);
    translate([0,0,6.5]) sphere(2.5);
}

