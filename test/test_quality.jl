# Static quality gates: Aqua's package hygiene checks and JET's
# whole-package type-error analysis.
using Aqua
using JET

wanted("quality aqua package hygiene") &&
@testset "quality aqua package hygiene" begin
    Aqua.test_all(Concourse)
end

wanted("quality jet finds no type errors") &&
@testset "quality jet finds no type errors" begin
    JET.test_package(Concourse; target_modules = (Concourse,))
end
