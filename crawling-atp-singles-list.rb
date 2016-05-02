# -*- coding: utf-8 -*-
require'anemone'
require'nokogiri'
require'kconv'
require'csv'

data=[]
csv=""

urls=["http://www.atpworldtour.com/en/rankings/singles"]
Anemone.crawl(urls,:depth_limit => 0,:deley => 1) do |anemone|

  #取得したページに対する処理
  anemone.on_every_page do |page|
    puts page.url
    doc=Nokogiri::HTML.parse(page.body)

    csv << "Date"+","
    csv << doc.xpath(
      "//*[@id='filterHolder']/div/div/div[1]/div/div").text.strip+",\n"
    
    for i in 1..100 do
    
      csv << "Rank"+","
      csv << doc.xpath(
        "//*[@id='rankingDetailAjaxContainer']/table/tbody/tr["+i.to_s+"]/td[1]").text.strip+","

      csv << "Move"+","
      csv << doc.xpath(
        "//*[@id='rankingDetailAjaxContainer']/table/tbody/tr["+i.to_s+"]/td[2]").text.strip+","


      csv << "Player"+","
      csv << doc.xpath(
        "//*[@id='rankingDetailAjaxContainer']/table/tbody/tr["+i.to_s+"]/td[4]").text.strip+","

      csv << "Age"+","
      csv << doc.xpath(
        "//*[@id='rankingDetailAjaxContainer']/table/tbody/tr["+i.to_s+"]/td[5]").text.strip+","


      csv << "Points"+","
      csv << doc.xpath(
        "//*[@id='rankingDetailAjaxContainer']/table/tbody/tr["+i.to_s+"]/td[6]/a").text.strip.delete(",")+","


      csv << "PointsDropping"+","
      csv << doc.xpath(
        "//*[@id='rankingDetailAjaxContainer']/table/tbody/tr["+i.to_s+"]/td[8]").text.strip.delete(",")+","
            
      csv << ",\n"
    end

    #overviewページでの処理
    #Rank
#    csv << "Rank"+","
 #   csv << doc.xpath("//*[@id='rankingDetailAjaxContainer']/table/tbody/tr[1]/td[1]").text.strip+","
    #Age
  #  csv << "Age"+","
   # csv << doc.xpath("//*[@id='rankingDetailAjaxContainer']/table/tbody/tr[1]/td[5]").text.strip+","
   
  end

end

File.open('atp-ranking-singles.csv','w') do |io|
  io.write csv
end

