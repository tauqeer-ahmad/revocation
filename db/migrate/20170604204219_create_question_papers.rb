class CreateQuestionPapers < ActiveRecord::Migration[5.0]
  def change
    create_table :question_papers do |t|
      t.text :content
      t.references :teacher
      t.references :subject, foreign_key: true
      t.references :section, foreign_key: true
      t.references :klass, foreign_key: true
      t.references :exam, foreign_key: true
      t.references :term, foreign_key: true

      t.timestamps
    end
  end
end
