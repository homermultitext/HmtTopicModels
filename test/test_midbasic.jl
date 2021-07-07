@testset "Test basic TEI usage defined by MID module" begin
    tmbldr = HmtTopicModels.HmtTMBuilder("tm builder", "x")
    validnames = EditionBuilders.validElementNames(tmbldr)
    @test length(validnames) == 33
    @test validelname(tmbldr, "p")
    @test validelname(tmbldr, "watermark") == false


    choicexml = "<choice><abbr>Mr.</abbr><expan>Mister</expan></choice>"
    choicenode = EzXML.parsexml(choicexml) |> root
    @test EditionBuilders.validchoice(choicenode)

    wxml = "<w>Word<unclear>less</unclear></w>"
    wnode =  EzXML.parsexml(wxml) |> root
    @test EditionBuilders.collectw(wnode, tmbldr) == "Wordless"

    editedel = editedelement(tmbldr, wnode, "")
    @test editedel == "wordless"
    
end

@testset "Test choices" begin
    tmbldr = HmtTopicModels.HmtTMBuilder("tm builder", "x")
    choicexml = "<choice><expan>mevrouw</expan><abbr>mevr.</abbr></choice>"
    doc = parsexml(choicexml)
    @test TEIchoice(tmbldr, doc.root) == "mevrouw"
end

@testset "Test full node" begin
    tmbldr = HmtTopicModels.HmtTMBuilder("tm builder", "x")
    xml = "<l n=\"title\">θῆτα <persName n=\"urn:cite2:hmt:pers.v1:pers17\">ὁμήρου</persName> <choice><abbr>ῥαψωδ</abbr><expan>ῥαψωδίας</expan></choice></l>"
    line = parsexml(xml)
    expected = "θητα pers_pers17 ραψωδιας"
    s = editedtext(tmbldr, line.root)
    @test s == expected
end

@testset "Test corpus edition" begin    
    xml = "<l n=\"title\">θῆτα <persName n=\"urn:cite2:hmt:pers.v1:pers17\">ὁμήρου</persName> <choice><abbr>ῥαψωδ</abbr><expan>ῥαψωδίας</expan></choice></l>"
    urn = CtsUrn("urn:cts:greekLit:tlg0012.tlg001.msB:4.title")
    cn = CitableNode(urn, xml)
    corpus = CitableTextCorpus([cn])
    
    tmbldr = HmtTopicModels.HmtTMBuilder("tm builder", "msBtm")
    tmedition = edition(tmbldr, corpus)
    tmnode = tmedition.corpus[1]
    expectedwork =  "tlg0012.tlg001.msBtm"
    @test workcomponent(tmnode.urn) == expectedwork
    expectedtext = "θητα pers_pers17 ραψωδιας"
    @test tmnode.text == expectedtext
end