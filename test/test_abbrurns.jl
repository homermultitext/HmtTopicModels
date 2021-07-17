

@testset "Test abbreviated URN" begin
    achillesurn = Cite2Urn("urn:cite2:hmt:pers.v1:pers1")
    @test shorturn(achillesurn) == "perspers1"
    @test shorturn(achillesurn,":") == "pers:pers1"
    @test labelledshortform(achillesurn, persname_df()) == "perspers1Achilles"
    @test labelledshortform(achillesurn, persname_df(),":") == "pers:pers1:Achilles"


    badurn = Cite2Urn("urn:cite2:hmt:pers.v1:OUTIS")
    @test labelledshortform(badurn, persname_df()) == "persOUTISerror"
end


@testset "Test obfuscating digits" begin
    n = "pers123"
    @test HmtTopicModels.replacedigits(n) == "persabc"
end