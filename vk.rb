#!/usr/bin/env ruby

require 'rubygems'
require 'nokogiri'

# Nokogiri::HTML
# http://ruby.bastardsbook.com/chapters/html-parsing/

# Запуск из командной строки
# $ ruby vk.rb ~/Downloads/аудиозаписи.html ~/Music/vk_my_music/
# http://stackoverflow.com/questions/10316495/call-ruby-function-from-command-line


module VK

  class VKError < StandardError
  end

  def self.download_music(page_html, dir)
    raise VKError.new("No such file: #{page_html}") unless File.exists?(File.expand_path(page_html))
    raise VKError.new("No such directory: #{dir}") unless Dir.exists?(File.expand_path(dir))

    page = Nokogiri::HTML(open(page_html))
    page.css('div.area.clear_fix').each_with_index do |soundtrack, index|
      # TODO сделать нормальное формирования имени файла
      name = soundtrack.css('span.title')[0].text[0..63].gsub('"', ' ').strip || "no_name_#{Time.now.to_i}"
      url = soundtrack.css('input')[0]['value'][/^.+.mp3/]
      puts "#{index} \t #{name} \t #{url}"

      command = %Q{curl -# -o "#{dir}/#{name}.mp3" #{url}}
      puts command
      system command
      puts
    end
    puts 'OK'
  end

end

VK.download_music(ARGV[0], ARGV[1])