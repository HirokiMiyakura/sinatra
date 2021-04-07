# frozen_string_literal: true

class Memo
  DB_NAME = 'memoapp'
  TABLE_NAME = 'memo'

  def initialize
    @conn = PG.connect(dbname: DB_NAME)
    create_table unless table_exist?
  end

  def load_all_memos
    load_all_query = "SELECT * FROM #{TABLE_NAME}"
    prepare_name = 'load_all'
    delete_if_exist(prepare_name)
    @conn.prepare(prepare_name, load_all_query)
    @conn.exec_prepared(prepare_name).map { |result| result }
  end

  def find_memo(id)
    memos = Memo.new
    all_memos = memos.load_all_memos
    @memo = all_memos.find { |memo| memo['id'] == id }
  end

  def create_memo(title, body)
    create_memo_query = "INSERT INTO #{TABLE_NAME} (title, body) VALUES ($1, $2)"
    prepare_name = 'create_memo'
    delete_if_exist(prepare_name)
    @conn.prepare(prepare_name, create_memo_query)
    @conn.exec_prepared(prepare_name, [title, body])
  end

  def update_memo(id, title, body)
    update_memo_query = "UPDATE #{TABLE_NAME} SET (title, body) = ($2, $3) WHERE id = $1"
    prepare_name = 'update_memo'
    delete_if_exist(prepare_name)
    @conn.prepare(prepare_name, update_memo_query)
    @conn.exec_prepared(prepare_name, [id, title, body])
  end

  def delete_memo(id)
    delete_memo_query = "DELETE FROM #{TABLE_NAME} WHERE id = $1"
    prepare_name = 'delete_memo'
    delete_if_exist(prepare_name)
    @conn.prepare(prepare_name, delete_memo_query)
    @conn.exec_prepared(prepare_name, [id])
  end

  private

  def prepare_exist?(prepare_name)
    tuple = @conn.exec("SELECT * FROM pg_prepared_statements WHERE name='#{prepare_name}'").cmd_tuples
    tuple.positive?
  end

  def delete_if_exist(prepare_name)
    @conn.exec("DEALLOCATE #{prepare_name}") if prepare_exist?(prepare_name)
  end

  def table_exist?
    exist_table_query = "SELECT table_name FROM information_schema.tables WHERE table_name = '#{TABLE_NAME}'"
    prepare_name = 'table_exist'
    delete_if_exist(prepare_name)
    @conn.prepare(prepare_name, exist_table_query)
    @conn.exec_prepared(prepare_name).cmd_tuples == 1
  end

  def create_table
    create_table_query = "CREATE TABLE #{TABLE_NAME} (id SERIAL, title TEXT NOT NULL, body TEXT)"
    prepare_name = 'create_table'
    delete_if_exist(prepare_name)
    @connection.prepare(prepare_name, create_table_query)
    @connection.exec_prepared(prepare_name)
  end
end
