module Mechanical

export  bolt_centroid, circle, rectangle, plot_bolt_pattern,
        bolt_loads, plot_bolt_loads

include("BoltPattern.jl")
using .BoltPattern

include("BoltLoads.jl")
using .BoltLoads

using Plots

# change to plotly() backend for plots after pre-compilation of modules
function __init__()
    plotly()
end

end
