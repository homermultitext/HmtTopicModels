module HmtTopicModels
using EditionBuilders
using CitableText
using CitableCorpus
using EzXML
using Unicode

import EditionBuilders: editednode, editedelement, editedtext
import EditionBuilders: TEIchoice, skipelement

include("builders.jl")

export editednode, editedelement, editedtext
export skipelement, TEIchoice


end # module
