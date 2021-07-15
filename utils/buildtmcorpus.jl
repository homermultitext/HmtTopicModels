using HmtTopicModels
using EditionBuilders
using CitableCorpus
using CSV
using HTTP
using DelimitedFiles

# Build basic Topic Modelling edition:
tmbldr = HmtTopicModels.HmtTMBuilder("tm builder", "hmttm")
xmlurl = "https://raw.githubusercontent.com/hmteditors/composite-summer21/main/data/archive-xml.cex"
xmlcorpus = CitableCorpus.fromurl(CitableTextCorpus, xmlurl, "|")
scholia = filter(cn -> endswith(cn.urn.urn, "comment"), xmlcorpus.corpus) |> CitableTextCorpus
tmedition = edition(tmbldr, scholia)
# Postprocess:
stopsurl = "https://raw.githubusercontent.com/HCMID/scholia-transmission/main/data/stops.txt"
#stops = CSV.File(HTTP.get(stopsurl).body)
stops = readdlm("test/data/stops.txt")
tmcleanedition = HmtTopicModels.tmclean(tmedition, stops)


tmfile = "topicmodelingedition.cex"
open(tmfile,"w") do io
    write(io, cex(tmcleanedition))
end