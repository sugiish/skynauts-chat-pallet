require 'optparse'

ABILITIES = %w[身体 技術 感覚 教養]

Action = Struct.new(:label, :requirements, :difficulty)
ACTIONS = [
  Action.new('砲撃', %w[技術 感覚], 7),
  Action.new('修理', %w[技術 教養], 7),
  Action.new('操舵', %w[感覚 教養], 7),
  Action.new('回避', %w[感覚 教養], 7),
  Action.new('侵入', %w[身体 技術], 7),
  Action.new('白兵', %w[身体 技術], 7),
  Action.new('偵察', %w[身体 感覚], 7), # 電探のみ「技術・教養：8」
  Action.new('大揺れ', %w[身体 感覚], 7),
  Action.new('消火', %w[身体 教養], 7),
]

def print_chat_pallets(strong_points, weak_point, options)
  ABILITIES.each do |ability|
    puts convert_chat_pallet(ability, strong_points.count(ability), ability == weak_point, options)
  end
  ABILITIES.combination(2).each do |ability_tuple|
    puts convert_chat_pallet(ability_tuple.join('・'), ability_tuple.count { |v| strong_points.include?(v) }, ability_tuple.include?(weak_point), options)
  end
  ACTIONS.each do |action|
    puts convert_chat_pallet(action.label, action.requirements.count { |v| strong_points.include?(v) }, action.requirements.include?(weak_point), options, action.difficulty)
  end
end

def convert_chat_pallet(label, strong_count, weak, options, difficulty=7)
  case
  when strong_count > 0 && weak
    if options[:craftsman]
      "3sn#{difficulty}#1 【#{label}+(-)】"
    else
      "3sn#{difficulty}#2 【#{label}±】"
    end
  when strong_count > 0
    if options[:specialist] && strong_count == 2
      "4sn#{difficulty}#1 【#{label}*】"
    else
      "3sn#{difficulty}#1 【#{label}+】"
    end
  when weak
    "2sn#{difficulty}#2 【#{label}-】"
  else
    "2sn#{difficulty}#1 【#{label}】"
  end
end

def show_help_and_exit(op)
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

op = OptionParser.new
options = {}
op.on('-s', '--specialist', '専門分野') { |v| options[:specialist] = true }
op.on('-c', '--craftsman', '職人肌') { |v| options[:craftsman] = true }
op.on('-h', '--help', 'show this help') { show_help_and_exit(op) }

args = op.parse(ARGV)
show_help_and_exit(op) if args.empty?
print_chat_pallets(args[0].split(','), args[1], options)
