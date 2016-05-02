# -*- coding: utf-8 -*-
require'find'
require'json'
require'csv'
require'kconv'
require'fileutils'

dataRank=CSV.read("atp-ranking-singles.csv")
dataPlayer=CSV.read("playerNameJP.csv")
dataStats=CSV.read("atp-ranking.csv")

all=Hash.new

date=""
r=0
dataRank.each do|dataR|
  if r==0    
    date=dataR[1]
  else    
    all[r]=Hash.new
    all[r]["Rank"]=dataR[1]
    all[r]["Player"]=dataR[5]
    all[r]["PlayerJP"]=dataR[5]
    all[r]["Age"]=dataR[7]    
    all[r]["Points"]=dataR[9]

    all[r]["Country"]=""
    all[r]["Aces"]=""
    all[r]["Double Faults"]=""
    all[r]["1st Serve"]=""
    all[r]["1st Serve Points Won"]=""
    all[r]["2nd Serve Points Won"]=""
    all[r]["Service Games Won"]=""
    all[r]["Total Service Points Won"]=""
    all[r]["1st Serve Return Points Won"]=""
    all[r]["2nd Serve Return Points Won"]=""
    all[r]["Return Games Won"]=""
    all[r]["Return Points Won"]=""
    all[r]["Total Points Won"]=""
    
    all[r]["Win"]=""
    all[r]["Lose"]=""
    all[r]["WinPer"]=""

    
  end
  r=r+1
end

all.each do|a|               
  dataPlayer.each do|dataP|
#    p a[1]["Player"]
    if a[1]["Player"]=~/#{dataP[0]}/
      a[1]["PlayerJP"]=dataP[1]
    end
  end
  dataStats.each do|dataS|
    if a[1]["Rank"]==dataS[1]
      a[1]["Country"]=dataS[3]
      aces=(dataS[15].to_f/dataS[29].to_f).round(2)
      a[1]["Aces"]=aces
      df=(dataS[17].to_f/dataS[29].to_f).round(2)      
      a[1]["Double Faults"]=df
      
      a[1]["1st Serve"]=dataS[19].gsub("%","")
      a[1]["1st Serve Points Won"]=dataS[21].gsub("%","")
      a[1]["2nd Serve Points Won"]=dataS[23].gsub("%","")
      a[1]["Service Games Won"]=dataS[31].gsub("%","")
      a[1]["Total Service Points Won"]=dataS[33].gsub("%","")
      a[1]["1st Serve Return Points Won"]=dataS[35].gsub("%","")
      a[1]["2nd Serve Return Points Won"]=dataS[37].gsub("%","")
      a[1]["Return Games Won"]=dataS[45].gsub("%","")
      a[1]["Return Points Won"]=dataS[47].gsub("%","")
      a[1]["Total Points Won"]=dataS[49].gsub("%","")

      a[1]["Win"]=dataS[11]
      a[1]["Lose"]=dataS[13]
      den=(dataS[11].to_f+dataS[13].to_f)
      if den>0 then
        winper=(dataS[11].to_f/(dataS[11].to_f+dataS[13].to_f)).round(2)
        winper=(winper*100).to_i
      else
        winper=""
      end
      a[1]["WinPer"]=winper

      
    end
    
  end
end

dt=Hash.new
rkg=Hash.new
srv1=Hash.new
srv2=Hash.new
rtn=Hash.new
winlose=Hash.new
data=Hash.new

dt["date"]=date

r=0
array=[0,1,2,3,4,5]
all.each do |a|
  rkg[r]=Hash.new
  for i in 0..(array.length-1)
    rkg[r][a[1].keys[array[i]]]=a[1].values[array[i]]
  end
  r=r+1
end

r=0
array=[0,2,6,7,8,12]
all.each do |a|
  srv1[r]=Hash.new
  for i in 0..(array.length-1)
    srv1[r][a[1].keys[array[i]]]=a[1].values[array[i]]
  end
  r=r+1
end

r=0
array=[0,2,8,9,10,12]
all.each do |a|
  srv2[r]=Hash.new
  for i in 0..(array.length-1)
    srv2[r][a[1].keys[array[i]]]=a[1].values[array[i]]
  end
  r=r+1
end

r=0
array=[0,2,13,14,16]
all.each do |a|
  rtn[r]=Hash.new
  for i in 0..(array.length-1)
    rtn[r][a[1].keys[array[i]]]=a[1].values[array[i]]
  end
  r=r+1
end

r=0
array=[0,2,18,19,20]
all.each do |a|
  winlose[r]=Hash.new
  for i in 0..(array.length-1)
    winlose[r][a[1].keys[array[i]]]=a[1].values[array[i]]
  end
  r=r+1
end


data["date"]=dt
data["ranking"]=rkg
data["serve1"]=srv1
data["serve2"]=srv2
data["return"]=rtn
data["winlose"]=winlose


#i=0
#key=""
#all[1].keys.each do |k|
#  key << i.to_s
#  key << ":"
#  key << k
#  key << "\n"
#  i=i+1
#end
#
#File.open('keys.txt','w') do|io|
#  io.write key
#end

File.open('FTP\atpRanking.json','w') do|io|
  io.write data.to_json
end

date=date.gsub(".","")
fileName=date+"-atpRanking.json"
File.open("FTP/"+fileName,'w') do|io|
  io.write data.to_json
end

FileUtils.copy('atpRanking.json','C:\xampp\htdocs\atpRanking.json')



