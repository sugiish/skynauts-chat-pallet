ABILITIES = %w[技術 感覚 教養 身体]
ACTION_REQUIREMENTS = {
  '砲撃' => %w[技術 感覚],
  '修理' => %w[技術 教養],
  '操舵' => %w[感覚 教養],
  '侵入' => %w[身体 技術],
  '白兵' => %w[身体 技術],
  '偵察' => %w[身体 感覚],
  '大揺れ' => %w[身体 感覚],
  '消火' => %w[身体 教養],
}

def print_chat_pallets(strong_point, weak_point)
  ABILITIES.each do |ability|
    puts convert_chat_pallet(ability, ability == strong_point, ability == weak_point)
  end
  ABILITIES.combination(2).each do |ability_tuple|
    puts convert_chat_pallet(ability_tuple.join('・'), ability_tuple.include?(strong_point), ability_tuple.include?(weak_point))
  end
  ACTION_REQUIREMENTS.each do |action, requirements|
    puts convert_chat_pallet(action, requirements.include?(strong_point), requirements.include?(weak_point))
  end
end

def convert_chat_pallet(label, strong, weak)
  case
  when strong && weak
    "3d6kh2>=? 【#{label}+-】"
  when strong
    "3d6kh2>=? 【#{label}+】"
  when weak
    "2d6>=? 【#{label}-】"
  else
    "2d6>=? 【#{label}】"
  end
end

if ARGV.empty?
  puts '「歯車の塔の探空士」用のチャットパレット生成器です。'
  puts '第一引数に得意な能力、第二引数に苦手な能力を指定するとチャットパレットを出力します。'
  puts
  puts '利用例'
  puts '$ ruby chat_pallet.rb 技術 感覚'
  exit 0
end

print_chat_pallets(ARGV[0], ARGV[1])
