module Mechanical

export  bolt_centroid, circle, rectangle, plot_bolt_pattern,
        bolt_loads, plot_bolt_loads

include("BoltPattern.jl")
using .BoltPattern

include("BoltLoads.jl")
using .BoltLoads

using Plots


end
