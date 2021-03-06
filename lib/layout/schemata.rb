require 'rss'


Layout.add_schema(:markdown, {
                    "type" => "string",
                    # "description" => "Markdown text",
                    "format" => "multiline",  # for onde.js
                  }) do |markdown_strings|
  markdown_strings.map {|str| RDiscount.new(str).to_html}
end

Layout.add_schema(:article, {
                    "type" => "integer",
                    "display" => "article-picker",
                    "required" => true,
                    "model" => true,
                  }) do |article_ids|
  Post.includes(:authors, :image).find_in_order(article_ids)
end

Layout.add_schema(:page, {"type" => "integer"}) do |page_ids|
  Page.includes(:image).find_in_order(page_ids)
end

Layout.add_schema(:disqus_popular, {"type" => "null"}) do |invocations|
  articles = Article.most_commented(7)
  [articles] * invocations.length
end

Layout.add_schema(:columnists, {'type' => 'null'}) do |invocations|
  invocations.map do |_|
    # TODO: eager load the most recent n articles
    Staff.includes(:headshot).where(columnist: true).order(:name)
  end
end

Layout.add_schema(:popular, {
                    'type' => 'string',
                    'enum' => promise { Taxonomy.top_level(:sections).map {|t| t.name.downcase} },
                  }) do |sections|
  sections.map do |section|
    Article.popular(section, limit: 7)
  end
end

Layout.add_schema(:section_articles, {
                    'type' => 'string',
                  }) do |sections|
  sections.map do |section|
    # FIXME: Magic number
    Article.limit(4).order('published_at DESC').section(section)
  end
end

Layout.add_schema(:rss, {'type' => 'string'}) do |feeds|
  [[]]
end

Layout.add_schema(:image, {
                    "type" => "integer",
                    "display" => "image-picker"
                  }) do |image_ids|
  Image.includes(:photographer).find_in_order(image_ids)
end

Layout.add_schema(:datetime, {
                    'type' => 'string',
#                    'format' => 'date-time',
                  }) do |datetimes|
  datetimes.map { |str| DateTime.iso8601(str) }
end

Layout.add_schema(:poll, {
                    'type' => 'integer',
                  }) do |poll_ids|
  Poll.includes(:choices).find_in_order(poll_ids)
end

Layout.add_schema(:gallery, {
  "type" => "string",
  "required" => true,
}) do |gallery_ids|
  Gallery.includes(:images).find_in_order(gallery_ids, :gid)
end

Layout.add_schema(:topic, {
                    "type" => "integer",
                  }) do |topic_ids|
  Topic.find_in_order(topic_ids)
end
