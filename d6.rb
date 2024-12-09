require 'matrix'

class Vector
  def set!(value) = self[0...] = value
end

class Guy < Vector
  def initialize(map)
    @map = map
    super.__send__(:initialize, @map.find_index('^'))
    @dir = Vector[-1, 0]
    def @dir.rotate! = set! cross.cross.cross
  end

  def ahead         = self + $dir
  def advance!      = set! ahead
  def read          = @map[*self]
  def mark(val='X') = @map[*self] = val
  def hitting_wall? = read == "#"
  def in_bounds?    = (0...@map.column_size).include?(component 0) && (0...@map.column_count).include?(component 1)
end

map = Matrix[*IO.foreach("input/06", chomp: true).map(&:chars)]
guy = Guy.__send__(:new, map)



while guy.in_bounds? do
  guy.mark
  $dir.rotate! if guy.ahead.hitting_wall?
  guy.advance!
end

puts map.to_a.map(&:join).join("\n")
