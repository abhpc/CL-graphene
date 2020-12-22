from ovito.io import import_file
from ovito.modifiers import PolyhedralTemplateMatchingModifier,\
    SelectTypeModifier, DeleteSelectedModifier, ExpressionSelectionModifier, \
    ClusterAnalysisModifier
import sys

if (len(sys.argv) < 5):
    print("Usage: ovitos linecut.py [filename] [Direction=X,Y,Z] [Amin] ][Amax]")
    sys.exit(1)

filename = sys.argv[1]
direction = sys.argv[2]
Amin = float(sys.argv[3])
Amax = float(sys.argv[4])

pipeline = import_file(filename)

ptm = PolyhedralTemplateMatchingModifier()

ptm.structures[PolyhedralTemplateMatchingModifier.Type.GRAPHENE].enabled = True

pipeline.modifiers.append(ptm)

pipeline.modifiers.append(SelectTypeModifier(
    operate_on="particles",
    property="Structure Type",
    types={PolyhedralTemplateMatchingModifier.Type.GRAPHENE, }
))

pipeline.modifiers.append(DeleteSelectedModifier())

all_n = 10
width = 5

start_position = 0
pipeline.modifiers.append(ExpressionSelectionModifier(
    expression="{Amin} < Position.{direction} && Position.{direction} < {Amax}".format(
        Amin=Amin, direction=direction.upper(), Amax=Amax
    )
))

pipeline.modifiers.append(ClusterAnalysisModifier(
    cutoff=3,
    only_selected=True,
))

data = pipeline.compute()
number = data.attributes['ClusterAnalysis.cluster_count']
print(number)
