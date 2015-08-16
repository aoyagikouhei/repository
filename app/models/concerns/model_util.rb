module ModelUtil extend ActiveSupport::Concern
  module ClassMethods  
    # 日付カラムの絞り込み
    # 空を特殊な値で表現しているので、空かどうかはこのメソッドを使用する
    def where_for_null_at(table: table_name, column: 'deleted_at')
      where("#{table}.#{column} IS NULL")
    end

    # 削除されていない、ものを取得する
    def find_for_available
      where_for_null_at.all
    end

    # 削除されていない、IDのものを取得する
    def find_for_available_id(id)
      where_for_null_at.where("id = ?", id).first
    end

    # ストアードプロシージャーを実行する
    def find_for_sp(name, db_params)
      # パラメーターに応じてSQLを構築
      bind_params = db_params.map{|k, v| "p_#{k} := :#{k}"  }
      sql = " SELECT * FROM #{name} (#{bind_params.join(",")}) "

      # 配列などのパラメーター調整
      db_params.each do |k, v|
        # ID配列
        if k =~ /_id_array$/ 
          if v.is_a?(Array)
            # 配列で与えられた
            db_params[k] = "{#{v.join(",")}}"
          else
            # 文字列で与えられた
            value = v.to_s

            # カンマで分解
            ary = value.split(/,/)

            # 数値だけ回収
            id_array = ary.inject([]) do |res, it|
              integer_value = it.to_i
              if integer_value.present? && integer_value > 0
                res << integer_value 
              end
              res
            end

            # 配列のリテラルで最代入
            db_params[k] = id_array.present? ? "{#{id_array.join(",")}}" : nil
          end
        elsif k =~ /_kbn_array$/
          # 区分配列
          db_params[k] = "{#{ v.is_a?(Array) ? v.join(",") : v }}"
        end
      end

      # 実行する
      find_by_sql([sql, db_params])
    end


  end
end
