Config = {}

Config.Locale = {
    target_label = 'Rate the business',
    unknown_business = 'Unknown Business',
    show_rating = 'Show Rating',
    show_rating_description = 'Check out the reviews of this business',
    add_rating = 'Add Rating',
    add_rating_description = 'Add your opinion and rating',
    create_rating = 'Create Rating for - ',
    rating_title = 'Rating',
    review_title = 'Review',
    review_placeholder = 'Write your opinion...',
    add_anonymously = 'Add anonymously?',
    anonymous_name = 'Anonymous review',
    avarage_rating = '📊 Average rating',

    -- Notify -->
    review_added = 'Review successfully added!',
    no_review_yet = 'No reviews yet for this business ',

}

Config.Businesses = {
    {
        name = "Los Santos Police Dept.",
        npcCoords = vec4(433.14, -985.86, 30.71, 40.2),
        model = `a_m_m_business_01`,
        scenario = "WORLD_HUMAN_CLIPBOARD"
    },
    {
        name = "Vanilla Unicorn",
        npcCoords = vec4(133.72, -1299.91, 29.23, 218.07),
        model = `a_m_y_business_02`,
        scenario = "WORLD_HUMAN_STAND_MOBILE"
    },
    {
        name = "UwU Cofee",
        npcCoords = vec4(-581.2, -1074.92, 22.33, 281.73),
        model = `a_f_y_business_01`, 
        scenario = "WORLD_HUMAN_STAND_IMPATIENT"
    },
}