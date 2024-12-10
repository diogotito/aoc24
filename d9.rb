File.read('in/09').chomp
# DATA.read.chomp
  .each_char
  .map(&:to_i)
  .each_slice(2)
  .flat_map.with_index do |(file_size, free_space), id|
    [id] * file_size + [nil] * (free_space or 0)
  end
  .instance_eval do

    def frag
      left_i  = 0
      right_i = size
      loop do
        left_i  += 1 until self[left_i].nil?
        right_i -= 1 while self[right_i].nil?
        break if left_i >= right_i
        self[left_i], self[right_i] = self[right_i], self[left_i]
      end
      checksum
    end

    def defrag
      replace slice_when { _1 != _2 }.to_a.instance_eval {
        ptr = count - 1

        loop do
          cur_size = self[ptr].size
          
          # look for a span of free space to the left of ptr
          free_ptr = (0...ptr).find do |i|
            self[i][0].nil? && self[i].size >= cur_size
          end
          if free_ptr
            free_size = self[free_ptr].size
            self[free_ptr..free_ptr] = self[ptr].dup, [nil] * (free_size - cur_size)
            self[ptr+1].fill(nil)
          else
            ptr -= 1
          end
          while ptr > 0 and self[ptr][0].nil?
            ptr -= 1
          end
          break if ptr <= 0
        end

        flatten
      }
      checksum
    end

    def checksum = each_with_index.sum { |id, pos| (id or 0) * pos }

    print "Part One: "; puts clone.frag
    print "Part Two: "; puts defrag
    puts  "         (6547228115826)"
  end

__END__
2333133121414131402
