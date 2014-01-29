class Post
  class EmbeddedMedia
    class IconTag < EmbeddedMedia::Tag
      # HAX: there must be a better way to generate HTML
      include ActionView::Helpers

      def initialize(_embedded_media, icon)
        @icon = icon
      end

      def to_html(float: :right)
        content_tag(:i, nil, class: "icon-#{@icon}")
      end

      def to_s
        "{{Icon:#{@icon}}}"
      end
    end
  end
end
