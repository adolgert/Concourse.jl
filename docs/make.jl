using Documenter
using Concourse
using QueueDiagrams

DocMeta.setdocmeta!(Concourse, :DocTestSetup, :(using Concourse); recursive=true)

makedocs(
    sitename = "Concourse.jl",
    modules = [Concourse],
    format = Documenter.HTML(
        prettyurls = get(ENV, "CI", nothing) == "true",
        canonical = "https://computingkitchen.com/Concourse.jl",
        edit_link = "main",
        assets = String[],
    ),
    pages = [
        "Home" => "index.md",
        "Queues" => [
            "queues/jobs_servers.md",
            "queues/arrivals.md",
            "queues/disciplines.md",
            "queues/kendall_mm1.md",
            "queues/mg1.md",
            "queues/networks.md",
            "queues/marks.md",
            "queues/richer_stations.md",
            "queues/measuring.md",
        ],
        "Manual" => [
            "manual/record_replay.md",
            "manual/branching.md",
            "manual/gradients.md",
            "manual/statistics.md",
            "manual/samplers.md",
            "manual/checking.md",
            "manual/state_dependent.md",
            "manual/batching.md",
            "manual/closed_networks.md",
            "manual/bcmp_hpc.md",
        ],
        "Reference" => [
            "reference/surface.md",
            "reference/expressions.md",
            "reference/ir.md",
            "reference/interpreter.md",
            "reference/gradients_worlds.md",
        ],
        "Developer" => [
            "developer/architecture.md",
            "developer/model_contract.md",
            "developer/event_loop.md",
            "developer/design_questions.md",
            "developer/spa.md",
            "developer/bibliography.md",
        ],
    ],
    warnonly = [:missing_docs],
    checkdocs = :exports,
)

deploydocs(
    repo = "github.com/adolgert/Concourse.jl.git",
    devbranch = "main",
    push_preview = false,
)
