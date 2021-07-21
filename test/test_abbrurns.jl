

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

@testset "Test full exanpsion of labelled ids" begin
    #urn = CtsUrn("urn:cts:greekLit:tlg5026.msAim.hmt:14.H6.comment")
    #txt = """<div n="comment"> <p><persName n="urn:cite2:hmt:pers.v1:pers15"><choice> <abbr>Ζηνοδ</abbr> <expan>Ζηνόδοτος</expan> </choice></persName> καὶ <persName n="urn:cite2:hmt:pers.v1:pers21"><choice> <abbr>Ἀριστοφ</abbr> <expan>Ἀριστοφάνης</expan> </choice></persName> <q>μετόπισθε</q> ⁑</p> </div>"""
    #cn = CitableNode(urn, txt)

    ptol = Cite2Urn("urn:cite2:hmt:pers.v1:pers485")
    @test labelledshortform(ptol, persname_df()) == "perspersdhePtolemyofAscalon"
end