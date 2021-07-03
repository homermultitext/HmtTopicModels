@testset "Test usage of MID element names" begin
    tmbldr = HmtTopicModels.HmtTMBuilder("tm builder", "x")
    validnames = EditionBuilders.validElementNames(tmbldr)
    @test length(validnames) == 33
end