# frozen_string_literal: true

class Memo
  DB_NAME = 'memoapp'
  TABLE_NAME = 'memo'

  def initialize
    @conn = PG.connect(dbname: DB_NAME)
  end

  def load_all
    load_all_query = "SELECT * FROM #{TABLE_NAME}"
    @conn.exec(load_all_query)
  end

  def find(id)
    @conn.prepare('find', "SELECT * FROM #{TABLE_NAME} WHERE id = $1")
    @conn.exec_prepared('find', [id]) { |result| result[0] }
  end

  def create(title, body)
    @conn.prepare('create', "INSERT INTO #{TABLE_NAME} (title, body) VALUES ($1, $2)")
    @conn.exec_prepared('create', [title, body])
  end

  def update(id, title, body)
    @conn.prepare('update', "UPDATE #{TABLE_NAME} SET (title, body) = ($2, $3) WHERE id = $1")
    @conn.exec_prepared('update', [id, title, body])
  end

  def delete(id)
    @conn.prepare('delete', "DELETE FROM #{TABLE_NAME} WHERE id = $1")
    @conn.exec_prepared('delete', [id])
  end
end
