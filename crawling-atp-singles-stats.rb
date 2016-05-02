# -*- coding: utf-8 -*-
require'anemone'
require'nokogiri'
require'kconv'
require'csv'

csv=""

urls=["http://www.atpworldtour.com/en/rankings/singles"]
Anemone.crawl(urls,:depth_limit => 1,:deley => 1) do |anemone|

  #巡回先の絞り込み
  anemone.focus_crawl do |page|
    page.links.keep_if{ |link|
      link.to_s.match(/\/en\/players\/.+?overview$/)
    }
  end

  #取得したページに対する処理
  anemone.on_every_page do |page|
    doc=Nokogiri::HTML.parse(page.body)

    puts page.url
    
    #overviewページでの処理
    #rank
    csv << "Rank"+","
    csv << doc.xpath("//*[@id='playerProfileHero']/div[2]/div[1]/div/div[3]/div[1]/div[2]").text.strip+","
    #country

    csv << "Country"+","
    csv << doc.xpath("//*[@id='playerProfileHero']/div[2]/div[1]/div/div[3]/div[2]/div[2]").text.strip+","
    #age
    csv << "Age"+","
    csv << doc.xpath("//*[@class='table-big-value'][0]/span").to_s+","
    #firstName
    csv << "FirstName"+","
    csv << doc.xpath("//*[@id='playerProfileHero']/div[2]/div[1]/div/div[1]/div[1]").text.strip+","
    #lastName
    csv << "LastName"+","
    csv << doc.xpath("//*[@id='playerProfileHero']/div[2]/div[1]/div/div[1]/div[2]").text.strip+","
    #winLose
    #csv << "WinLose"+","
    #    csv << doc.xpath("//*[@id='playersStatsTable']/tbody/tr[1]/td[4]/div[1]").text.strip+","
    str=doc.xpath("//*[@id='playersStatsTable']/tbody/tr[1]/td[4]/div[1]").text.strip
    csv << "Win"+","
    if str =~ /([0-9]*)-/
      csv << $1
      csv << ","
    end
    csv << "Lose"+","
    if str =~ /-([0-9]*)/
      csv << $1
      csv << ","
    end
    #overviewページからplayer-statsページに移動
    url = page.url.request_uri
    url="http://www.atpworldtour.com"+url.gsub(/overview/,'player-stats?year=2015&surfaceType=all')

    #player-statsページの処理
    Anemone.crawl(url,:depth_limit => 1,:deley => 1) do |anemone|
      #巡回先の絞り込み
      anemone.focus_crawl do |page|
        page.links.keep_if{ |link|
          link.to_s.match(/\/en\/players\/.+?player-stats?year=2015&surfaceType=all$/)
        }
      end

      anemone.on_every_page do |page|
        puts page.url
        data=[]
        doc=Nokogiri::HTML.parse(page.body)

        doc.xpath("//*[@id='playerMatchFactsContainer']/table/tbody/tr/td").each do |node|
          data.push(node.text.strip)
        end
        csv << data.to_csv

      end
    end
    
  end

end

File.open('atp-ranking.csv','w') do |io|
  io.write csv
end

