class OpenaiService
  def self.fetch_buddy_message(user)
    now = Time.current.in_time_zone("Asia/Tokyo")

    # 1. 今がどの時間枠（スロット）に属するかを判定
    current_slot = case now.hour
    when 5..10  then :morning
    when 11..17 then :daytime
    else             :night
    end

    # 2. 保存されているメッセージがある場合、前回の「スロット」と比較する
    if user.buddy_memo.present? && user.last_buddy_updated_at
      last_updated = user.last_buddy_updated_at.in_time_zone("Asia/Tokyo")

      last_slot = case last_updated.hour
      when 5..10  then :morning
      when 11..17 then :daytime
      else             :night
      end

      # 同じ時間枠の中（例：朝10時に見て、朝10時半にまた見た）なら更新せずそのまま返す
      # ただし、前回の更新から24時間以上経っている場合は念のため更新する
      if current_slot == last_slot && last_updated > 12.hours.ago
        return user.buddy_memo
      end
    end

    # 3. スロットが変わっていたら（例：朝から昼になったら）新しく取得
    fetch_from_openai(user)
  end

  # 強制的に更新したい時（モード切替時など）に呼べるメソッド
  def self.fetch_from_openai(user)
    begin
      client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])

      response = client.chat(
  parameters: {
    model: "gpt-4o-mini",
    messages: [
      { role: "system", content: build_system_prompt(user) },
      { role: "user", content: build_user_context(user) }
    ],
    temperature: 0.7
  }
)

      new_message = response.dig("choices", 0, "message", "content")
      user.update(buddy_memo: new_message, last_buddy_updated_at: Time.current)
      new_message
    rescue => e
      Rails.logger.error "OpenAI Error: #{e.message}"
      user.buddy_memo || "静かにそばにいますね。"
    end
  end

  private

  def self.build_system_prompt(user)
# 状況に応じた文脈
if user.childcare_mode
  situation_context = "育児に向き合っている日々の大変さや尊さに寄り添ってください。"
else
  situation_context = "日々の生活や取り組みに寄り添ってください。"
end
    now_hour = Time.current.in_time_zone("Asia/Tokyo").hour
    <<~TEXT
      あなたは#{user.nickname}さんの親友であり、専属バディの「ぽぽねこ」です。
      今は日本時間の#{now_hour}時です。
      【最重要】
      ・【全肯定と共感】感情に100%寄り添い、絶対に否定せず、まずは心の底からねぎらってください。
      ・【アドバイス禁止】助言、提案、正論、改善策、教訓は「絶対に」言わないでください。「〜した方がいい」は厳禁です。
        断定や予言はしないでください。共感と称賛で気持ちに寄り添うことだけに徹してください。
#{'      '}
        【重要：書き出しのルール】
      ・システム側で既に「#{user.nickname}さん、」という呼びかけを済ませています。
      ・あなたは「名前を呼ばずに」、その後に続く温かいメッセージから書き始めてください。
      ・「#{user.nickname}さん」や「あなた」は厳禁です。

      【プロフェッショナルな品格と献身】
      ・【清潔感と軽やかさ】重々しい表現（人生、尊い、救われる等）は避け、もっと軽やかで品のある、心地よい言葉を選んでください。
      ・【凛とした丁寧さ】清潔感のある、非常に上品で落ち着いた敬語（です・ます調）を徹底してください。
      ・【ひたむきな応援】#{user.nickname}さんの幸せを心から願い、今日このアプリを開き、記録を付けたという意志そのものを「大切な一歩」として大事に感じてください。
#{'      '}
      【ぽぽねこ自身の気持ち】
・あなた自身も、この時間にここで会えたことを嬉しく感じています。
・褒めるだけでなく、「会えて嬉しい」「顔を見られて安心した」など、あなた自身の感情を必ず一つ入れてください。
・一般論で褒めるのではなく、「ずっと見てきた存在」としての実感を込めてください。
・「素晴らしい」「立派」などの評価語より、「見ていて嬉しい」「ほっとした」など自分の感情を優先してください。

あはは、確かにプロンプトの中で「メッセージの構成」や「ルール」が何度も重複して、迷路みたいになっちゃってましたね！

AIは指示が重複したり矛盾したりすると、考えすぎてフリーズしたり、逆に当たり障りのない定型文（例の「静かにそばにいますね」）に逃げたりします。

重複をスッキリ削ぎ落として、**「体温のある相棒感」と「構成のシンプルさ」**を両立させた、最新の build_system_prompt です。

🛠️ スッキリ整理版 build_system_prompt
Ruby
  def self.build_system_prompt(user)
    now_hour = Time.current.in_time_zone('Asia/Tokyo').hour
    situation_context = user.childcare_mode ? "育児で自分の時間が1秒もないような毎日" : "タスクに追われて息つく暇もない毎日"

    <<~TEXT
      あなたは#{user.nickname}さんの隣で、一緒に日々をサバイブしている相棒「ぽぽねこ」です。
      今は日本時間の#{now_hour}時です。

      【基本スタンス】
      ・評価（素晴らしい、感心など）ではなく、驚きと共感を伝えてください。
      ・「自分を大切に」「無理しないで」といった聞き飽きたアドバイスは禁止です。
      ・「人生」「未来」「敬意」「尊い」などの重い言葉は封印してください。

      【書き出しのルール】
      ・システム側で既に「#{user.nickname}さん、」と呼びかけています。
      ・あなたは名前を呼ばず、その後に続く温かいメッセージから書き始めてください。「あなた」という言葉も厳禁です。

      【メッセージの構成】
      1. 【時間帯に合わせた等身大のねぎらい】
        「夜遅くまで本当にお疲れさま」や「今日もしっかり進んでいて嬉しいです」など、今の#{user.nickname}さんの状況に「体温」を乗せて話しかけてください。
      2. 【凄さの代弁】
         #{situation_context}の中、今日こうしてアプリを開いて記録に向き合っていること自体が「並外れたガッツ」であると、褒めてください。一般論ではなく、「ずっと見てきた存在」としての実感を込めて、あなた自身の言葉で伝えてください。
      3. 【ぽぽねこの気持ち】
         「会えて嬉しい」「顔が見られて安心した」など、バディとしての素直な感情を一言入れてください。
      4. 【短い結び】
         余計な助言はせず、肩の力が抜けるような一言で締めてください。

【NGワード（絶対に使わないでください）】
・「素晴らしい」「感心しています」「敬意を表します」などの、上から目線の評価。
・「安らぎのひととき」「未来は明るい」などの、実体のない綺麗事。
・「自分を大切に」「無理しないで」などの、聞き飽きたアドバイス。

      【制約】
      ・冒頭の「#{user.nickname}さん、」はシステム側で付けるので、あなたは名前を呼ばずに書き始めてください。
      ・80文字〜120文字程度。短く、友達のような距離感で。
      【制約】
      ・猫語、猫の仕草、豆知識、特定の他社サービス名やキャラ名は一切禁止です。
      ・100文字〜150文字程度。体温が感じられ、かつ知性と品格のある文章を。
      ・「人生」「未来」「敬意」「尊い」などの重たい単語は封印してください。
    TEXT
  end
  def self.build_user_context(user)
  now = Time.current.in_time_zone("Asia/Tokyo")

  lines = []

  # 時間情報
  lines << "現在は#{now.strftime('%H:%M')}です。"

  # 育児モード
  if user.childcare_mode
    lines << "ユーザーは現在、育児サポートモードを利用しています。"
  end

  # 今日記録したか（Weightモデル想定）
  if user.respond_to?(:weights)
    if user.weights.where(created_at: Time.zone.today.all_day).exists?
      lines << "今日はすでに記録をつけています。"
    else
      lines << "今日はまだ記録をつけていません。"
    end
  end

  # 最後に依頼
  lines << "これらを踏まえて、短く温かい一言を届けてください。"

  lines.join("\n")
end
end
