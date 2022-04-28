using Mechanical
using Test

using Unitful
using Unitful: mm, cm, m, inch, N, lbf, kN




###########################
# Testing BoltPattern
###########################


include("BoltPattern_tests.jl");

x1_ans = [6.1232e-15, 86.6025, 86.6025, 6.1232e-15,-86.6025, -86.6025]
y1_ans = [100.0, 49.9999, -50.0000, -100.0, -49.9999, 50.0000]
p2x_ans = [-125, -125, -125, -125, 0, 0, 125, 125, 125, 125]
p2y_ans = [62.5, 20.8333, -20.8333, -62.5, 62.5, -62.5, 62.5, 20.8333, -20.8333, -62.5]

pc1_ans = (-4.736951571734001e-15, 4.736951571734001e-15)
pc2_ans = (0.0, 2.842170943040401e-15)
pc3_ans = (1.8333333333333333, -3.5)
pc4x_ans, pc4y_ans= (34.64, -38.84)

@testset "BoltPattern" begin
    
    @test ustrip(x1) ≈ x1_ans rtol = 1e-3
    @test ustrip(y1) ≈ y1_ans rtol = 1e-3
    @test ustrip(p2[1]) ≈ p2x_ans rtol = 1e-3
    @test ustrip(p2[2]) ≈ p2y_ans rtol = 1e-3

    @test ustrip(pc1[1]) ≈ pc1_ans[1] rtol = 1e-3
    @test ustrip(pc1[2]) ≈ pc1_ans[2] rtol = 1e-3

    @test ustrip(pc2[1]) ≈ pc2_ans[1] rtol = 1e-3
    @test ustrip(pc2[2]) ≈ pc2_ans[2] rtol = 1e-3

    @test ustrip(pc3[1]) ≈ pc3_ans[1] rtol = 1e-3
    @test ustrip(pc3[2]) ≈ pc3_ans[2] rtol = 1e-3

    @test ustrip(pc4_custom[1]) ≈ pc4x_ans rtol = 1e-3
    @test ustrip(pc4_custom[2]) ≈ pc4y_ans rtol = 1e-3
end


###########################
# Testing BoltLoads
###########################

include("BoltLoads_tests.jl");

P3axial = [86428.57142857142, 9480.184018289758, -74069.10360664543, -101304.9737697821,-51718.26072777545,37351.22921413439,98832.35344320742]
P3shear = [ 20453.032308492668,21632.608383999846,22638.52711049133,22768.215616109937,21936.3079746836,20710.810223573248,20023.87620883659]

P4axial = [94.98275862068967,
45.32758620689656,
-4.327586206896551,
-53.982758620689665,
74.98275862068967,
-73.98275862068967,
54.982758620689665,
 5.327586206896558,
-44.327586206896555,
-93.98275862068967]

P4shear = [ 13.023882610799351,
11.866175534756113,
12.109199454011,
13.678497251014413,
 5.586801401047911,
 6.977973823458933,
14.303183416013933,
13.257664175634368,
13.475616831495122,
14.901705426502806]

P5axial = [   18.295539645139506,
194.50404826643035,
286.70415604763724,
104.2711455590472,
-184.0813345807953,
-414.69355493745894]

P5shear = [ 52.895052767608526,
45.3421416007837,
55.213727260003395,
52.245751989802535,
43.70618308426008,
85.69043983698432]

@testset "Boltloads" begin
    
    @test ustrip(BL3.Paxial) ≈ P3axial rtol=1e-3
    @test ustrip(BL3.Pshear) ≈ P3shear rtol=1e-3

    @test ustrip(BL4.Paxial) ≈ P4axial rtol=1e-3
    @test ustrip(BL4.Pshear) ≈ P4shear rtol=1e-3

    @test ustrip(BL5.Paxial) ≈ P5axial rtol=1e-3
    @test ustrip(BL5.Pshear) ≈ P5shear rtol=1e-3

end