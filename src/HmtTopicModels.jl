module HmtTopicModels
using EditionBuilders
using CitableText, CitableObject
using CitableCorpus
using EzXML
using Unicode

import EditionBuilders: editednode, editedelement, editedtext
import EditionBuilders: TEIchoice, skipelement

include("builders.jl")

export editednode, editedelement, editedtext
export tmclean
export skipelement, TEIchoice


end # module
