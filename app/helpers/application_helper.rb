# -*- coding: utf-8 -*-
module ApplicationHelper
  def full_title(page_title)
    title = "品酷" + (page_title.blank? ? "" : " | #{page_title}")
    if signed_in? && current_user.messages.unreads.count > 0
      title = "(#{current_user.messages.unreads.count}) " + title
    end
    title
  end

  def upyun_file_field_tag(id, type)
    require 'upyun'
    file_field_tag id, UpYun.new(type).data(upyun_redirect_url)
  end

  def image_url(type, path, thumb)
    require 'upyun'
    UpYun.new(type).url(path, thumb)
  end

  def nl2br(html)
    raw(h(html).gsub(/[(\n)(\r)]/, "\n" => "<br>", "\r" => "" ))
  end

  def time_ago_tag(time)
    time_tag time, time_ago_in_words(time)+"前"
  end

end
