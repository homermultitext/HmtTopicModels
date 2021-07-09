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

@testset "Test use of stopword list" begin
    stops = readdlm("data/stops.txt")
    u = CtsUrn("urn:cts:greekLit:tlg5026.msB.v1:4.51r_5")
    txt = "<p>πιθανῶς ἐκ τοῦ κάτωθεν θορύβου, ἐις 
    <choice><abbr>ὀυνὸν</abbr><expan>οὐρανὸν</expan></choice>
   τὴν σκηνὴν μετήγαγεν: σεμνύνων καὶ ποικίλλων ἅμα τὴν ποίησιν,
   τόποις τὲ καὶ προσώποις καὶ λόγοις: ὑπονοεῖν δε δεῖ παρὰ τὴν
   ἁρπαγὴν ἀλεξάνδρου τοὺς λογους γεγενῆσθαι τοῖς θεοῖς:  ηὔξησε δὲ 
   τὸ ἀγωνιστικὸν τῆς ὑποθέσεως τῇ τῶν θεῶν προνοίᾳ ⁑ </p>"

   cn = CitableNode(u,txt)
   c = CitableTextCorpus([cn])
   tmbldr = HmtTopicModels.HmtTMBuilder("tm builder", "x")
   ed = edition(tmbldr,c)
   tmed = tmclean(ed, stops)
   println(tmed.corpus[1].text)
end