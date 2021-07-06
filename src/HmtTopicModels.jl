module HmtTopicModels
using EditionBuilders
using CitableText
using CitableCorpus
using EzXML

import EditionBuilders: editedelement, editedtext
import EditionBuilders: TEIchoice, skipelement

include("builders.jl")

export editedelement, editedtext
export skipelement, TEIchoice


end # module
