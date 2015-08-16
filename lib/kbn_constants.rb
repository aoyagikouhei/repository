class KbnConstants
  # ユーザ区分
  USER_KBN = "001"

  # ユーザ区分(一般)
  USER_KBN_NORMAL = "00101"

  # ユーザ区分(管理者)
  USER_KBN_ADMIN = "00102"

  # 雛形区分
  TEMP_KBN = "002"

  # 雛形区分(テーブル)
  TEMP_KBN_TABLE = "00201"

  # 雛形区分(区分)
  TEMP_KBN_KBN = "00202"

  # 雛形区分(エラー)
  TEMP_KBN_ERROR = "00203"

  VALUES = {
    :"001" => {
      nm: "ユーザ区分",
      item: {
        :"01" => "一般",
        :"02" => "管理者",
      }
    },

    :"002" => {
      nm: "雛形区分",
      item: {
        :"01" => "テーブル",
        :"02" => "区分",
        :"03" => "エラー",
      }
    },
  }

  class << self
    # 区分値配列を取得する
    def get_ary(key)
      _key = key.to_sym
      return [] unless key.present? && KbnConstants::VALUES.key?(_key)
      KbnConstants::VALUES[_key][:item].keys.collect {|k| key.to_s + k.to_s}
    end
  
    # 区分が正しいか判定
    def valid?(key, value)
      return false if key.nil? || key.empty? || value.nil? || value.empty?
      kbn = KbnConstants::VALUES[key.to_sym]
      return false if kbn.nil? || key != value[0,3]
      kbn[:item][value[3, 2].to_sym].present?
    end
  
    # 区分名取得
    def get_logical_name(value)
      return "" if value.blank?
      kbn = KbnConstants::VALUES[value[0,3].to_sym]
      return "" if kbn.nil?
      nm = kbn[:item][value[3, 2].to_sym]
      nm.nil? ? "" : nm
    end
  
    # コンボボックス用コレクション取得
    def get_collection(key, except_ary: [])
      res = []
      return res if key.blank?
      kbn = KbnConstants::VALUES[key.to_sym]
      kbn[:item].each_pair do |k, v|
        obj = {id: key + k.to_s, nm: v.to_s}
        def obj.id
          self[:id]
        end
        def obj.nm
          self[:nm]
        end
        res << obj if !except_ary.include?(obj.id)
      end
      res
    end
  
    # select用コレクション取得
    def get_select(key, except_ary: [])
      res = []
      return res if key.blank?
      kbn = KbnConstants::VALUES[key.to_sym]
      kbn[:item].each_pair do |k, v|
        id = key + k.to_s
        res << [v.to_s, key + k.to_s] if !except_ary.include?(id)
      end
      res
    end
  end
end
