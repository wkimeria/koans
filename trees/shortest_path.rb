# Representation of a city. The neighbors are all the nearby directly accessible
# cities along with their respective distances
# neighbors is a hashmap, with the key being the city and the value being the
# distance from this city
class City
  attr_accessor :name, :neighbors

  def initialize(name, neighbors = {})
    @name = name
    @neighbors = neighbors
  end

  def to_s
    @name
  end
end

# see shortest_path.jpg in this directory to see
# a visual representation of the graph of cities
a = City.new("a")
b = City.new("b")
c = City.new("c")
d = City.new("d")
e = City.new("e")
f = City.new("f")
g = City.new("g")
h = City.new("h")
i = City.new("i")


a.neighbors[b] = 40
a.neighbors[c] = 50
a.neighbors[f] = 60

b.neighbors[a] = 40
b.neighbors[c] = 60
b.neighbors[e] = 80
b.neighbors[g] = 200

c.neighbors[a] = 50
c.neighbors[b] = 60
c.neighbors[d] = 70
c.neighbors[f] = 50


d.neighbors[c] = 70
d.neighbors[f] = 10
d.neighbors[h] = 40
d.neighbors[g] = 70
d.neighbors[e] = 80

e.neighbors[b] = 80
e.neighbors[d] = 80
e.neighbors[g] = 70

f.neighbors[a] = 60
f.neighbors[c] = 50
f.neighbors[i] = 60
f.neighbors[h] = 60
f.neighbors[d] = 10

g.neighbors[e] = 70
g.neighbors[d] = 70
g.neighbors[h] = 50
g.neighbors[b] = 200

i.neighbors[f] = 60


# Get all paths between the frontier (the current city we are on)
# and the destination city
def get_paths(destination_city, paths, frontier)
  current_paths = {}
  candidate_paths = {}
  frontier.neighbors.each do |n|
    city = n[0]
    distance = n[1]
    paths.each do |k, v|
      if k.last == frontier && !k.include?(city)
        candidate_paths[k.clone << city] = v + distance
        if destination_city == city
          current_paths = candidate_paths
          next
        else
          current_paths = current_paths.merge(get_paths(destination_city, candidate_paths, city))
        end
      end
    end
  end
  
  current_paths
end

# find all paths between the start city and the destination city and sort them by total
# distance ascending. If only_shortest = true return the shortest path only
def find_paths(start_city, destination_city, only_shortest = false)
  paths = {[start_city] => 0}
  paths = get_paths(destination_city, paths, start_city)
  all_paths = {}
  paths.each do |k, v|
    if k.first == start_city && k.last == destination_city
      all_paths[v] = k
    end
  end
  sorted_paths = all_paths.sort
  if only_shortest
    sorted_paths.first
  else
    sorted_paths
  end
end
start_city = a
destination_city = g
find_paths(start_city, destination_city).each do |p|
  puts p.inspect
end

puts "-----------------------------------------"

puts find_paths(start_city, destination_city, true).inspect

=begin  
Output
[140, [a, f, d, g]]
[180, [a, c, f, d, g]]
[190, [a, c, d, g]]
[220, [a, f, d, e, g]]
[240, [a, b, g]]
[250, [a, f, c, d, g]]
[260, [a, c, f, d, e, g]]
[270, [a, c, d, e, g]]
[310, [a, c, b, g]]
[330, [a, f, c, d, e, g]]
[370, [a, f, c, b, g]]
-----------------------------------------
[140, [a, f, d, g]]
=end
