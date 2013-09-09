# Small effort to check complexity of level generation.
# This is about generating a level using a random seed,
# so reusing the seed should produce the same level over again.

seed = (ARGV[0] || Random.new_seed).to_i

puts "The world will be seeded with: #{seed}"
srand seed

# Now we have our random values adjusted to a specific seed.
# Now we need some DSL to specify something about a level...

require './world'

#World.create('start area') do
  #there is.a.small.field
  #there is.a.short.road.with.a.narrow.bank.connected.to the.field
  #there are.rocks.at the.side.of.the.road

  #there is.a.field.connected.to the.road
  ## describe encounter / link to encounter:
  ## This could be an entirely different DSL, based on creatures.
  ## the same can be said for Loot.
  ##
  ## there is.a.crew_survivor.at.the.entrance.of the.field
  ##
  ## there are.two.creatures.killing the.crew_survivor
  ##
#end.render

World.create('outside') do
  there is.a.road.with.rocks.and.trees.in.a.wide.bank
  there is.a.lightpost.at.the.side.of the.road

  there is.a.field.with.trees.and.a.forked.road.across.connected.to the.road

  there is.a.road.with.a.narrow.bank.connected.to the.last.road.of.the.field
  there is.a.field.with.rocks.connected.to the.road

  there is.a.long.road.with.rocks.in.a.wide.bank.connected.to the.first.road.of.the.first.field
  there are.several.lightposts.at.the.side.of the.road

  there is.a.large.field.with.trees.connected.to the.road
end.render

