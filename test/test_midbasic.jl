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
    s = editedtext(tmbldr, line.root)
    println(s)

end