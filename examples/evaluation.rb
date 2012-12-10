require_relative '../lib/lsh'

index = LSH::Index.new(10, 8, Float::INFINITY, 50)

# Test dataset
vectors = []
100.times { |i| vectors << index.random_vector(10) } 

# Adding to index
vectors.each { |v| index.add(v) }

# Nearest neighbors in query result?
scores = []
sizes = []
vectors.each_with_index do |vector, i|
  results = index.query(vector)
  sizes << results.size
  $stderr.puts "#{results.count} results for vector #{i}"
  similarities = vectors.map { |v| vector * v.col }
  similarities.sort!.reverse!
  k = 0
  results_similarities = results.map { |r| r * vector.col }
  while k < results.size and results_similarities[k] == similarities[k]
    k += 1
  end
  $stderr.puts "Nearest neighbours up to #{k} appear in results"
  scores << k
end

avg_size = 0.0
sizes.each { |s| avg_size += s }
avg_size /= sizes.size
$stderr.puts "Average number of results: #{avg_size}"

p = 0.0
scores.each { |s| p += 1 if s > 1 }
p /= scores.size.to_f
$stderr.puts "Probability of nearest neighbour (not self) being in results: #{p}"

nn = 0.0
scores.each { |s| nn += s }
nn /= scores.size.to_f
$stderr.puts "Average number of nearest neighbours in results: #{nn}"
