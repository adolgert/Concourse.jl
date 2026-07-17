# Thinned-Poisson splits give each branch an exact M/M/1 closed form while
# exercising the A4 draw machinery: recorded marks for ByMark, recorded
# uniforms for Probabilistic.

wanted("sita mark split thins arrivals into an exact mm1 branch") &&
@testset "sita mark split thins arrivals into an exact mm1 branch" begin
    m = sita_split()
    θ = [1.0, 2.0, 2.0]
    p_short = 1 - exp(-2.0)              # P(size < 2), size ~ Exp(1)
    ρs = θ[1] * p_short / θ[2]
    ρl = θ[1] * (1 - p_short) / θ[3]
    short = m.names[:short]; long = m.names[:long]
    at(q) = st -> Float64(length(st.buf[q]) + length(st.srv[q]))
    es, ses = replicate(r -> time_average(at(short), m, r), m, θ, 2000.0, 16)
    el, sel = replicate(r -> time_average(at(long), m, r), m, θ, 2000.0, 16; seed0=5000)
    @test within4se(es, ses, ρs / (1 - ρs))
    @test within4se(el, sel, ρl / (1 - ρl))
end

wanted("probabilistic routing thins arrivals by the recorded choice") &&
@testset "probabilistic routing thins arrivals by the recorded choice" begin
    m = bernoulli_split()
    θ = [1.0, 2.0]
    ρa = 0.3 * θ[1] / θ[2]
    a = m.names[:a]
    at(q) = st -> Float64(length(st.buf[q]) + length(st.srv[q]))
    est, se = replicate(r -> time_average(at(a), m, r), m, θ, 2000.0, 16)
    @test within4se(est, se, ρa / (1 - ρa))
end

wanted("f3 no opaque escapes are needed for the phase-1 models") &&
@testset "f3 no opaque escapes are needed for the phase-1 models" begin
    for m in (mm1(), sita_split(), bernoulli_split(), preemptive_priority(),
              blocking_tandem())
        for stn in m.stations
            stn.service === nothing || @test !Concourse.isopaque(stn.service)
            if stn.mark !== nothing
                for (_, law) in stn.mark.laws
                    @test !Concourse.isopaque(law)
                end
            end
        end
    end
end
