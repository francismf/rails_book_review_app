require 'elasticsearch/model'
class Book < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :reviews
  has_attached_file :book_img, styles: { book_index: "250x350>", book_show: "325x475>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :book_img, content_type: /\Aimage\/.*\z/

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  index_name Rails.application.class.parent_name.underscore
  document_type self.name.downcase

  settings index: { number_of_shards: 1 } do
    mapping dynamic: false do
      indexes :title, analyzer: 'english'
      indexes :author, analyzer: 'english'
    end
  end


  def as_indexed_json(options = nil)
    self.as_json( only: [ :title, :author ] )
  end

  def self.search(query)
    __elasticsearch__.search(
      {
        query:
        {
          bool:
          {
            must:[],
            must_not:[],
            should:[
              {
                multi_match: {
                  query: query,
                  fields: ['title^5', 'author']
                }
              }
            ]
          }
        },
        from: 0,
        size: 10,
        sort:[],
        aggs:{}
      }

    )
  end
end
