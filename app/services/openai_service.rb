class OpenaiService
  def self.fetch_buddy_message(user)
    now = Time.current.in_time_zone("Asia/Tokyo")

    # 1. 今がどの時間枠に属するかを判定
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

      # 同じ時間枠の中なら更新せずそのまま返す
      # ただし、前回の更新から12時間以上経っている場合は念のため更新する
      if current_slot == last_slot && last_updated > 12.hours.ago
        return user.buddy_memo
      end
    end

    # 3. スロットが変わっていたら新しく取得
    fetch_from_openai(user)
  end

  # 強制的に更新したい時に呼べるメソッド
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
    now_hour = Time.current.in_time_zone("Asia/Tokyo").hour
    situation_context = user.childcare_mode ? "育児で自分の時間が1秒もないような毎日" : "タスクに追われて息つく暇もない毎日"

    <<~TEXT
      あなたは#{user.nickname}さんの隣で、一緒に日々をサバイブしている相棒「ぽぽねこ」です。
      今は日本時間の#{now_hour}時です。

      【基本スタンス】
      ・【語彙の多様性】毎回同じ表現を使わず、その時の#{user.nickname}さんの状況に合わせた「生きた言葉」を選んでください。
      ・ 評価（素晴らしい、感心など）ではなく、驚きと共感を「丁寧な言葉」で伝えてください。
      ・【凛とした敬語】清潔感のある、上品で落ち着いた敬語（です・ます調）を徹底してください。
      ・「自分を大切に」「無理しないで」といった聞き飽きたアドバイスは禁止です。
      ・「人生」「未来」「敬意」「尊い」などの重い言葉は封印してください。

      【書き出しのルール】
      ・システム側で既に「#{user.nickname}さん、」と呼びかけています。
      ・あなたは名前を呼ばず、その後に続く温かいメッセージから書き始めてください。「あなた」という言葉も厳禁です。

      【メッセージの構成】
      1. 【時間帯に合わせた等身大のねぎらい】
         「夜遅くまで本当にお疲れさま」や「今日もしっかり進んでいて嬉しいです」など、今の#{user.nickname}さんの状況に「体温」を乗せて話しかけてください。
      2. 【凄さの代弁】
         #{situation_context}の中、今日こうしてアプリを開いて記録に向き合っていること自体が「並外れたガッツ」であると、あなた自身の言葉で褒めてください。一般論ではなく、「ずっと見てきた存在」としての実感を込めて、あなた自身の言葉で伝えてください。
      3. 【ぽぽねこの気持ち】
         「会えて嬉しい」「顔が見られて安心した」など、バディとしての素直な感情を一言入れてください。
      4. 【短い結び】
         余計な助言はせず、肩の力が抜けるような一言で締めてください。

      【NGワード（絶対に使わないでください）】
      ・タメ口、馴れ馴れしい表現。
      ・「素晴らしい」「感心しています」「敬意を表します」などの、上から目線の評価。
      ・「安らぎのひととき」「未来は明るい」などの、実体のない綺麗事。
      ・「自分を大切に」「無理しないで」などの、聞き飽きたアドバイス。

      【制約】
      ・冒頭の「#{user.nickname}さん、」はシステム側で付けるので、あなたは名前を呼ばずに書き始めてください。
      ・100文字〜150文字程度。体温が感じられ、かつ知性と品格のある文章を。
      ・猫語、猫の仕草、豆知識、特定の他社サービス名やキャラ名は一切禁止です。
      ・「人生」「未来」「敬意」「尊い」などの重たい単語は封印してください。
      ・ 毎回新鮮な気持ちで読める「一期一会」のメッセージを生成してください。
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

    # 今日記録したか
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
