// SSR relay-replacement case v6 (base rev c: snap bump 0.6, fit 0.15, bottom hole flare): 1.2 mm walls, high vents removed (v5 broke at the vent band). v4 tuned for PETG on an Original Prusa MINI (0.4 nozzle).
// part = "assembly" | "cover" | "base" | "plate"  (cover/base/plate are oriented for printing)
// X along relay length (coil column x=0, contacts 15/20), Y across rows (+/-3.75), Z up from VSX board.
$fn = 40;

part = "assembly";
show_base = true; show_cover = true; show_cards = true; show_board = true;
cover_alpha = 1.0;  explode = 0;

// ---- cards ----
card_L = 24; card_H = 22; card_T = 1.6; row = 7.5; wire_d = 1.02; part_h = 1.75;
front_y = row/2 - wire_d/2;          // parts face, wire laps on it: 3.24
back_y  = front_y - card_T;          // bare back: 1.64
mid_y   = back_y + card_T/2;
x0 = -1.8; x1 = x0 + card_L;

// ---- cover ----
clr = 0.3; wall = 1.2; roof = 1.2; engage = 0.6; gtop = 0.2; gw = card_T + 0.4;   // PETG: a bit looser
in_y  = max(front_y + part_h, row/2 + wire_d/2) + clr;   // 5.24
in_x0 = x0 - 0.3; in_x1 = x1 + 0.3;
fit   = 0.15;                        // cover-to-tongue clearance per side

// ---- base ----
bx0 = -2; bx1 = 22; bw = 12;          // 24 x 12, the relay footprint
base_h = 1.2;                         // block on the board; cover walls rest on its top edge
boss_h = 2.6;                         // tongue inside the cover, carries the snap bumps
boss_hw = in_y - fit;
S = base_h + boss_h;                  // card bottom edge height
hole_d = 1.4;                        // 18 AWG (1.02 mm); PETG holes print small
bump_len = 8; bump_h = 1.0; bump_out = 0.6; bump_x = 10; bump_z = base_h + boss_h/2 + 0.1;

roof_z = S + card_H - engage;  top_z = roof_z + roof;  groove_z = S + card_H + gtop;

module rbox(x0_,x1_,y,z0,z1,r=0.8) hull() for (x=[x0_+r,x1_-r], yy=[-y+r,y-r]) translate([x,yy,z0]) cylinder(r=r,h=z1-z0);
module stadium(len,h,out) hull() for (dx=[-(len-h)/2,(len-h)/2]) translate([dx,0,0]) scale([1,out/(h/2),1]) sphere(d=h);

module base() {
  difference() {
    union() {
      translate([bx0,-bw/2,0]) cube([bx1-bx0, bw, base_h]);
      translate([bx0,-boss_hw,base_h-0.01]) cube([bx1-bx0, 2*boss_hw, boss_h+0.01]);
      for (s=[-1,1]) translate([bump_x, s*boss_hw, bump_z]) stadium(bump_len,bump_h,bump_out);
    }
    for (s=[-1,1], x=[0,15,20]) {
      translate([x, s*row/2, -1]) cylinder(d=hole_d, h=S+2);
      translate([x, s*row/2, S-0.6]) cylinder(d1=hole_d, d2=hole_d+1.2, h=0.61);
      translate([x, s*row/2, -0.01]) cylinder(d1=hole_d+0.8, d2=hole_d, h=0.41);   // bottom flare: first layer squish can't close the hole
    }
  }
}

module cover() {
  oy = in_y + wall; ox0 = in_x0 - wall; ox1 = in_x1 + wall;
  difference() {
    rbox(ox0, ox1, oy, base_h, top_z, 0.8);
    translate([in_x0, -in_y, base_h-1]) cube([in_x1-in_x0, 2*in_y, roof_z-base_h+1]);
    // card grooves
    for (s=[-1,1]) translate([in_x0, s*mid_y-gw/2, roof_z-0.01]) cube([in_x1-in_x0, gw, groove_z-roof_z+0.01]);
    // relief over parts near the top edge (Q1 on the + card), both sides
    for (s=[-1,1]) translate([6.3, s>0 ? front_y-0.05 : -in_y, roof_z-0.01]) cube([7.8, in_y-front_y+0.05, groove_z-roof_z+0.2]);
    // snap windows
    for (s=[-1,1]) translate([bump_x, s*(in_y+wall/2), bump_z]) rotate([90,0,0])
      linear_extrude(wall+1, center=true) hull() for (dx=[-(bump_len-bump_h)/2,(bump_len-bump_h)/2]) translate([dx,0]) circle(d=bump_h+0.3);
    // side vents: end walls over the gap between the cards (low + high), long walls near the top
    for (x=[ox0-1, in_x1-0.1], z=[S+2.0]) translate([x, -1.1, z]) cube([wall+1.1, 2.2, 1.2]);
    if (false) for (s=[-1,1], x=[3,17]) translate([x-2.5, s>0 ? in_y-0.1 : -oy-0.1, roof_z-2.6]) cube([5, wall+0.2, 1.2]);
    // coil-end marker
    translate([in_x0+0.5, 0, top_z-0.4]) linear_extrude(1) polygon([[0,0],[2.0,1.4],[2.0,-1.4]]);
  }
}

// ---- cards ----
function cx(u) = u - 1.8;
module bp(u,v,w,h,t,ang=0,col="#202020") color(col) translate([cx(u),-card_T,v]) rotate([0,-ang,0]) translate([-w/2,-t,-h/2]) cube([w,t,h]);
module card() {   // local: back face at y=0, parts face toward -y
  color("#1f6b2e") translate([x0,-card_T,0]) cube([card_L,card_T,card_H]);
  for (u=[1.8,16.8,21.8], v=[0,card_H-6], yy=[0.01,-card_T-0.06]) color("gold") translate([cx(u)-0.75,yy,v]) cube([1.5,0.05,6]);
  bp(4.12,11.99,3.9,4.9,1.75); bp(11.78,3.53,5.15,6.15,1.0); bp(20.32,11.05,5.15,6.15,1.0);
  bp(9.57,11.93,1.6,2.7,1.1); bp(5.59,19.15,1.6,3.2,0.6,0,"#303030"); bp(10.25,8.25,2.0,1.25,0.5,0,"#303030");
  bp(12.6,16.2,2.0,1.25,1.25,45,"#8a6a3a"); bp(13.84,12.81,2.0,1.25,1.25,45,"#8a6a3a");
}
module wires() color("#c87533") {
  for (s=[-1,1], x=[0,15,20]) {
    translate([x, s*row/2, -2.6]) cylinder(d=wire_d, h=S+5.55+2.6);                       // laps up the parts face
    translate([x, s*row/2, S+5.55]) rotate([s*90,0,0]) cylinder(d=wire_d, h=row/2-back_y+0.6); // hook through to the back
  }
  translate([0, -(row/2+0.2), S+card_H-5.55]) rotate([-90,0,0]) cylinder(d=0.81, h=row+0.4);    // link wire through both spare coil holes
}
module cards() { translate([0,-back_y,S]) card(); translate([0,back_y,S+card_H]) rotate([180,0,0]) card(); wires(); }
module vsx_board() {
  color("#b89a5a") translate([-10,-14,-1.6]) cube([44,28,1.6]);
  color("white") translate([0,0,0.01]) difference() { translate([-2,-6,0]) cube([24,12,0.05]); translate([-1.8,-5.8,-1]) cube([23.6,11.6,2]); }
  color("#9aa0a6") translate([-2.6,-12,0.35]) rotate([-90,0,0]) cylinder(d=0.7,h=24);   // jumper close to the relay end
}

if (part == "assembly") {
  if (show_board) vsx_board();
  if (show_base)  color("#5b6b8c") base();
  if (show_cards) cards();
  if (show_cover) translate([0,0,explode]) color("#d9dde3", cover_alpha) cover();
}
// print orientation: cover roof-down, base plinth-down
module cover_print() translate([0,0,top_z]) rotate([180,0,0]) cover();
if (part == "cover") cover_print();
if (part == "base")  base();
if (part == "plate") { cover_print(); translate([0,18,0]) base(); }

echo(str("cover outer: ", in_x1-in_x0+2*wall, " x ", 2*(in_y+wall), " x ", top_z, " (top above board)"));
echo(str("across IC tops: ", 2*(front_y+part_h), "  card backs gap: ", 2*back_y));
