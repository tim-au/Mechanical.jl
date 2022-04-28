using Mechanical

using Unitful
using Unitful: mm, cm, m, inch, N, lbf, kN

# circle
p1 = x1, y1 = circle(r=100mm, N=6)
pc1 = bolt_centroid(p1)
plot_bolt_pattern(p1)
plot_bolt_pattern(p1, udf_pivot = [-30mm, 75mm])


# rectangle
p2 = rectangle(x_dist = 250mm, y_dist = 125mm, Nx = 3, Ny=4)
pc2 = bolt_centroid(p2)
plot_bolt_pattern(p2)
plot_bolt_pattern(p2, udf_pivot = (-48, 35))

# points
x3 = [-35, -30, -25, 27, 29, 45]mm
y3 = [-20, 12, 30, 27, -20, -50]mm
p3 = x3, y3
pc3 = bolt_centroid(p3)
plot_bolt_pattern(p3)
plot_bolt_pattern(p3, udf_pivot = (-11, -20))

# custom area for points p5
A3 = [1,1,1,1,1,20]mm^2
pc4_custom = bolt_centroid(p3, A = A3)
plot_bolt_pattern(p3, A = A3)

