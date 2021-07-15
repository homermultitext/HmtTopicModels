using HmtTopicModels
using EditionBuilders
using CitableCorpus

#normedurl = url = "https://raw.githubusercontent.com/hmteditors/composite-summer21/main/data/archive-normed.cex"
#normedcorpus = CitableCorpus.fromurl(CitableTextCorpus, normedurl, "|")
#normedcorpus.corpus |> length

tmbldr = HmtTopicModels.HmtTMBuilder("tm builder", "hmttm")
xmlurl = "https://raw.githubusercontent.com/hmteditors/composite-summer21/main/data/archive-xml.cex"
xmlcorpus = CitableCorpus.fromurl(CitableTextCorpus, xmlurl, "|")


#using HTTP
#raw = String(HTTP.get(xmlurl).body)
#occursin("<persName>", raw)
tmedition = edition(tmbldr, xmlcorpus)


#tmcex = cex(tmedition)
tmfile = "topicmodelingedition.cex"
open(tmfile,"w") do io
    write(io, cex(tmedition))
end