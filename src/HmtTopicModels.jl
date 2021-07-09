module HmtTopicModels
using EditionBuilders
using CitableText, CitableObject
using CitableCorpus
using EzXML
using Unicode
using CSV
using DataFrames
using HTTP
using DelimitedFiles

import EditionBuilders: editednode, editedelement, editedtext
import EditionBuilders: TEIchoice, skipelement

include("builders.jl")
include("authlists.jl")

export editednode, editedelement, editedtext
export tmclean
export skipelement, TEIchoice
export persname_df, label
export  shorturn, labelledshortform


end # module
