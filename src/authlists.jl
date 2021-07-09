

function persname_df()
    authurl  = "https://raw.githubusercontent.com/homermultitext/hmt-authlists/master/data/hmtnames.cex"
    authdf = CSV.File(HTTP.get(authurl).body; delim = "#", header = 2) |> DataFrame
end
