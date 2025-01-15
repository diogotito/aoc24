soup = IO.foreach('../in/04', chomp: true).map(&:chars)

SIZE = soup.size

straight = (0..SIZE).map { |r| (0..SIZE).map { |c| [r, c] } }
half_diag = (0..SIZE).map { |r| (0..r).map { |c| [r-c, c] } }

class Array
  def transform_pos(&b) = map { _1.map &b }
  def reversed = map &:reverse
  def transposed = transform_pos &:reverse
  def mirrored = transform_pos { |r, c| [SIZE - r, SIZE - c] }
end

diagonal = half_diag + half_diag.mirrored[...-1].reverse
positions = straight + straight.reversed +
  straight.transposed + straight.transposed.reversed +
  diagonal + diagonal.reversed +
  diagonal.transposed + diagonal.transposed.reversed

huuuge_string = positions.transform_pos { soup.dig(*_1) }.map(&:join).join(' ')
puts huuuge_string.length
puts huuuge_string.each_char.each_cons(4).map(&:join).count "XMAS"
