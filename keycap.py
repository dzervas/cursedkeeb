from build123d import *
from ocp_vscode import *

thickness = 1.5
walls = 2.0

# Stem
stem_height = 3.6
stem_width = 3.8
stem_spacing = 14.5 # internal space from stem to stem in 1U keys

# Stem stepdown to catch keycap
stem_slim_width = 3.0
stem_slim_height = 0.8

keycap_gap = 1
single = stem_spacing + stem_width

with BuildPart() as bp:
    keycap = Box(single, single, thickness)
    with Locations(Vector(0, 0, -(stem_height + thickness)/2)):
        Box(stem_width+walls, stem_width+walls, stem_height)
        Box(stem_width, stem_width, stem_height, mode=Mode.SUBTRACT)

    chamfer(keycap.edges().group_by()[-1], thickness/2)

show(bp, axes=True, axes0=True, grid=(True, True, True), transparent=True)
export_stl(bp.part, "keycap.stl")
