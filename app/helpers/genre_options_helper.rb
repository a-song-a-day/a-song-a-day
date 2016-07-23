module GenreOptionsHelper
  def genre_options(builder)
    builder.collection_check_boxes :genre_ids, Genre.all.order('name'), :id, :name do |b|
      b.label(class: 'option small') do
        b.check_box + content_tag('span', b.text, class: "option-name")
      end
    end
  end
end
