require 'byebug'
def main
  data = File.read("data/day5.txt").chars
  data.pop
 
  pointer = 0

  while pointer < data.length && pointer > -1
    while kill?(data[pointer], data[pointer + 1])
      data.delete_at(pointer)
      data.delete_at(pointer)
      pointer -= 1 if pointer > 0
    end
    pointer += 1
  end

  puts data.length
end

def kill?(first, second)
  first.casecmp(second) == 0 && first != second 
end

main
