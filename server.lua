local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent("business_rating:addReview", function(data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local name = data.anonymous and Config.Locale.anonymous_name or (Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname)

    MySQL.insert('INSERT INTO business_ratings (business_name, player_name, rating, review, anonymous) VALUES (?, ?, ?, ?, ?)', {
        data.business,
        data.anonymous and nil or name,
        data.rating,
        data.review,
        data.anonymous
    })

end)

QBCore.Functions.CreateCallback("business_rating:getReviews", function(source, cb, business)
    MySQL.query('SELECT * FROM business_ratings WHERE business_name = ?', { business }, function(result)
        cb(result or {})
    end)
end)