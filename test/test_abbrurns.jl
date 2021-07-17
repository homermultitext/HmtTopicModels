

@testset "Test abbreviated URN" begin
    achillesurn = Cite2Urn("urn:cite2:hmt:pers.v1:pers1")
    @test shorturn(achillesurn) == "perspersa"
    @test shorturn(achillesurn,":") == "pers:persa"
    @test labelledshortform(achillesurn, persname_df()) == "perspersaAchilles"
    @test labelledshortform(achillesurn, persname_df(),":") == "pers:persa:Achilles"


    badurn = Cite2Urn("urn:cite2:hmt:pers.v1:OUTIS")
    @test labelledshortform(badurn, persname_df()) == "persOUTISerror"
end


@testset "Test obfuscating digits" begin
    n = "pers123"
    @test HmtTopicModels.replacedigits(n) == "persabc"
end