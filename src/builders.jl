

"Edition builderssharing to create an edition for HMT topic modelling."
struct HmtTMBuilder <: MidBasicBuilder
    name
    versionid
 end

 """True if element should b skipped in creating topic modelling edition.
 """
function skipelement(builder::HmtTMBuilder, elname)
    elname in ["del", "ref","note","q","cit"]
end


"Choose normalized option from MID-legal TEI choice."
function TEIchoice(builder::HmtTMBuilder, n)
    #= Account for:
        abbr/expan
        orig/reg
        sic/corr
    =#
    children = elements(n)
    childnames = map(n -> n.name, children)
    if "abbr" in childnames
        abbrlist = filter(n -> n.name == "expan", children)
        editedtext(builder, abbrlist[1])

    elseif "orig" in childnames
        origlist = filter(n -> n.name == "reg", children)
        editedtext(builder, origlist[1])


    elseif "sic" in childnames
        siclist = filter(n -> n.name == "corr", children)
        editedtext(builder, siclist[1])


    else
        nameslist = join(childnames, ", ")
        x = ezxmlstring(n)
        msg =  "Invalid syntax for choice element with children $(nameslist) in $(x)"
  
        throw(DomainError(msg))
    end
end


"Compose edited text of a given XML element using a given builder."
function editedelement(builder::HmtTMBuilder, el, accum)
    if ! validelname(builder, el.name)
        str = ezxmlstring(el)
        msg = "Invalid element $(el.name) in $(str)"
        throw(DomainError(msg))
    end

    reply = []
    if el.name == "foreign"
        push!(reply, "«" * el.content * "»")

    elseif el.name == "choice"
        if ! EditionBuilders.validchoice(el)
            children = elements(el)
            childnames = map(n -> n.name, children)
            badlist = join(childnames, ", ")
            msg = "Invalid children of `choice` element: $(badlist) in  $(ezxmlstring(el))"
            throw(DomainError(msg))
            
        else
            chosen = EditionBuilders.TEIchoice(builder, el)
            push!(reply, chosen)
        end

    elseif el.name == "w"
        push!(reply, EditionBuilders.collectw(el, builder))
        

    elseif el.name == "persName"
        if ! haskey(el, "n")
            msg = "Bad markup: no @n attribute in  $(ezxmlstring(el))"
            throw(DomainError(msg))
        else
            # Should we test further here?
            # For valid URN syntax? For presence in authlist?
            try 
                urn = Cite2Urn(el["n"])
                #obj = objectcomponent(urn)
                #parts = split(collectioncomponent(urn), ".")


                #push!(reply, string(parts[1], "_", obj))
                push!(reply, urn.urn)
            catch e
                msg = "Invalid URN in $(ezxmlstring(el))"
                throw(DomainError(msg))
            end
        end

    elseif skipelement(builder, el.name)
        # do nothing

    else
        children = nodes(el)
        if !(isempty(children))
            for c in children
                childres =  editedtext(builder, c, accum)
                push!(reply, childres)
            end
        end
    end
    stripped = strip(join(reply," "))
    Unicode.normalize(stripped; stripmark=true) |> lowercase
end

"""Walk parsed XML tree and compose a specific edition.
`builder` is the edition builder to use. `n` is a parsed Node. 
`accum` is the accumulation of any text already seen and collected.
"""
function editedtext(builder::HmtTMBuilder, n::EzXML.Node, accum = "")::AbstractString
	rslts = [accum]
    if n.type == EzXML.ELEMENT_NODE 
        elresults = editedelement(builder, n, accum)
        push!(rslts, elresults)

	elseif 	n.type == EzXML.TEXT_NODE
		tidier = EditionBuilders.cleanws(n.content )
		if !isempty(tidier)
			push!(rslts, accum * tidier)
		end
                
    elseif n.type == EzXML.COMMENT_NODE
        # do nothing
    else
        throw(DomainError("Unrecognized node type for node $(n.type)"))
	end
    stripped = strip(join(rslts," "))
    replace(stripped, r"[ \t]+" => " ")
end


"Builder for constructing a citable node for a diplomatic text from a citable node in archival XML."
function editednode(builder::HmtTMBuilder, citablenode::CitableNode)
    nd  = root(parsexml(citablenode.text))
    editiontext = editedtext(builder, nd)
    CitableNode(addversion(citablenode.urn, builder.versionid), editiontext)
end

"""
Postprocess reading of TM edition by dropping stopwords, applying
minimum length to tokens, and rewriting URN values.


"""
function tmclean(c::CitableTextCorpus, stopwords, thresh=3)
    pns = persname_df()
    cleannodes = []
    for cn in c.corpus
        tokens = cn.text |> split
        cleantokens = []
        for t in tokens   
            if startswith(t, "urn:cite2:hmt:pers")
                push!(cleantokens, labelledshortform(Cite2Urn(t), pns))

            else 
                nopunct = replace(t, r"[\.,:⁑'⸌‡_^]" => "") 
                if length(nopunct) < thresh
                    # skip
                elseif nopunct in stopwords
                    # skip  
                else 
                    push!(cleantokens, nopunct)
                end
            end
        end
        push!(cleannodes, CitableNode(cn.urn, join(cleantokens," ")))
    end
    CitableTextCorpus(cleannodes)
end