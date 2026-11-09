$fn=40;
explode = 0;
card_L=24; card_H=22; card_T=1.6; row=7.5; wire_d=1.02;
cb_T=1.6;                  // carrier PCB thickness
cb_z=0.5;                  // carrier sits 0.5 mm above the VSX board
x0=-1.8;
gap=1.3;                   // cards moved in: back faces 1.3 mm apart, clear of the pin pads
yb=gap/2;
tab_w=4; tab_h=cb_T;       // card tabs drop into slots in the carrier
tabs=[4.5,10,17.5];
module vsx() color("#b89a5a") translate([-12,-14,-1.6]) cube([48,28,1.6]);
module carrier() {
  difference(){
    color("#1f6b2e") translate([-2,-6,cb_z]) cube([24,12,cb_T]);
    for (s=[-1,1], x=[0,15,20]) translate([x,s*row/2,-1]) cylinder(d=wire_d+0.2,h=5);
    for (s=[-1,1], t=tabs) translate([t-tab_w/2-0.1+x0, s>0? yb-0.05 : -yb-card_T-0.05, cb_z-1]) cube([tab_w+0.2,card_T+0.1,cb_T+2]);
  }
  // annular rings
  for (s=[-1,1], x=[0,15,20]) color("gold") translate([x,s*row/2,cb_z+cb_T]) difference(){cylinder(d=2.2,h=0.05); translate([0,0,-1])cylinder(d=wire_d+0.2,h=3);}
  // traces from pins to card tab pads
  color("#d4a017") for (s=[-1,1]) {
    translate([-0.4, s>0? yb+card_T : -row/2, cb_z+cb_T]) cube([0.8, row/2-yb-card_T, 0.04]);
    translate([14.6, s>0? yb+card_T : -row/2, cb_z+cb_T]) cube([0.8, row/2-yb-card_T, 0.04]);
    translate([19.6, s>0? yb+card_T : -row/2, cb_z+cb_T]) cube([0.8, row/2-yb-card_T, 0.04]);
  }
  // card-to-card link trace (replaces the jumper wire)
  color("#d4a017") translate([2.0,-yb-0.2,cb_z+cb_T]) cube([0.8,2*yb+0.4,0.04]);
}
module card(s) {
  ys = s>0 ? yb : -yb-card_T;
  zc = cb_z+cb_T+explode;
  color("#1f6b2e") translate([x0, ys, zc]) cube([card_L, card_T, card_H]);
  color("#1f6b2e") for (t=tabs) translate([t-tab_w/2+x0, ys, zc-tab_h]) cube([tab_w, card_T, tab_h]);
  // a few parts on the outer face
  pf = s>0 ? yb+card_T : -yb-card_T-1.75;
  color("#202020") { translate([2.2,pf,zc+9.5]) cube([3.9,1.75,4.9]);
    translate([9.2,s>0?yb+card_T:-yb-card_T-1.0,zc+0.5]) cube([5.15,1.0,6.15]);
    translate([17.7,s>0?yb+card_T:-yb-card_T-1.0,zc+8]) cube([5.15,1.0,6.15]); }
  // edge pads at the tab roots
  color("gold") for (t=[1.8,16.8,21.8]) translate([t-0.75+x0, s>0? ys+card_T : ys-0.05, zc]) cube([1.5,0.05,2.5]);
}
module pins() color("#c87533") for (s=[-1,1], x=[0,15,20]) translate([x,s*row/2,-3]) cylinder(d=wire_d,h=cb_z+cb_T+3+0.8);
module cover() color("#d9dde3",0.25) difference(){
  translate([-3.3,-6,cb_z+cb_T+explode*1.6]) cube([26.6,12,card_H+1.5]);
  translate([-2.1,-4.8,cb_z+cb_T-1+explode*1.6]) cube([24.2,9.6,card_H+1.5]);
}
vsx(); carrier(); card(1); card(-1); pins();
if (explode==0) cover();
