public with sharing class MapPractice {

  public map<string,List<string>> mapping {get;set;}
  public map<string,string> mappingg {get;set;}
    

  
//  constructor
public MapPractice(){
mapping = new map<string,List<string>>();
list<string> strlist = new list<string>{'AAA','BBB','CCC','DDD'};
mapping.put('1',strlist);
mappingg.put('1','111');
}}