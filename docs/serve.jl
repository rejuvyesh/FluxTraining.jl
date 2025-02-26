using Pkg
using Pollen

using FluxTraining
const PACKAGE = FluxTraining

LAZY = get(ENV, "POLLEN_LAZY", "false") == "true"

# Create Project
m = PACKAGE
ms = [m, m.Events, m.Phases, m.Loggables]


@info "Creating project..."
project = Project(
    Pollen.Rewriter[
        Pollen.DocumentFolder(pkgdir(m), prefix = "documents"),
        Pollen.ParseCode(),
        Pollen.ExecuteCode(),
        Pollen.PackageDocumentation(ms),
        Pollen.DocumentGraph(),
        Pollen.SearchIndex(),
        Pollen.SaveAttributes((:title,)),
        Pollen.LoadFrontendConfig(pkgdir(m))
    ],
)


DIR = mktempdir()
@info "Serving from directory $DIR"
Pollen.serve(project, DIR, lazy=LAZY, format = Pollen.JSON())
