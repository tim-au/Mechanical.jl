using Mechanical

using Unitful
using Unitful: mm, cm, m, inch, N, kN, lbf

# loads
Fc1 = [7000,7000,5000]N
Mc1 = [30_000, 20_000, 15_000]N*m

# circle
p3 = x3, y3 = circle(r=100mm, N=7)
BL3 = bolt_loads(p3, Fc = Fc1, Mc = Mc1, load_format = "N", length_format = "mm")
plot_bolt_loads(p3, Fc = Fc1, Mc = Mc1, load_format = "kN", length_format = "mm")


# rectangle
p4 = rectangle(x_dist = 250mm, y_dist = 125mm, Nx = 3, Ny=4)
BL4 = bolt_loads(p4, Fc = Fc1, Mc = Mc1)
plot_bolt_loads(p4, Fc = Fc1, Mc = Mc1)

# points
x5 = [-35, -30, -25, 27, 29, 45]mm
y5 = [-20, 12, 30, 27, -20, -50]mm
p5 = x5, y5
BL5 = bolt_loads(p5, Fc = Fc1, Mc = Mc1)
plot_bolt_loads(p5, Fc = Fc1, Mc = Mc1)







