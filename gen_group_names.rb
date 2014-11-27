nouns = ["Flower", "Football", "Computer", "Book", "Phone", "Fork", "Spoon", "Pasta", "Parrot", "Dog", "Barnacle", "Food", "Theory", "Law", "Problem", "Power", "Nature", "Story", "Oven", "Safety", "Language", "Exam", "Army", "Camera", "Freedom", "Paper", "Truth", "Article", "Fish", "Night", "Nation", "Road", "Soup", "Office", "Elderly", "Young", "Middle-aged", "Secretary"] 

adjectives = ["Arranging", "Jumping", "Licking", "Potting", "Shooting", "Drinking", "Eating", "Fighting", "Running", "Lifting", "Avoiding", "Growing", "Ogling", "Loving", "Relishing", "Gurning", "Pruning", "Mating", "Writing", "Reading", "Leading", "Driving"]

titles = ["Society", "Association", "Community", "Company", "Club", "Sect", "Alliance", "Affiliation", "Bunch", "Band", "Confederation", "Congress", "Cooperative", "Ring", "Troupe", "Outfit", "Federation", "Union", "Clique", "Circle", "Syndicate", "Fraternity", "Confederacy", "Family", "Crew"]

def generateGroupName(nouns, adjectives, titles)
    noun  = nouns.sample
    adj   = adjectives.sample
    title = titles.sample
    return noun + " " + adj + " " + title
end

names = []

50.times do 
    names.push(generateGroupName(nouns, adjectives, titles))
end

print names.join('|')
