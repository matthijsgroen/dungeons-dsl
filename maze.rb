# Small effort to check complexity of level generation.
# This is about generating a level using a random seed,
# so reusing the seed should produce the same level over again.

seed = (ARGV[0] || Random.new_seed).to_i

puts "The world will be seeded with: #{seed}"
srand seed

# Now we have our random values adjusted to a specific seed.
# Now we need some DSL to specify something about a level...

require './there_is'

there is.a.short.road.with.a.wide.bank
there is.a.small.field.with.a.road.across.connected to.this.road
there is.a.long.road.with.a.narrow.bank.connected to.this.field
there is.a.large.rock.field.with.road.across.connected to.this.road

world.render

