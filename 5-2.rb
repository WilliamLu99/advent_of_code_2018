require 'byebug'
def main
  raw = File.read("data/day5.txt").chars
  raw.pop
  data = raw

  alphabet = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]

  min_length = 9999999999

  alphabet.each do |character|
    data = Marshal.load(Marshal.dump(raw))
    data.delete character
    data.delete character.upcase
    data = collapse(data) 
    if min_length > data.length
      min_length = data.length 
      puts min_length
    end
  end

  puts min_length
end


def collapse(data)
  pointer = 0

  while pointer < data.length && pointer > -1
    while kill?(data[pointer], data[pointer + 1])
      data.delete_at(pointer)
      data.delete_at(pointer)
      pointer -= 1 if pointer > 0
    end
    pointer += 1
  end

  data
end

def kill?(first, second)
  first.casecmp(second) == 0 && first != second 
end

main
