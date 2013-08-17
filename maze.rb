# Small effort to check complexity of level generation.
# This is about generating a level using a random seed,
# so reusing the seed should produce the same level over again.

seed = (ARGV[0] || Random.new_seed).to_i

puts "The world will be seeded with: #{seed}"
srand seed

# Now we have our random values adjusted to a specific seed.
# Now we need some DSL to specify something about a level...

require './there_is'

#area1 = area <<-AREA
  #Given there is a road
  #And the player stands at the beginning of the road
  #And the road is surrounded by some bushes and trees
  #And at the end of the road, there is a large field.
  #And a connected road leads through this field
  #AREA
#area1.show

there is.a.road.with.a.bank

world.render

