File.foreach("input/05", chomp: true)
  .chunk { _1.empty? && :_separator }
  .map { _2 } => precedences, updates

precedences.map! { _1.split(?|).map &:to_i }
updates.collect! { _1.split(?,).map &:to_i }

class Array def mid = at size/2 end

