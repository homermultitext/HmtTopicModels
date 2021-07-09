@testset "Test working with persname authlist" begin
    df = persname_df()
    @test typeof(df)== DataFrames.DataFrame

    achilles = "urn:cite2:hmt:pers.v1:pers1"
    @test label(achilles, df) == "Achilles"
end



@testset "Test postprocessing raw corpus" begin
    cn = CitableNode(CtsUrn("urn:cts:dummy:tests.test1:1"), "This is a short passage of text")
    c = CitableTextCorpus([cn])
    tidied = tmclean(c, ["This"])
    expected = "short passage text"
    @test tidied.corpus[1].text == expected
end


@testset "Test abbreviated URN" begin
    achillesurn = Cite2Urn("urn:cite2:hmt:pers.v1:pers1")
    @test shorturn(achillesurn) == "pers_pers1"
    @test shorturn(achillesurn,":") == "pers:pers1"
    @test labelledshortform(achillesurn, persname_df()) == "pers_pers1_Achilles"
    @test labelledshortform(achillesurn, persname_df(),":") == "pers:pers1:Achilles"


    badurn = Cite2Urn("urn:cite2:hmt:pers.v1:OUTIS")
    @test labelledshortform(badurn, persname_df()) == "pers_OUTIS_error"

end