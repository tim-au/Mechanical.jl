module BoltPattern

using Plots

using Unitful


export bolt_centroid, circle, rectangle, plot_bolt_pattern

"""
    bolt_centroid(points; A=1, return_all_data = false, udf_pivot = false)

Compute the bolt centroid of a bolt pattern.

`points` is a tuple of x & y coordinates ([x], [y]).  The `points` may be generated by functions [`circle`](@ref) and [`rectangle`](@ref).
`A` is the bolt stress area, either entered as a single value for all bolts or different values for each bolt (i.e. vector).
`udf_pivot` is false when it is to be calculated, or enetered as [x,y] when a specific pivot point is desired to be manually entered. Units 
conforming to the `Unitful` package should be applied.

# Examples
```julia-repl
julia> using Unitful: mm
julia> bolt_centroid(([-100, 0, 100]mm, [100, 20, -60]mm))
(0.0 mm, 20.0 mm)
julia> bolt_centroid(([-100, 0, 100]mm, [100, 20, -60]mm), A=[3, 4, 5]mm^2)
(16.666666666666668 mm, 6.666666666666667 mm)
```
"""
function bolt_centroid(points; A=1, return_all_data = false, udf_pivot = false)
    x, y = points
    
    if length(A) == 1
        A = fill(A, length(x))
    end  

    if udf_pivot == false
        xc = sum( x .* A) ./ sum(A)
        yc = sum( y .* A) ./ sum(A)
    else
        xc, yc = udf_pivot
    end

    # distance of each bolt from the pattern bolt_centroid
    rcx = x .- xc
    rcy = y .- yc

    # centroidal moment of inertia
    Icx = sum(rcy.^2 .* A)
    Icy = sum(rcx.^2 .* A)
    Icp = Icx + Icy

    # shortest distance between bolt and centroidal
    rcxy = @. √(rcx^2 + rcy^2)

    if return_all_data == false
        return xc, yc
    elseif return_all_data == true
        return xc, yc, rcx, rcy, Icx, Icy, Icp, rcxy
    else
        println("error: return_all_data not correctly specified")
    end
end




"""
    circle(;r, N=4, θ_start=0)

Compute the x & y coordinates of a circular bolt pattern.

`r` is the radius of the bolt pattern and `N` is the number of bolts in the bolt pattern. 
`θ_start` is the angle measured clockwise from the y-axis to the first bolt in the pattern. Units 
conforming to the `Unitful` package should be applied.

# Examples
```julia-repl
julia> using Unitful: mm
julia> circle(r=100mm, N=3)
(Quantity{Float64, 𝐋, Unitful.FreeUnits{(mm,), 𝐋, nothing}}  [6.123233995736766e-15 mm, 86.60254037844386 mm, -86.60254037844388 mm], Quantity{Float64, 𝐋, Unitful.FreeUnits{(mm,), 𝐋, nothing}}  [100.0 mm, -50.0 mm, -49.99999999999999 mm])
```
"""
function circle(;r, N=4, θ_start=0)
    β = deg2rad(θ_start)
    θ = LinRange(π/2, -3π/2 + 2π/N, N)
    points = @. r * cos(θ - β) , r * sin(θ - β) 

    return points
end


"""
    rectangle(;x_dist, y_dist, Nx=2, Ny=2)

Compute the x & y coordinates of a rectangular bolt pattern.

`x_dist` is the width of the rectangular bolt pattern in the x-direction. 
`y_dist` is the height of the rectangular bolt pattern in the y-direction. 
`Nx` and `Ny` are the number of bolts along the width and height of the bolt pattern respectively. Units 
conforming to the `Unitful` package should be applied.

# Examples
```julia-repl
julia> using Unitful: mm
julia> rectangle(x_dist = 250mm, y_dist = 125mm, Nx = 3, Ny=4)
(Quantity{Float64, 𝐋, Unitful.FreeUnits{(mm,), 𝐋, nothing}}  [-125.0 mm, -125.0 mm, -125.0 mm, -125.0 mm, 0.0 mm, 0.0 mm, 125.0 mm, 125.0 mm, 125.0 mm, 125.0 mm], Quantity{Float64, 𝐋, Unitful.FreeUnits{(mm,), 𝐋, nothing}}  [62.5 mm, 20.83333333333334 mm, -20.83333333333333 mm, -62.5 mm, 62.5 mm, -62.5 mm, 62.5 mm, 20.83333333333334 mm, -20.83333333333333 mm, -62.5 mm])
```
"""
function rectangle(;x_dist, y_dist, Nx=2, Ny=2)
    x = LinRange(-x_dist / 2, x_dist / 2, Nx)
    y = LinRange(y_dist / 2, -y_dist / 2, Ny)

    y_outer = [y[1], y[end]]
    x_out = [ repeat([x[1]], inner = Ny) ; repeat(x[2:end-1], inner = 2) ; repeat([x[end]], inner = Ny) ]
    y_out = [ y ; repeat(y_outer, Nx - 2) ; y ]
    points = x_out, y_out

    return points
end


"""
    plot_bolt_pattern(points; A = 1, udf_pivot = false)

Plot bolt pattern and centroid.

`points` is a tuple of x & y coordinates ([x], [y]).  The `points` may be generated by functions [`circle`](@ref) and [`rectangle`](@ref).
`A` is the bolt stress area, either entered as a single value for all bolts or different values for each bolt (i.e. vector).
`udf_pivot` is false when it is to be calculated, or enetered as [x,y] when a specific pivot point is desired to be manually entered. Units 
conforming to the `Unitful` package should be applied.
"""
function plot_bolt_pattern(points; A = 1, udf_pivot = false)

    x,y = points

    if udf_pivot != false
        xc, yc = udf_pivot
    else
        xc, yc = bolt_centroid(points, A=A)
    end

    unit_type = string(unit(x[1]))

    # get range of x,y points
    x_plot = ustrip(x)
    y_plot = ustrip(y)
    xrange = (maximum(x_plot) - minimum(x_plot))
    yrange = (maximum(y_plot) - minimum(y_plot))

    # determine xlims and ylims for the plot
    scale = 0.1
    xs = minimum(x_plot) - scale * xrange
    xf = maximum(x_plot) + scale * xrange
    ys = minimum(y_plot) - scale * yrange
    yf = maximum(y_plot) + scale * yrange
  
    scatter(x_plot, y_plot,
            xlims = [xs, xf],
            ylims = [ys, yf], 
            marker = :hexagon, 
            markersize = 10,
            markercolor = :grey,
            markerstrokecolor = :black,
            aspect_ratio = 1,
            alpha = 1,
            legend = false,
            xlabel = "x coordinate [$unit_type]",
            ylabel = "y coordinate [$unit_type]")
    
    # plot centroid
    xc_hover = map(x -> "$(round.(ustrip(x), digits=1)) $(unit(x))", xc)
    yc_hover = map(x -> "$(round.(ustrip(x), digits=1)) $(unit(x))", yc)

    scatter!([ustrip(xc)], [ustrip(yc)], markercolor = :grey, markersize = 8, markerstrokewidth = 1, 
                markeralpha = 0.7, hover = "Centroid<br>xc: $(xc_hover)<br>yc: $(yc_hover)")
    vline!([ustrip(xc)],
            color = :grey)
    hline!([ustrip(yc)],
            color = :grey)
end



end