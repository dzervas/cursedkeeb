from build123d import *
from ocp_vscode import *

from itertools import count

thickness = 1.5
walls = 2.0
tolerance = 0.11

# Stem
stem_height = 3.0
stem_width = 3.8
stem_spacing = 14.5 # internal space from stem to stem in 1U keys

# Stem stepdown to catch keycap
stem_slim_width = 3.0
stem_slim_height = 0.8

keycap_gap = 1.5
single = stem_spacing + stem_width - keycap_gap

for index, unit in zip(count(), [1.0, 1.25, 1.5, 1.75, 2.25, 2]):
    with BuildPart() as bp:
        keycap = Box(single*unit, single, thickness)
        with Locations(Vector(0, 0, -(stem_height + thickness)/2)):
            Box(stem_width+(walls+tolerance)*2, stem_width+(walls+tolerance)*2, stem_height)
            Box(stem_width+tolerance*2, stem_width+tolerance*2, stem_height, mode=Mode.SUBTRACT)

        chamfer(keycap.edges().group_by()[-1], thickness/2)
        export_stl(bp.part, f"keycap_{unit}U.stl")

        keycap.translate(Vector(0, 2*single*index, 0))

    show(bp, axes=True, axes0=True, grid=(True, True, True), transparent=True)
