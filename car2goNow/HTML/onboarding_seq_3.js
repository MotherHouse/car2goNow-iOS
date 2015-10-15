 (function (lib, img, cjs, ss) {
  
  var p; // shortcut to reference prototypes
  
  // library properties:
  lib.properties = {
  width: 324,
  height: 576,
  fps: 30,
  color: "#FFFFFF",
  manifest: []
  };
  
  
  
  // symbols:
  
  
  
  (lib.Seq3ReceiptCircle = function() {
   this.initialize();
   
   // Layer 1
   this.shape = new cjs.Shape();
   this.shape.graphics.f("#30373E").s().p("AnKHLQi+i+gBkNQABkMC+i+QC+i+EMgBQENABC+C+QC+C+AAEMQAAENi+C+Qi+C+kNAAQkMAAi+i+gAmfmfQitCtAADyQAADzCtCuQCtCsDyABQDzgBCuisQCsiuABjzQgBjyisitQiuitjzAAQjyAAitCtg");
   this.shape.setTransform(65,65);
   
   this.addChild(this.shape);
   }).prototype = p = new cjs.Container();
  p.nominalBounds = new cjs.Rectangle(0,0,130,130);
  
  
  (lib.Seq3Receipt = function() {
   this.initialize();
   
   // Receipt Lines
   this.shape = new cjs.Shape();
   this.shape.graphics.f("#30373E").s().p("AxLFKIAAg9MAiXAAAIAAA9gAxLAdIAAg5MAiXAAAIAAA5gAxLkNIAAg8MAiXAAAIAAA8g");
   this.shape.setTransform(140,253);
   
   // Main
   this.shape_1 = new cjs.Shape();
   this.shape_1.graphics.f("#D9D9D9").s().p("A13ZPMAAAgwQIBkiNIBkCNIBkiNIBkCNIBliNIBkCNIBkiNIBkCNIBjiNIBkCNIBkiNIBkCNIBkiNIBjCNIBkiNIBkCNIBkiNIBkCNIBjiNIBkCNIBkiNIBkCNIBliNIBkCNIBkiNIBkCNIBkiNIBjCNMAAAAwQg");
   this.shape_1.setTransform(140,161.5);
   
   // Shadow
   this.shape_2 = new cjs.Shape();
   this.shape_2.graphics.f("#30373E").s().p("A12ZPMAAAgwQIBkiNIBkCNIBkiNIBjCNIBkiNIBkCNIBkiNIBkCNIBliNIBkCNIBkiNIBkCNIBjiNIBjCNIBjiNIBkCNIBkiNIBlCNIBkiNIBkCNIBkiNIBkCNIBjiNIBkCNIBkiNIBkCNIBliNIBkCNMAAAAwQg");
   this.shape_2.setTransform(134,161.5);
   
   this.addChild(this.shape_2,this.shape_1,this.shape);
   }).prototype = p = new cjs.Container();
  p.nominalBounds = new cjs.Rectangle(-6,0,286,323);
  
  
  (lib.Seq3PersonIcon = function() {
   this.initialize();
   
   // Layer 1
   this.shape = new cjs.Shape();
   this.shape.graphics.f("#FFFFFF").s().p("AgFAKQgEgDAAgFIgBgIIAFgFQACACADABQAEABADACQAFADgCAEQgCAGgGADIgCABQgDAAgCgCg");
   this.shape.setTransform(8,-0.8);
   
   this.shape_1 = new cjs.Shape();
   this.shape_1.graphics.f("#FFFFFF").s().p("AgCAMQgGgBgCgGQgBgFADgBIAFgJIAFgBQgBADADADIAGAFQACAFgFAEQgDADgEAAIgCAAg");
   this.shape_1.setTransform(-5.6,2.8);
   
   this.shape_2 = new cjs.Shape();
   this.shape_2.graphics.f("#FFFFFF").s().p("AgFABIgHgNQgEgOgMgUIAYAJQABAKAKAXQAJAOANAfIgIAFg");
   this.shape_2.setTransform(4.8,-5.9);
   
   this.shape_3 = new cjs.Shape();
   this.shape_3.graphics.f("#FFFFFF").s().p("AgHA5QgIAigwA+QATAJAHAIQAGAJgMAAQgQAAgfgPIAfhGQATgvAFgaQADgOgEgWQgDgUAFgKQAHgNgBgQQgCgQgEAFQgEAGgEAcQgCASgHAhIgJAAIADg1QAAgFADgMQADgOACgWQACgZATgSQAKgJAJgEIADgRIARALIAAAJQARAFATApIgUAJIgCgDIgDAgIgFAbQgDAbAEAWQAGAmAlB3QAOgFALAFQALAFgQAGQgWAJgYACg");
   this.shape_3.setTransform(0,2.1);
   
   this.shape_4 = new cjs.Shape();
   this.shape_4.graphics.f("#FFFFFF").s().p("AgWAAQAGgKALAAIAfAAQgCAMgOAAIgjAJIADgLg");
   this.shape_4.setTransform(0.3,-18.9);
   
   this.shape_5 = new cjs.Shape();
   this.shape_5.graphics.f("#FFFFFF").s().p("AgBAAQAAgFABAAQACAAAAAFQAAAGgCAAQgBAAAAgGg");
   this.shape_5.setTransform(-2.5,-17);
   
   this.shape_6 = new cjs.Shape();
   this.shape_6.graphics.f("#FFFFFF").s().p("AgSATQgIgIAAgLQAAgKAIgIQAIgIAKAAQALAAAIAIQAIAIAAAKQAAALgIAIQgIAIgLAAQgKAAgIgIg");
   this.shape_6.setTransform(0.3,-17);
   
   // BG
   this.shape_7 = new cjs.Shape();
   this.shape_7.graphics.f("#1AAC9A").s().p("Aj2D3QhnhnAAiQQAAiPBnhnQBnhnCPAAQCQAABnBnQBnBnAACPQAACQhnBnQhnBniQAAQiPAAhnhng");
   
   this.addChild(this.shape_7,this.shape_6,this.shape_5,this.shape_4,this.shape_3,this.shape_2,this.shape_1,this.shape);
   }).prototype = p = new cjs.Container();
  p.nominalBounds = new cjs.Rectangle(-35,-35,70,70);
  
  
  (lib.Seq3MapGreenPath3 = function() {
   this.initialize();
   
   // Layer 1
   this.shape = new cjs.Shape();
   this.shape.graphics.f("#00AD9A").s().p("EgRiA/EMAh3h+cIBOAUMgh3B+dg");
   this.shape.setTransform(112.3,405.8);
   
   this.addChild(this.shape);
   }).prototype = p = new cjs.Container();
  p.nominalBounds = new cjs.Rectangle(0,0,224.7,811.5);
  
  
  (lib.Seq3MapGreenPath2 = function() {
   this.initialize();
   
   // Layer 1
   this.shape = new cjs.Shape();
   this.shape.graphics.f("#00AD9A").s().p("EhWUgWeIAUhNMCsVAuKIgUBNg");
   this.shape.setTransform(552.6,151.7);
   
   this.addChild(this.shape);
   }).prototype = p = new cjs.Container();
  p.nominalBounds = new cjs.Rectangle(0,0,1105.2,303.3);
  
  
  (lib.Seq3MapGreenPath1 = function() {
   this.initialize();
   
   // Layer 1
   this.shape = new cjs.Shape();
   this.shape.graphics.f("#00AD9A").s().p("EgJCAglMARfhBUIAmALMgRfBBUg");
   this.shape.setTransform(58,209.7);
   
   this.addChild(this.shape);
   }).prototype = p = new cjs.Container();
  p.nominalBounds = new cjs.Rectangle(0,0,115.9,419.3);
  
  
  (lib.Seq3Map = function() {
   this.initialize();
   
   // Layer 1
   this.shape = new cjs.Shape();
   this.shape.graphics.f("#595F65").s().p("EA00BBiIAAxfIt6AAIAARfIhQAAIAAxfIvLAAIAARfIhQAAIAAxfIvoAAIAARfIhQAAIAAxfIuzAAIAARfIhQAAIAAxfIvLAAIAARfIhQAAIAAxfIzOAAIAARfIhPAAIAAxfIpsAAIAAFoIgpAAIAAloIpDAAIAARfIhQAAIAAxfI0AAAIAAhRIUAAAIAAu2I0AAAIAAhPIUAAAIAAvUI0AAAIAAhQIUAAAIAAn1I0AAAIAAgnIUAAAIAAnBI0AAAIAAhQIUAAAIAAvKI0AAAIAAhQIUAAAIAAveI0AAAIAAhQIUAAAIAAvUI0AAAIAAhPIUAAAIAAtTIBQAAIAANTITYAAIAAtJIBPAAIAANJITOAAIAAtJIBQAAIAANJIPLAAIAAtJIBQAAIAANJIOzAAIAAtJIBQAAIAANJIPoAAIAAtJIBQAAIAANJIPLAAIAAtJIBQAAIAANJMAyTAAAIAABPMgyTAAAIAAPUMAyTAAAIAABQMgyTAAAIAAPeMAyTAAAIAABQMgyTAAAIAAPKMAyTAAAIAABQI5eAAIAAPdIZeAAIAABQMgjKAAAIAAPUMAjKAAAIAABPMgjKAAAIAAO2MAjKAAAIAABRMgjKAAAIAARfgEAm6AuyIN6AAIAAu2It6AAgEAWfAuyIPLAAIAAu2IvLAAgEAFnAuyIPoAAIAAu2IvoAAgEgKcAuyIOzAAIAAu2IuzAAgEga3AuyIPLAAIAAnLIvLAAgEgvVAuyITOAAIAAu2IzOAAgEg6QAuyIJsAAIAAu2IpsAAgEhD8AuyIJDAAIAAu2IpDAAgEga3Am+IPLAAIAAnCIvLAAgEAm6AetIN6AAIAAvUIt6AAgAWfetIPLAAIAAnrIvLAAgAFnetIPoAAIAAnrIvoAAgAqcetIOzAAIAAnrIuzAAgA63etIPLAAIAAnrIvLAAgEgvVAetITOAAIAAvUIzOAAgEg6QAetIJsAAIAAvUIpsAAgEhD8AetIJDAAIAAvUIpDAAgAWfWbIPLAAIAAnCIvLAAgAFnWbIPoAAIAAnCIvoAAgAqcWbIOzAAIAAnCIuzAAgA63WbIPLAAIAAnCIvLAAgEA2DAOJIIcAAIAAn1IocAAgEAm6AOJIN6AAIAAn1It6AAgAWfOJIPLAAIAAn1IvLAAgAFnOJIPoAAIAAn1IvoAAgAqcOJIOzAAIAAn1IuzAAgA63OJIPLAAIAAn1IvLAAgEglKAOJIJDAAIAAvdIpDAAgEgvVAOJIJiAAIAAvdIpiAAgEhD8AOJITYAAIAAvdIzYAAgEAm6AFtIXlAAIAAnBI3lAAgAWfFtIPLAAIAAnBIvLAAgAFnFtIPoAAIAAnBIvoAAgAqcFtIOzAAIAAnBIuzAAgA63FtIPLAAIAAnBIvLAAgAWfikIPLAAIAAnVIvLAAgAFnikIPoAAIAAnVIvoAAgAqcikIOzAAIAAvKIuzAAgA63ikIPLAAIAAvKIvLAAgEglKgCkIJDAAIAAvKIpDAAgEgvVgCkIJiAAIAAvKIpiAAgEhD8gCkITYAAIAAvKIzYAAgAWfqiIPLAAIAAnMIvLAAgAFnqiIPoAAIAAnMIvoAAgAWfy+IPLAAIAAngIvLAAgAFny+IPoAAIAAngIvoAAgAqcy+IOzAAMAAAggCIuzAAgA63y+IPLAAIAAngIvLAAgEglKgS+IJDAAIAAveIpDAAgEgvVgS+IJiAAIAAveIpiAAgEhD8gS+ITYAAIAAveIzYAAgAWf7GIPLAAIAAnWIvLAAgAFn7GIPoAAIAAnWIvoAAgA637GIPLAAIAAnWIvLAAgEAWfgjsIPLAAIAAvUIvLAAgEAFngjsIPoAAIAAvUIvoAAgEga3gjsIPLAAIAAvUIvLAAgEglKgjsIJDAAIAAvUIpDAAgEgvVgjsIJiAAIAAvUIpiAAgEhD8gjsITYAAIAAvUIzYAAg");
   this.shape.setTransform(631.1,519.8,1,1,15);
   
   this.addChild(this.shape);
   }).prototype = p = new cjs.Container();
  p.nominalBounds = new cjs.Rectangle(0,0,1269.3,1014.6);
  
  
  (lib.Seq3DollarSign = function() {
   this.initialize();
   
   // Onboarding 3D
   this.shape = new cjs.Shape();
   this.shape.graphics.f("#30373E").s().p("AgjGBIAAhbQg5gIg3gWQg4gWgsgiIBGhmQBNA6BGAPIAAiPQhlgcgtgnQgvgtgBhNIAAgCQAAhKA1gvQAzgvBVgIIAAg1IBcAAIAAA3QBYALBPA3Ig8BpQg3gmg5gPIAACJQBoAcAuAsQAuAsAABLIAAABQAABLg1AvQgzAvhXAJIAABZgAA0C3QBBgKgBgvIAAgCQABgXgOgPQgPgQgkgNgAhcijIAAACQAAAWAMAOQAOAPAkANIAAh6Qg+AHAAAxg");
   
   this.addChild(this.shape);
   }).prototype = p = new cjs.Container();
  p.nominalBounds = new cjs.Rectangle(-24.8,-38.5,49.7,77.1);
  
  
  (lib.Seq3CityBG = function() {
   this.initialize();
   
   // Graphic
   this.shape = new cjs.Shape();
   this.shape.graphics.f("#8F8F8F").s().p("A3lK8IAA1PIyvAAIAASGIlVAAIAAgnIEsAAIAAyHIUBAAIAAVOIEsAAIAAtZIPUAAIAAKSIF6AAIAAsLIEXAAIAAl8IMhAAIAANvIF7AAIAAl6IPUAAIAAKSIGlAAIAAAnInMAAIAAqSIuEAAIAAF6InMAAIAAtuIrQAAIAAF9IkZAAIAAMJInKAAIAAqSIuEAAIAANbg");
   this.shape.setTransform(305,70);
   
   this.addChild(this.shape);
   }).prototype = p = new cjs.Container();
  p.nominalBounds = new cjs.Rectangle(0,0,610,140);
  
  
  (lib.Seq3Checkmark = function() {
   this.initialize();
   
   // Layer 1
   this.shape = new cjs.Shape();
   this.shape.graphics.f().s("#1AAC9A").ss(5,1,1).p("Ai4AyIBaBaIEXkX");
   this.shape.setTransform(18.5,14);
   
   this.addChild(this.shape);
   }).prototype = p = new cjs.Container();
  p.nominalBounds = new cjs.Rectangle(-2.5,-2.5,42,33);
  
  
  (lib.Seq3Car2GoWheel = function() {
   this.initialize();
   
   // Layer 1
   this.shape = new cjs.Shape();
   this.shape.graphics.f("#D9D9D9").s().p("AhqByQgvgsgChBQgCg/AsgvQAsgvBBgDQA+gCAwAsQAvAsADBBQACA/gsAvQgsAwhBACIgFAAQg9AAgtgqg");
   this.shape.setTransform(15.7,15.6);
   
   this.addChild(this.shape);
   }).prototype = p = new cjs.Container();
  p.nominalBounds = new cjs.Rectangle(0,0,31.3,31.3);
  
  
  (lib.Seq3Car2GoIconDark = function() {
   this.initialize();
   
   // Layer 1
   this.shape = new cjs.Shape();
   this.shape.graphics.f("#8F8F8F").s().p("Ak7FzIgUgJQAHgagBgcQgChMg4g0Qg4g0hMADQhMACg0A4Qg0A4ACBMIABAGQgLgDgGggIgFggQgDhWAbg+IAdgtQgGidBAh+QAgg/AhgfIgZgaQD8gdCWgFQBqgEBIATQA9AQBWAuQBCAjCEBnQBDAzA1AtIArgCQAqALA/A/QAgAgAXAeIAHBGQAlAkgGBTQgDAqgLAiIgRABQACgOAAgPQgDhNg5g1Qg5g0hNACQhNADg1A6Qg1A5ACBOIAEAeIgXANgAGMhGQhChBhZhCQiyiChzgCIiXAAIAHDOIJQA5IAAAAgAj/iBIgHjLIgVACQgWACgYAUQgwAogKBeIAtAIQAzAMAaAYIAKABg");
   this.shape.setTransform(72,37.2);
   
   this.shape_1 = new cjs.Shape();
   this.shape_1.graphics.f("#8F8F8F").s().p("AhqByQgvgsgChBQgCg/AsgvQAsgvBBgDQA+gCAwAsQAvAsADBBQACA/gsAvQgsAwhBACIgFAAQg9AAgtgqg");
   this.shape_1.setTransform(122.6,69.5);
   
   this.shape_2 = new cjs.Shape();
   this.shape_2.graphics.f("#8F8F8F").s().p("AhpByQgvgsgDhBQgCg/AsgvQAsgvBBgDQA/gCAvAsQAwAsACBBQACA/gsAvQgsAwhBACIgFAAQg8AAgtgqg");
   this.shape_2.setTransform(20.3,69.5);
   
   this.addChild(this.shape_2,this.shape_1,this.shape);
   }).prototype = p = new cjs.Container();
  p.nominalBounds = new cjs.Rectangle(0,0,144.1,85.1);
  
  
  (lib.Seq3Car2GoIcon = function() {
   this.initialize();
   
   // Layer 1
   this.shape = new cjs.Shape();
   this.shape.graphics.f("#D9D9D9").s().p("Ak7FzIgUgJQAHgagBgcQgChMg4g0Qg4g0hMADQhMACg0A4Qg0A4ACBMIABAGQgLgDgGggIgFggQgDhWAbg+IAdgtQgGidBAh+QAgg/AhgfIgZgaQD8gdCWgFQBqgEBIATQA9AQBWAuQBCAjCEBnQBDAzA1AtIArgCQAqALA/A/QAgAgAXAeIAHBGQAlAkgGBTQgDAqgLAiIgRABQACgOAAgPQgDhNg5g1Qg5g0hNACQhNADg1A6Qg1A5ACBOIAEAeIgXANgAGMhGQhChBhZhCQiyiChzgCIiXAAIAHDOIJQA5IAAAAgAj/iBIgHjLIgVACQgWACgYAUQgwAogKBeIAtAIQAzAMAaAYIAKABg");
   this.shape.setTransform(72,37.2);
   
   this.shape_1 = new cjs.Shape();
   this.shape_1.graphics.f("#D9D9D9").s().p("AhqByQgvgsgChBQgCg/AsgvQAsgvBBgDQA+gCAwAsQAvAsADBBQACA/gsAvQgsAwhBACIgFAAQg9AAgtgqg");
   this.shape_1.setTransform(122.6,69.5);
   
   this.shape_2 = new cjs.Shape();
   this.shape_2.graphics.f("#D9D9D9").s().p("AhpByQgvgsgDhBQgCg/AsgvQAsgvBBgDQA/gCAvAsQAwAsACBBQACA/gsAvQgsAwhBACIgFAAQg8AAgtgqg");
   this.shape_2.setTransform(20.3,69.5);
   
   this.addChild(this.shape_2,this.shape_1,this.shape);
   }).prototype = p = new cjs.Container();
  p.nominalBounds = new cjs.Rectangle(0,0,144.1,85.1);
  
  
  (lib.Seq3Car2GoBody = function() {
   this.initialize();
   
   // Layer 1
   this.shape = new cjs.Shape();
   this.shape.graphics.f("#D9D9D9").s().p("Ak7FzIgUgJQAHgagBgcQgChMg4g0Qg4g0hMADQhMACg0A4Qg0A4ACBMIABAGQgLgDgGggIgFggQgDhWAbg+IAdgtQgGidBAh+QAgg/AhgfIgZgaQD8gdCWgFQBqgEBIATQA9AQBWAuQBCAjCEBnQBDAzA1AtIArgCQAqALA/A/QAgAgAXAeIAHBGQAlAkgGBTQgDAqgLAiIgRABQACgOAAgPQgDhNg5g1Qg5g0hNACQhNADg1A6Qg1A5ACBOIAEAeIgXANgAGMhGQhChBhZhCQiyiChzgCIiXAAIAHDOIJQA5IAAAAgAj/iBIgHjLIgVACQgWACgYAUQgwAogKBeIAtAIQAzAMAaAYIAKABg");
   this.shape.setTransform(72,37.2);
   
   this.addChild(this.shape);
   }).prototype = p = new cjs.Container();
  p.nominalBounds = new cjs.Rectangle(0,0,144.1,74.4);
  
  
  (lib.Seq3Car2GoBGDark = function() {
   this.initialize();
   
   // Layer 1
   this.shape = new cjs.Shape();
   this.shape.graphics.f("#30373E").s().p("AsIMJQlClCAAnHQAAnHFClBQFClCHGAAQHIAAFBFCQFCFBAAHHQAAHHlCFCQlBFDnIgBQnGABlClDg");
   
   this.addChild(this.shape);
   }).prototype = p = new cjs.Container();
  p.nominalBounds = new cjs.Rectangle(-110,-110,220,220);
  
  
  (lib.Seq3Car2GoBG = function() {
   this.initialize();
   
   // Layer 1
   this.shape = new cjs.Shape();
   this.shape.graphics.f("#009BE0").s().p("AsIMJQlClCAAnHQAAnHFClBQFClCHGAAQHIAAFBFCQFCFBAAHHQAAHHlCFCQlBFDnIgBQnGABlClDg");
   
   this.addChild(this.shape);
   }).prototype = p = new cjs.Container();
  p.nominalBounds = new cjs.Rectangle(-110,-110,220,220);
  
  
  (lib.Seq3Car2GoIconMotion = function(mode,startPosition,loop) {
   this.initialize(mode,startPosition,loop,{});
   
   // Body
   this.instance = new lib.Seq3Car2GoBody();
   this.instance.setTransform(72,37.1,1,1,0,0,0,72,37.1);
   
   this.timeline.addTween(cjs.Tween.get(this.instance).to({y:36.1},3,cjs.Ease.get(1)).to({y:37.1},2,cjs.Ease.get(-1)).wait(1));
   
   // Front Wheel
   this.instance_1 = new lib.Seq3Car2GoWheel();
   this.instance_1.setTransform(122.7,69.5,1,1,0,0,0,15.7,15.6);
   
   this.timeline.addTween(cjs.Tween.get(this.instance_1).wait(6));
   
   // Back Wheel
   this.instance_2 = new lib.Seq3Car2GoWheel();
   this.instance_2.setTransform(20.4,69.5,1,1,0,0,0,15.7,15.6);
   
   this.timeline.addTween(cjs.Tween.get(this.instance_2).wait(6));
   
   }).prototype = p = new cjs.MovieClip();
  p.nominalBounds = new cjs.Rectangle(0,0,144.1,85.1);
  
  
  // stage content:
  (lib.onboarding_seq_3 = function(mode,startPosition,loop) {
   if (loop == null) { loop = false; }	this.initialize(mode,startPosition,loop,{});
   
   // Check Green Circle Outline Mask (mask)
   var mask = new cjs.Shape();
   mask._off = true;
   var mask_graphics_142 = new cjs.Graphics().p("EgCjAsTIAA0UIURAAIAAUUg");
   var mask_graphics_143 = new cjs.Graphics().p("EgCjAp6IAA0UIURAAIAAUUg");
   var mask_graphics_144 = new cjs.Graphics().p("EgCjAn2IAA0UIURAAIAAUUg");
   var mask_graphics_145 = new cjs.Graphics().p("EgCjAmGIAA0UIURAAIAAUUg");
   var mask_graphics_146 = new cjs.Graphics().p("EgCjAkrIAA0UIURAAIAAUUg");
   var mask_graphics_147 = new cjs.Graphics().p("EgCjAjkIAA0UIURAAIAAUUg");
   var mask_graphics_148 = new cjs.Graphics().p("EgCjAixIAA0UIURAAIAAUUg");
   var mask_graphics_149 = new cjs.Graphics().p("EgCjAiTIAA0UIURAAIAAUUg");
   var mask_graphics_150 = new cjs.Graphics().p("EgCjAiJIAA0VIURAAIAAUVg");
   
   this.timeline.addTween(cjs.Tween.get(mask).to({graphics:null,x:0,y:0}).wait(142).to({graphics:mask_graphics_142,x:113.5,y:283.5}).wait(1).to({graphics:mask_graphics_143,x:113.5,y:268.3}).wait(1).to({graphics:mask_graphics_144,x:113.5,y:255.1}).wait(1).to({graphics:mask_graphics_145,x:113.5,y:243.9}).wait(1).to({graphics:mask_graphics_146,x:113.5,y:234.8}).wait(1).to({graphics:mask_graphics_147,x:113.5,y:227.6}).wait(1).to({graphics:mask_graphics_148,x:113.5,y:222.6}).wait(1).to({graphics:mask_graphics_149,x:113.5,y:219.5}).wait(1).to({graphics:mask_graphics_150,x:113.5,y:218.5}).wait(15));
   
   // Check Green Circle Outline
   this.shape = new cjs.Shape();
   this.shape.graphics.f("#00AD9A").s().p("AnKHLQi/i+ABkNQgBkMC/i+QC+i+EMgBQEMABC/C+QC/C+gBEMQABENi/C+Qi/C/kMAAQkLAAi/i/gAmfmgQiuCuAADyQAADzCuCuQCsCsDzABQD0gBCsisQCuiuAAjzQAAjyiuiuQisitj0ABQjzgBisCtg");
   this.shape.setTransform(162,372);
   this.shape._off = true;
   
   this.shape.mask = mask;
   
   this.timeline.addTween(cjs.Tween.get(this.shape).wait(142).to({_off:false},0).wait(23));
   
   // Check Sign Mask (mask)
   var mask_1 = new cjs.Shape();
   mask_1._off = true;
   var mask_1_graphics_142 = new cjs.Graphics().p("ABhe+QiriuAAj0QAAjzCriuQCuitD0ABQDzgBCuCtQCtCuAADzQAAD0itCuQiuCsjzABQj0gBiuisg");
   
   this.timeline.addTween(cjs.Tween.get(mask_1).to({graphics:null,x:0,y:0}).wait(142).to({graphics:mask_1_graphics_142,x:110.5,y:215.5}).wait(23));
   
   // Check Sign
   this.instance = new lib.Seq3Checkmark();
   this.instance.setTransform(163.1,462.3,1.73,1.73,0,0,0,18.5,14);
   this.instance._off = true;
   
   this.instance.mask = mask_1;
   
   this.timeline.addTween(cjs.Tween.get(this.instance).wait(142).to({_off:false},0).to({x:161.4,y:373.3},8,cjs.Ease.get(1)).wait(15));
   
   // Dollar Sign Mask (mask)
   var mask_2 = new cjs.Shape();
   mask_2._off = true;
   var mask_2_graphics_109 = new cjs.Graphics().p("EABhA4NQiriuAAj0QAAjzCritQCuitD0AAQDzAACuCtQCtCtAADzQAAD0itCuQiuCsjzABQj0gBiuisg");
   var mask_2_graphics_110 = new cjs.Graphics().p("EABhA08QiritAAj0QAAj0CritQCuitD0AAQDzAACuCtQCtCtAAD0QAAD0itCtQiuCtjzAAQj0AAiuitg");
   var mask_2_graphics_111 = new cjs.Graphics().p("EABhAx7QiritAAj0QAAj0CritQCuitD0AAQDzAACuCtQCtCtAAD0QAAD0itCtQiuCtjzAAQj0AAiuitg");
   var mask_2_graphics_112 = new cjs.Graphics().p("EABhAvHQiritAAj0QAAj0CritQCuitD0AAQDzAACuCtQCtCtAAD0QAAD0itCtQiuCtjzAAQj0AAiuitg");
   var mask_2_graphics_113 = new cjs.Graphics().p("EABhAsiQiritAAj0QAAj0CritQCuitD0AAQDzAACuCtQCtCtAAD0QAAD0itCtQiuCtjzAAQj0AAiuitg");
   var mask_2_graphics_114 = new cjs.Graphics().p("EABhAqLQiritAAj0QAAj0CritQCuitD0AAQDzAACuCtQCtCtAAD0QAAD0itCtQiuCtjzAAQj0AAiuitg");
   var mask_2_graphics_115 = new cjs.Graphics().p("EABhAoDQiritAAj0QAAj0CritQCuitD0AAQDzAACuCtQCtCtAAD0QAAD0itCtQiuCtjzAAQj0AAiuitg");
   var mask_2_graphics_116 = new cjs.Graphics().p("EABhAmJQiritAAj0QAAj0CritQCuitD0AAQDzAACuCtQCtCtAAD0QAAD0itCtQiuCtjzAAQj0AAiuitg");
   var mask_2_graphics_117 = new cjs.Graphics().p("EABhAkdQiritAAj0QAAj0CritQCuitD0AAQDzAACuCtQCtCtAAD0QAAD0itCtQiuCtjzAAQj0AAiuitg");
   var mask_2_graphics_118 = new cjs.Graphics().p("EABhAjAQiritAAj0QAAj0CritQCuitD0AAQDzAACuCtQCtCtAAD0QAAD0itCtQiuCtjzAAQj0AAiuitg");
   var mask_2_graphics_119 = new cjs.Graphics().p("EABhAhxQiritAAj0QAAj0CritQCuitD0AAQDzAACuCtQCtCtAAD0QAAD0itCtQiuCtjzAAQj0AAiuitg");
   var mask_2_graphics_120 = new cjs.Graphics().p("EABhAgwQiritAAj0QAAj0CritQCuitD0AAQDzAACuCtQCtCtAAD0QAAD0itCtQiuCtjzAAQj0AAiuitg");
   var mask_2_graphics_121 = new cjs.Graphics().p("ABhf+QiritAAj0QAAj0CritQCuitD0AAQDzAACuCtQCtCtAAD0QAAD0itCtQiuCtjzAAQj0AAiuitg");
   var mask_2_graphics_122 = new cjs.Graphics().p("ABhfaQiritAAj0QAAj0CritQCuitD0AAQDzAACuCtQCtCtAAD0QAAD0itCtQiuCtjzAAQj0AAiuitg");
   var mask_2_graphics_123 = new cjs.Graphics().p("ABhfFQiritAAj0QAAj0CritQCuitD0AAQDzAACuCtQCtCtAAD0QAAD0itCtQiuCtjzAAQj0AAiuitg");
   var mask_2_graphics_124 = new cjs.Graphics().p("ABhe+QiriuAAj0QAAjzCriuQCuitD0ABQDzgBCuCtQCtCuAADzQAAD0itCuQiuCsjzABQj0gBiuisg");
   
   this.timeline.addTween(cjs.Tween.get(mask_2).to({graphics:null,x:0,y:0}).wait(109).to({graphics:mask_2_graphics_109,x:110.5,y:377}).wait(1).to({graphics:mask_2_graphics_110,x:110.5,y:356.2}).wait(1).to({graphics:mask_2_graphics_111,x:110.5,y:336.8}).wait(1).to({graphics:mask_2_graphics_112,x:110.5,y:318.9}).wait(1).to({graphics:mask_2_graphics_113,x:110.5,y:302.4}).wait(1).to({graphics:mask_2_graphics_114,x:110.5,y:287.3}).wait(1).to({graphics:mask_2_graphics_115,x:110.5,y:273.6}).wait(1).to({graphics:mask_2_graphics_116,x:110.5,y:261.4}).wait(1).to({graphics:mask_2_graphics_117,x:110.5,y:250.7}).wait(1).to({graphics:mask_2_graphics_118,x:110.5,y:241.3}).wait(1).to({graphics:mask_2_graphics_119,x:110.5,y:233.4}).wait(1).to({graphics:mask_2_graphics_120,x:110.5,y:227}).wait(1).to({graphics:mask_2_graphics_121,x:110.5,y:222}).wait(1).to({graphics:mask_2_graphics_122,x:110.5,y:218.4}).wait(1).to({graphics:mask_2_graphics_123,x:110.5,y:216.2}).wait(1).to({graphics:mask_2_graphics_124,x:110.5,y:215.5}).wait(41));
   
   // Dollar Sign
   this.instance_1 = new lib.Seq3DollarSign();
   this.instance_1.setTransform(162,694);
   this.instance_1._off = true;
   
   this.instance_1.mask = mask_2;
   
   this.timeline.addTween(cjs.Tween.get(this.instance_1).wait(109).to({_off:false},0).to({y:370},15,cjs.Ease.get(1)).wait(9).to({y:380},5,cjs.Ease.get(1)).to({y:268},8,cjs.Ease.get(-1)).wait(19));
   
   // Receipt Circle Mask (mask)
   var mask_3 = new cjs.Shape();
   mask_3._off = true;
   var mask_3_graphics_109 = new cjs.Graphics().p("EgCjA7XIAA0TIURAAIAAUTg");
   var mask_3_graphics_110 = new cjs.Graphics().p("EgCjA4HIAA0UIURAAIAAUUg");
   var mask_3_graphics_111 = new cjs.Graphics().p("EgCjA1GIAA0UIURAAIAAUUg");
   var mask_3_graphics_112 = new cjs.Graphics().p("EgCjAySIAA0UIURAAIAAUUg");
   var mask_3_graphics_113 = new cjs.Graphics().p("EgCjAvtIAA0UIURAAIAAUUg");
   var mask_3_graphics_114 = new cjs.Graphics().p("EgCjAtWIAA0UIURAAIAAUUg");
   var mask_3_graphics_115 = new cjs.Graphics().p("EgCjArOIAA0UIURAAIAAUUg");
   var mask_3_graphics_116 = new cjs.Graphics().p("EgCjApUIAA0UIURAAIAAUUg");
   var mask_3_graphics_117 = new cjs.Graphics().p("EgCjAnoIAA0UIURAAIAAUUg");
   var mask_3_graphics_118 = new cjs.Graphics().p("EgCjAmLIAA0UIURAAIAAUUg");
   var mask_3_graphics_119 = new cjs.Graphics().p("EgCjAk8IAA0UIURAAIAAUUg");
   var mask_3_graphics_120 = new cjs.Graphics().p("EgCjAj7IAA0UIURAAIAAUUg");
   var mask_3_graphics_121 = new cjs.Graphics().p("EgCjAjJIAA0UIURAAIAAUUg");
   var mask_3_graphics_122 = new cjs.Graphics().p("EgCjAilIAA0UIURAAIAAUUg");
   var mask_3_graphics_123 = new cjs.Graphics().p("EgCjAiQIAA0UIURAAIAAUUg");
   var mask_3_graphics_124 = new cjs.Graphics().p("EgCjAiJIAA0VIURAAIAAUVg");
   var mask_3_graphics_142 = new cjs.Graphics().p("EgCjAiJIAA0VIURAAIAAUVg");
   var mask_3_graphics_143 = new cjs.Graphics().p("AijfwIAA0UIURAAIAAUUg");
   var mask_3_graphics_144 = new cjs.Graphics().p("AijdsIAA0UIURAAIAAUUg");
   var mask_3_graphics_145 = new cjs.Graphics().p("Aijb8IAA0UIURAAIAAUUg");
   var mask_3_graphics_146 = new cjs.Graphics().p("AijahIAA0UIURAAIAAUUg");
   var mask_3_graphics_147 = new cjs.Graphics().p("AijZaIAA0UIURAAIAAUUg");
   var mask_3_graphics_148 = new cjs.Graphics().p("AijYnIAA0UIURAAIAAUUg");
   var mask_3_graphics_149 = new cjs.Graphics().p("AijYJIAA0UIURAAIAAUUg");
   var mask_3_graphics_150 = new cjs.Graphics().p("AijX+IAA0TIURAAIAAUTg");
   
   this.timeline.addTween(cjs.Tween.get(mask_3).to({graphics:null,x:0,y:0}).wait(109).to({graphics:mask_3_graphics_109,x:113.5,y:380}).wait(1).to({graphics:mask_3_graphics_110,x:113.5,y:359.2}).wait(1).to({graphics:mask_3_graphics_111,x:113.5,y:339.8}).wait(1).to({graphics:mask_3_graphics_112,x:113.5,y:321.9}).wait(1).to({graphics:mask_3_graphics_113,x:113.5,y:305.4}).wait(1).to({graphics:mask_3_graphics_114,x:113.5,y:290.3}).wait(1).to({graphics:mask_3_graphics_115,x:113.5,y:276.6}).wait(1).to({graphics:mask_3_graphics_116,x:113.5,y:264.4}).wait(1).to({graphics:mask_3_graphics_117,x:113.5,y:253.7}).wait(1).to({graphics:mask_3_graphics_118,x:113.5,y:244.3}).wait(1).to({graphics:mask_3_graphics_119,x:113.5,y:236.4}).wait(1).to({graphics:mask_3_graphics_120,x:113.5,y:230}).wait(1).to({graphics:mask_3_graphics_121,x:113.5,y:225}).wait(1).to({graphics:mask_3_graphics_122,x:113.5,y:221.4}).wait(1).to({graphics:mask_3_graphics_123,x:113.5,y:219.2}).wait(1).to({graphics:mask_3_graphics_124,x:113.5,y:218.5}).wait(18).to({graphics:mask_3_graphics_142,x:113.5,y:218.5}).wait(1).to({graphics:mask_3_graphics_143,x:113.5,y:203.3}).wait(1).to({graphics:mask_3_graphics_144,x:113.5,y:190.1}).wait(1).to({graphics:mask_3_graphics_145,x:113.5,y:178.9}).wait(1).to({graphics:mask_3_graphics_146,x:113.5,y:169.8}).wait(1).to({graphics:mask_3_graphics_147,x:113.5,y:162.6}).wait(1).to({graphics:mask_3_graphics_148,x:113.5,y:157.6}).wait(1).to({graphics:mask_3_graphics_149,x:113.5,y:154.5}).wait(1).to({graphics:mask_3_graphics_150,x:113.5,y:153.5}).wait(15));
   
   // Receipt Circle
   this.instance_2 = new lib.Seq3ReceiptCircle();
   this.instance_2.setTransform(162,695,1,1,0,0,0,65,65);
   this.instance_2._off = true;
   
   this.instance_2.mask = mask_3;
   
   this.timeline.addTween(cjs.Tween.get(this.instance_2).wait(109).to({_off:false},0).to({y:372},15,cjs.Ease.get(1)).wait(41));
   
   // Receipt
   this.instance_3 = new lib.Seq3Receipt();
   this.instance_3.setTransform(162,737.5,1,1,0,0,0,140,161.5);
   this.instance_3._off = true;
   
   this.timeline.addTween(cjs.Tween.get(this.instance_3).wait(109).to({_off:false},0).to({y:414.5},15,cjs.Ease.get(1)).wait(41));
   
   // Seq 3 Car2Go Icon Motion
   this.instance_4 = new lib.Seq3Car2GoIconMotion();
   this.instance_4.setTransform(122.1,140,0.318,0.318,0,0,0,72.1,42.6);
   this.instance_4._off = true;
   
   this.timeline.addTween(cjs.Tween.get(this.instance_4).wait(14).to({_off:false},0).to({scaleX:1.76,scaleY:1.75,x:162.2,y:288.2},20,cjs.Ease.get(1)).to({_off:true},65).wait(66));
   
   // Seq 3 Car2Go Icon Dark
   this.instance_5 = new lib.Seq3Car2GoIconDark();
   this.instance_5.setTransform(162,288.3,1.756,1.756,0,0,0,72,42.6);
   this.instance_5.alpha = 0;
   this.instance_5._off = true;
   
   this.timeline.addTween(cjs.Tween.get(this.instance_5).wait(103).to({_off:false},0).to({alpha:1},5).wait(57));
   
   // Seq 3 Car2Go Icon
   this.instance_6 = new lib.Seq3Car2GoIcon();
   this.instance_6.setTransform(122,140,0.318,0.318,0,0,0,72,42.6);
   
   this.timeline.addTween(cjs.Tween.get(this.instance_6).to({_off:true},14).wait(85).to({_off:false,scaleX:1.76,scaleY:1.76,x:162,y:288.3},0).to({_off:true},9).wait(57));
   
   // Seq 3 City BG Mask (mask)
   var mask_4 = new cjs.Shape();
   mask_4._off = true;
   var mask_4_graphics_26 = new cjs.Graphics().p("ADOYHQiSiSAAjPQAAjQCSiSQCSiSDQAAQDPAACSCSQCSCSAADQQAADPiSCSQiSCSjPAAQjQAAiSiSg");
   var mask_4_graphics_27 = new cjs.Graphics().p("AhQY4QjYjYAAkyQAAkyDYjYQDXjYExAAQEyAADZDYQDYDYAAEyQAAEyjYDYQjZDZkyAAQkxAAjXjZg");
   var mask_4_graphics_28 = new cjs.Graphics().p("AliZnQkbkaAAmQQAAmREbkaQEbkZGOAAQGQAAEbEZQEaEaAAGRQAAGQkaEaQkbEbmQAAQmOAAkbkbg");
   var mask_4_graphics_29 = new cjs.Graphics().p("ApoaUQlblaAAnqQAAnqFblaQFalZHoAAQHqAAFbFZQFaFaAAHqQAAHqlaFaQlbFbnqAAQnoAAlalbg");
   var mask_4_graphics_30 = new cjs.Graphics().p("Atia/QmWmXAAo/QAApAGWmVQGYmWI9AAQJAAAGWGWQGXGVAAJAQAAI/mXGXQmWGXpAAAQo9AAmYmXg");
   var mask_4_graphics_31 = new cjs.Graphics().p("AxObnQnQnQAAqQQAAqPHQnQQHRnQKOAAQKRAAHQHQQHQHQAAKPQAAKQnQHQQnQHRqRAAQqOAAnRnRg");
   var mask_4_graphics_32 = new cjs.Graphics().p("AzjcOQoGoHAArdQAArcIGoGQIHoGLcAAQLdAAIHIGQIGIGAALcQAALdoGIHQoHIHrdAAQrcAAoHoHg");
   var mask_4_graphics_33 = new cjs.Graphics().p("A1ecyQo5o6AAslQAAskI5o6QI6o5MkAAQMmAAI5I5QI5I6AAMkQAAMlo5I6Qo5I6smAAQskAAo6o6g");
   var mask_4_graphics_34 = new cjs.Graphics().p("A3SdUQpqpqAAtpQAAtoJqpqQJqppNoAAQNqAAJpJpQJqJqAANoQAANppqJqQppJqtqAAQtoAApqpqg");
   var mask_4_graphics_35 = new cjs.Graphics().p("A4/dzQqWqWAAupQAAuoKWqWQKYqWOnAAQOpAAKXKWQKWKWAAOoQAAOpqWKWQqXKYupAAQunAAqYqYg");
   var mask_4_graphics_36 = new cjs.Graphics().p("A6keRQrArAAAvkQAAvjLArBQLBrAPjAAQPlAALALAQLALBAAPjQAAPkrALAQrALBvlAAQvjAArBrBg");
   var mask_4_graphics_37 = new cjs.Graphics().p("A8BesQrnrnAAwaQAAwaLnrnQLornQZAAQQcAALmLnQLnLnAAQaQAAQarnLnQrmLowcAAQwZAArorog");
   var mask_4_graphics_38 = new cjs.Graphics().p("A9YfGQsKsLAAxNQAAxNMKsKQMMsLRMAAQROAAMLMLQMKMKAARNQAARNsKMLQsLMLxOAAQxMAAsMsLg");
   var mask_4_graphics_39 = new cjs.Graphics().p("A+mfdQsrssAAx7QAAx6MrsrQMsssR6AAQR8AAMrMsQMrMrAAR6QAAR7srMsQsrMsx8AAQx6AAssssg");
   var mask_4_graphics_40 = new cjs.Graphics().p("A/tfxQtJtIAAylQAAykNJtJQNKtISjAAQSmAANINIQNJNJAASkQAASltJNIQtINKymAAQyjAAtKtKg");
   var mask_4_graphics_41 = new cjs.Graphics().p("EggtAgtQtjtjAAzKQAAzKNjtjQNktjTJAAQTLAANjNjQNjNjAATKQAATKtjNjQtjNkzLAAQzJAAtktkg");
   var mask_4_graphics_42 = new cjs.Graphics().p("EghlAhlQt6t6AAzrQAAzrN6t6QN7t6TqAAQTsAAN6N6QN6N6AATrQAATrt6N6Qt6N7zsAAQzqAAt7t7g");
   var mask_4_graphics_43 = new cjs.Graphics().p("EgiWAiVQuOuOAA0HQAA0IOOuOQOQuOUGAAQUJAAOOOOQOOOOAAUIQAAUHuOOOQuOOQ0JAAQ0GAAuQuQg");
   var mask_4_graphics_44 = new cjs.Graphics().p("Egi/Ai+QufufAA0fQAA0gOfufQOhufUeAAQUhAAOfOfQOfOfAAUgQAAUfufOfQufOh0hAAQ0eAAuhuhg");
   var mask_4_graphics_45 = new cjs.Graphics().p("EgjhAjgQututAA0zQAA0zOtuuQOvutUyAAQU0AAOuOtQOtOuAAUzQAAUzutOtQuuOv00AAQ0yAAuvuvg");
   var mask_4_graphics_46 = new cjs.Graphics().p("Egj7Aj6Qu4u4AA1CQAA1DO4u4QO6u4VBAAQVEAAO4O4QO4O4AAVDQAAVCu4O4Qu4O61EAAQ1BAAu6u6g");
   var mask_4_graphics_47 = new cjs.Graphics().p("EgkOAkNQu/vAAA1NQAA1OO/vAQPCu/VMAAQVPAAPAO/QO/PAAAVOQAAVNu/PAQvAPB1PAAQ1MAAvCvBg");
   var mask_4_graphics_48 = new cjs.Graphics().p("EgkZAkYQvEvEAA1UQAA1UPEvFQPGvEVTAAQVVAAPFPEQPEPFAAVUQAAVUvEPEQvFPG1VAAQ1TAAvGvGg");
   var mask_4_graphics_49 = new cjs.Graphics().p("EgkcAkcQvHvGAA1WQAA1XPHvFQPHvHVVAAQVXAAPGPHQPHPFAAVXQAAVWvHPGQvGPH1XABQ1VgBvHvHg");
   
   this.timeline.addTween(cjs.Tween.get(mask_4).to({graphics:null,x:0,y:0}).wait(26).to({graphics:mask_4_graphics_26,x:106,y:169}).wait(1).to({graphics:mask_4_graphics_27,x:117.9,y:180.9}).wait(1).to({graphics:mask_4_graphics_28,x:129.3,y:192.3}).wait(1).to({graphics:mask_4_graphics_29,x:140.1,y:203.1}).wait(1).to({graphics:mask_4_graphics_30,x:150.5,y:213.5}).wait(1).to({graphics:mask_4_graphics_31,x:160.3,y:223.3}).wait(1).to({graphics:mask_4_graphics_32,x:162,y:232.5}).wait(1).to({graphics:mask_4_graphics_33,x:162,y:241.2}).wait(1).to({graphics:mask_4_graphics_34,x:162,y:249.5}).wait(1).to({graphics:mask_4_graphics_35,x:162,y:257.1}).wait(1).to({graphics:mask_4_graphics_36,x:162,y:264.3}).wait(1).to({graphics:mask_4_graphics_37,x:162,y:270.9}).wait(1).to({graphics:mask_4_graphics_38,x:162,y:277}).wait(1).to({graphics:mask_4_graphics_39,x:162,y:282.5}).wait(1).to({graphics:mask_4_graphics_40,x:162,y:287.6}).wait(1).to({graphics:mask_4_graphics_41,x:162,y:288}).wait(1).to({graphics:mask_4_graphics_42,x:162,y:288}).wait(1).to({graphics:mask_4_graphics_43,x:162,y:288}).wait(1).to({graphics:mask_4_graphics_44,x:162,y:288}).wait(1).to({graphics:mask_4_graphics_45,x:162,y:288}).wait(1).to({graphics:mask_4_graphics_46,x:162,y:288}).wait(1).to({graphics:mask_4_graphics_47,x:162,y:288}).wait(1).to({graphics:mask_4_graphics_48,x:162,y:288}).wait(1).to({graphics:mask_4_graphics_49,x:162,y:288}).wait(116));
   
   // Seq 3 City BG
   this.instance_7 = new lib.Seq3CityBG();
   this.instance_7.setTransform(303,120,1,1,0,0,0,303,70);
   this.instance_7._off = true;
   
   this.instance_7.mask = mask_4;
   
   this.timeline.addTween(cjs.Tween.get(this.instance_7).wait(26).to({_off:false},0).to({x:17},73,cjs.Ease.get(1)).wait(66));
   
   // Seq 3 Car2GoBg Dark
   this.instance_8 = new lib.Seq3Car2GoBGDark();
   this.instance_8.setTransform(162,288,0.455,0.455);
   this.instance_8._off = true;
   
   this.timeline.addTween(cjs.Tween.get(this.instance_8).wait(26).to({_off:false},0).to({scaleX:3,scaleY:3},23,cjs.Ease.get(1)).wait(116));
   
   // Seq 3 Car2Go BG
   this.instance_9 = new lib.Seq3Car2GoBG();
   this.instance_9.setTransform(122,140,0.318,0.318);
   
   this.timeline.addTween(cjs.Tween.get(this.instance_9).wait(14).to({scaleX:3,scaleY:3,x:162,y:288},20,cjs.Ease.get(1)).to({_off:true},15).wait(116));
   
   // Seq 3 Person Icon
   this.instance_10 = new lib.Seq3PersonIcon();
   this.instance_10.setTransform(183,435);
   
   this.timeline.addTween(cjs.Tween.get(this.instance_10).to({alpha:0},9).wait(156));
   
   // Seq 3 Map Green Path Mask 4 (mask)
   var mask_5 = new cjs.Shape();
   mask_5._off = true;
   mask_5.graphics.p("AgHNOIEBvEIL1DJIkDPGg");
   mask_5.setTransform(100.7,104.9);
   
   // Seq 3 Map Green Path 4
   this.instance_11 = new lib.Seq3MapGreenPath2();
   this.instance_11.setTransform(-363.8,11,1,1,0,0,0,552.6,151.7);
   
   this.instance_11.mask = mask_5;
   
   this.timeline.addTween(cjs.Tween.get(this.instance_11).to({alpha:0},9).wait(156));
   
   // Seq 3 Map Green Path Mask 3 (mask)
   var mask_6 = new cjs.Shape();
   mask_6._off = true;
   mask_6.graphics.p("AhwSbIFAyyIPGEBIlCS0g");
   mask_6.setTransform(117.5,143.8);
   
   // Seq 3 Map Green Path 3
   this.instance_12 = new lib.Seq3MapGreenPath3();
   this.instance_12.setTransform(266.2,-142.2,1,1,0,0,0,112.3,405.8);
   
   this.instance_12.mask = mask_6;
   
   this.timeline.addTween(cjs.Tween.get(this.instance_12).to({alpha:0},9).wait(156));
   
   // Seq 3 Map Green Path Mask 2 (mask)
   var mask_7 = new cjs.Shape();
   mask_7._off = true;
   mask_7.graphics.p("ADdWwIEDvGILCC9IkDPGg");
   mask_7.setTransform(118.6,164.6);
   
   // Seq 3 Map Green Path 2
   this.instance_13 = new lib.Seq3MapGreenPath2();
   this.instance_13.setTransform(-326.9,131.6,1,1,0,0,0,552.6,151.7);
   
   this.instance_13.mask = mask_7;
   
   this.timeline.addTween(cjs.Tween.get(this.instance_13).to({alpha:0},9).wait(156));
   
   // Seq 3 Map Green Path Mask 1 (mask)
   var mask_8 = new cjs.Shape();
   mask_8._off = true;
   mask_8.graphics.p("AgvfVIG45yIPGEDIm6Zyg");
   mask_8.setTransform(135.9,226.5);
   
   // Seq 3 Map Green Path 1
   this.instance_14 = new lib.Seq3MapGreenPath1();
   this.instance_14.setTransform(222,281.7,1,1,0,0,0,58,209.7);
   
   this.instance_14.mask = mask_8;
   
   this.timeline.addTween(cjs.Tween.get(this.instance_14).to({alpha:0},9).wait(156));
   
   // Seq 3 Map Mask (mask)
   var mask_9 = new cjs.Shape();
   mask_9._off = true;
   mask_9.graphics.p("EgZTAtAMAAAhZ/MAynAAAMAAABZ/g");
   mask_9.setTransform(162,288);
   
   // Seq 3 Map
   this.instance_15 = new lib.Seq3Map();
   this.instance_15.setTransform(427.6,441.9,1,1,0,0,0,634.6,507.2);
   
   this.instance_15.mask = mask_9;
   
   this.timeline.addTween(cjs.Tween.get(this.instance_15).wait(14).to({regY:507.3,scaleX:1.94,scaleY:1.94,x:749.5,y:878.1},20,cjs.Ease.get(1)).to({_off:true},1).wait(130));
   
   // Seq 3 BG Fill
   this.shape_1 = new cjs.Shape();
   this.shape_1.graphics.f("#30373E").s().p("EgZTAtAMAAAhZ/MAynAAAMAAABZ/g");
   this.shape_1.setTransform(162,288);
   
   this.timeline.addTween(cjs.Tween.get(this.shape_1).wait(165));
   
   }).prototype = p = new cjs.MovieClip();
  p.nominalBounds = new cjs.Rectangle(162,288,324,576);
  
  })(lib = lib||{}, images = images||{}, createjs = createjs||{}, ss = ss||{});
 var lib, images, createjs, ss;