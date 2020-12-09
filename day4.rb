EYE_COLORS = ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]

def read_passports
  File.read("input4.txt").split("\n\n").map do |passport_raw|
    Hash[passport_raw.split(/\s+/).map {|pair| pair.split(":")}]
  end
end

def valid_passport_a?(passport)
  required_fields = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
end

def valid_height?(hgt)
  begin
    num, unit = /^(\d+)(in|cm)$/.match(hgt).captures
    if unit === "cm"
      num.to_i.between?(150, 193)
    else # unit === "in"
      num.to_i.between?(59, 76)
    end
  rescue
    false
  end
end

def valid_passport_b?(passport)
  passport.has_key?("byr") && passport["byr"].to_i.between?(1920, 2002) &&
  passport.has_key?("iyr") && passport["iyr"].to_i.between?(2010, 2020) &&
  passport.has_key?("eyr") && passport["eyr"].to_i.between?(2020, 2030) &&
  passport.has_key?("hgt") && valid_height?(passport["hgt"]) &&
  passport.has_key?("hcl") && /^\#[0-9a-f]{6}$/.match?(passport["hcl"]) &&
  passport.has_key?("ecl") && EYE_COLORS.include?(passport["ecl"]) &&
  passport.has_key?("pid") && /^\d{9}$/.match?(passport["pid"])
end

def day4a
  read_passports.count {|p| valid_passport_a?(p)}
end

def day4b
  valid = read_passports.count {|p| valid_passport_b?(p)}
end

p day4b