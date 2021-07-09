
"""Create DataFrame for personal names authority list.
"""
function persname_df()
    authurl  = "https://raw.githubusercontent.com/homermultitext/hmt-authlists/master/data/hmtnames.cex"
    CSV.File(HTTP.get(authurl).body; delim = "#", header = 2) |> DataFrame
end


"""Look up label for URN value in DataFrame of personal names.
"""
function label(urnstring, df)
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