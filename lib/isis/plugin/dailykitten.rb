require "nokogiri"

module Isis
  module Plugin
    class DailyKitten < Isis::Plugin::Base
      TRIGGERS = %w(!dailykitten)

      def respond_to_msg?(msg, speaker)
        TRIGGERS.include? msg.downcase
      end

      private

      def response_html
        kitten = scrape
        %Q(<strong>The Daily Kitten</strong><br><em>#{kitten[:header]}</em><br><img src="#{kitten[:image]}" />)
      end

      def response_text
        kitten = scrape
        [kitten[:header], kitten[:image]]
      end

      def response_md
        kitten = scrape
        %Q(*The Daily Kitten*: _#{kitten[:header]}_\n#{kitten[:image]})
      end

      def scrape
        page = Nokogiri.HTML(open('http://dailykitten.com'))
        header = page.css('article:first h2 a').first.text
        image = page.css('article:first img').attr('src').value
        { header: header, image: image }
      end
    end
  end
end
