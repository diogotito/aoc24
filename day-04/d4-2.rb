soup = IO.foreach('../in/04', chomp: true).map(&:chars)
SIZE = soup.size
positions = (1..SIZE-2).flat_map { |r| (1..SIZE-2).map { |c| [r, c] } }

X = [[[-1,-1],[0,0],[1,1]], [[1,-1],[0,0],[-1,1]]]
MAS = %w[MAS SAM]

puts positions.count { |r, c|
  X.all? { |arm| MAS.include? arm.map { |dy, dx| soup[r + dy][c + dx] }.join }
}

