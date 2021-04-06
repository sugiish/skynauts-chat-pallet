require 'optparse'

ABILITIES = %w[身体 技術 感覚 教養]

Action = Struct.new(:label, :requirements, :difficulty)
ACTIONS = [
  Action.new('砲撃', %w[技術 感覚], 7),
  Action.new('修理', %w[技術 教養], 7),
  Action.new('操舵', %w[感覚 教養], '?'),
  Action.new('侵入', %w[身体 技術], 7),
  Action.new('白兵', %w[身体 技術], '?'),
  Action.new('偵察', %w[身体 感覚], 7),
  Action.new('大揺れ', %w[身体 感覚], 7),
  Action.new('消火', %w[身体 教養], 7),
]

def print_chat_pallets(strong_points, weak_point)
  ABILITIES.each do |ability|
    puts convert_chat_pallet(ability, strong_points.include?(ability), ability == weak_point)
  end
  ABILITIES.combination(2).each do |ability_tuple|
    puts convert_chat_pallet(ability_tuple.join('・'), ability_tuple.any? { |v| strong_points.include?(v) }, ability_tuple.include?(weak_point))
  end
  ACTIONS.each do |action|
    puts convert_chat_pallet(action.label, action.requirements.any? { |v| strong_points.include?(v) }, action.requirements.include?(weak_point), action.difficulty)
  end
end

def convert_chat_pallet(label, strong, weak, difficulty='?')
  case
  when strong && weak
    "3d6kh2>=#{difficulty} 【#{label}±】"
  when strong
    "3d6kh2>=#{difficulty} 【#{label}+】"
  when weak
    "2d6>=#{difficulty} 【#{label}-】"
  else
    "2d6>=#{difficulty} 【#{label}】"
  end
end

op = OptionParser.new
options = {}
op.on('-s', '--specialist', '専門分野') { |v| options[:specialist] = true }
op.on('-c', '--craftsman', '職人肌') { |v| options[:craftsman] = true }
op.on('-h', '--help', 'show this help') do
  print(<<~USAGE)
    「歯車の塔の探空士」用のチャットパレット生成器です。
    第一引数に得意な能力、第二引数に苦手な能力を指定するとチャットパレットを出力します。
    得意な能力は,で複数指定できます。
    能力は「技術」「感覚」「教養」「身体」の4つから選択します。

    利用例
    $ ruby chat_pallet.rb 技術 感覚
    $ ruby chat_pallet.rb 技術,身体 感覚

    #{op}
  USAGE
  exit 0
end

args = op.parse(ARGV)
print_chat_pallets(args[0].split(','), args[1])
