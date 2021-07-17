
"""Create DataFrame for personal names authority list.
"""
function persname_df()
    authurl  = "https://raw.githubusercontent.com/homermultitext/hmt-authlists/master/data/hmtnames.cex"
    CSV.File(HTTP.get(authurl).body; delim = "#", header = 2) |> DataFrame
end


"""Look up label for URN value in DataFrame of personal names.
"""
function label(urnstring::AbstractString, df)
    matched = filter( r -> r.urn == urnstring, df)
    if nrow(matched) > 1
        @warn "Multiple results for $urnstring !"
        nothing
    elseif nrow(matched) == 0
        @warn "No matches for $urnstring"
        nothing
    else        
        matched[1,:label]
	end
end

"""Look up label for URN value in DataFrame of personal names.
"""
function label(urn::Cite2Urn, df)
    label(urn.urn, df)
end

"""Use abbreviated collection/object form for URN value.
"""
function shorturn(u::Cite2Urn, delimiter="")
    collparts = split(collectioncomponent(u), ".")
    coll = collparts[1]
    string(coll, delimiter, objectcomponent(u)) |> replacedigits
end


"""Label short form URN with label from persname collection.
"""
function labelledshortform(u::Cite2Urn, df, delimiter="")
    lbl = label(u.urn, df)
    if isnothing(lbl)
        @warn "No label for URN $u found in personal names authority list."
        string(shorturn(u, delimiter), delimiter, "error")
    else
        string(shorturn(u, delimiter), delimiter, lbl)
      
    end
end

"""Map digits to one-character strings.
"""
digitmap = Dict(
    '1' => "a",
    '2' => "b",
    '3' => "c",
    '4' => "d",
    '5' => "e",
    '6' => "f",
    '7' => "g",
    '8' => "h",
    '9' => "i",
    '0' => "j"
)


"""Replace digit characters in s with alphabetic characters.

"""
function replacedigits(s)
    clist = []
    for c in s
        if c in keys(digitmap)
            push!(clist, digitmap[c])
        else
            push!(clist, c)
        end
    end
    join(clist)
end
