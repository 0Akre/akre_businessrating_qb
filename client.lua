local QBCore = exports['qb-core']:GetCoreObject()

if not lib then
    lib = exports.ox_lib
end

local businesses = Config.Businesses

local function CreateBusinessNPC(business)
    RequestModel(business.model)
    while not HasModelLoaded(business.model) do Wait(10) end

    local ped = CreatePed(4, business.model, business.npcCoords.x, business.npcCoords.y, business.npcCoords.z - 1.0, business.npcCoords.w, false, true)
    SetEntityInvincible(ped, true)
    FreezeEntityPosition(ped, true)
    TaskStartScenarioInPlace(ped, business.scenario, 0, true)
    SetBlockingOfNonTemporaryEvents(ped, true)

    exports.ox_target:addBoxZone({
        coords = business.npcCoords.xyz,
        size = vec3(1, 1, 2),
        options = {
            {
                name = "business_rating_" .. business.name:gsub("%s+", "_"),
                event = "business_rating:openMenu",
                icon = "fas fa-star",
                label = Config.Locale.target_label,
                businessName = business.name
            }
        },
        distance = 2.0
    })
end

CreateThread(function()
    for _, business in pairs(businesses) do
        CreateBusinessNPC(business)
    end
end)

RegisterNetEvent("business_rating:openMenu", function(data, target)
    local businessName = nil
    if data and data.businessName then
        businessName = data.businessName
    elseif target and target.options and target.options.businessName then
        businessName = target.options.businessName
    else
        businessName = Config.Locale.unknown_business
    end
    
    local options = {
        {
            title = Config.Locale.show_rating,
            description = Config.Locale.show_rating_description,
            args = { business = businessName },
            event = "business_rating:showReviews"
        },
        {
            title = Config.Locale.add_rating,
            description = Config.Locale.add_rating_description,
            args = { business = businessName },
            event = "business_rating:addReview"
        }
    }
    
    lib.registerContext({ 
        id = "business_rating_menu", 
        title = businessName, 
        options = options 
    })
    lib.showContext("business_rating_menu")
end)

RegisterNetEvent("business_rating:addReview", function(data)
    local businessName = data.business
    
    local input = lib.inputDialog(Config.Locale.create_rating .. businessName, {
        { type = "select", label = Config.Locale.rating_title, options = {
            { value = 1, label = "⭐" }, { value = 2, label = "⭐⭐" },
            { value = 3, label = "⭐⭐⭐" }, { value = 4, label = "⭐⭐⭐⭐" },
            { value = 5, label = "⭐⭐⭐⭐⭐" }
        }},
        { type = "input", label = Config.Locale.review_title, placeholder = Config.Locale.review_placeholder, max = 255 },
        { type = "checkbox", label = Config.Locale.add_anonymously }
    })

    if not input then return end

    TriggerServerEvent("business_rating:addReview", {
        business = businessName,
        rating = input[1],
        review = input[2],
        anonymous = input[3]
    })

    TriggerEvent("QBCore:Notify", Config.Locale.review_added, "success")
end)

RegisterNetEvent("business_rating:showReviews", function(data)
    local businessName = data.business
    
    QBCore.Functions.TriggerCallback("business_rating:getReviews", function(reviews)
        if not reviews or #reviews == 0 then
            return TriggerEvent("QBCore:Notify", Config.Locale.no_review_yet, "error")
        end

        local reviewList = {}
        local totalRating, count = 0, 0
        for _, review in pairs(reviews) do
            totalRating = totalRating + review.rating
            count = count + 1
            table.insert(reviewList, {
                title = review.player_name or Config.Locale.anonymous_name,
                description = string.format("%s\n%s", string.rep("⭐", review.rating), review.review)
            })
        end

        local avgRating = count > 0 and (totalRating / count) or 0
        table.insert(reviewList, 1, { title = Config.Locale.avarage_rating, description = string.format("%.1f ⭐", avgRating) })

        lib.registerContext({ 
            id = "business_reviews", 
            title = businessName, 
            options = reviewList 
        })
        lib.showContext("business_reviews")
    end, businessName)
end)