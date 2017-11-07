library(shiny)
library(REmap)
#设置remap包的API 的key:
options(remap.ak="MY07CLhm3wKi4N2tQ6WP4kzz21BBZagI")
#设置百度的API 的key:(这个需要自己申请获得)
options(baidumap.key = 'cZOvflqxwQLx3co85TgOZkOEFZQ6IGHL')
#=====================Data=============================#
Person_Count<-data.frame(省份=c("北京","天津","上海","重庆","河北",
                              "河南","云南","辽宁","黑龙江","湖南",
                              "安徽","山东","新疆","江苏","浙江",
                              "江西","湖北","广西","甘肃","山西",
                              "内蒙古","陕西","吉林","福建","贵州",
                              "广东","青海","西藏","四川","宁夏"
                              ,"海南","台湾","香港","澳门"),
                           客户量=c(seq(100,by=16,length=10),
                                 seq(200,by=16,length=10),
                                 seq(1000,by=16,length=10),c(236,654,512,541)))
Money_Count<-data.frame(省份=c("北京","天津","上海","重庆","河北",
                             "河南","云南","辽宁","黑龙江","湖南",
                             "安徽","山东","新疆","江苏","浙江",
                             "江西","湖北","广西","甘肃","山西",
                             "内蒙古","陕西","吉林","福建","贵州",
                             "广东","青海","西藏","四川","宁夏"
                             ,"海南","台湾","香港","澳门"),
                          借贷总额=c(seq(10000,by=2300,length=10),
                                seq(20550,by=1600,length=10),
                                seq(30000,by=36000,length=10),c(23600,65400,51200,54100)))
List_Data<-list(Person_Count=Person_Count,
                Money_Count=Money_Count)

#=====================markPoint==================#
#准备绘制作点用的前10城市数据，并设置颜色。
markpoint_data<-data.frame(point=c("济南","武汉","蚌埠","乌鲁木齐",
                                   
                                   "北京","天津","沈阳","菏泽",
                                   
                                   "广州","贵阳"),
                           color=c("#FFE4B5","#FFD700","#FFB5C5","#EEEEE0","#A2CD5A","#96CDCD","#8B864E",
                                   "#00868B","#1874CD","#71C671"))


#控制点的主题样式
markpoint_control_theme<-markPointControl(symbol = 'circle',
                                          
                                          symbolSize =15,
                                          
                                          effect =T,
                                          
                                          effectType = 'scale'
                                          
)


#=====================markLine===================#
#准备绘制作线条用的前10城市数据,并设置颜色
markline_data <-data.frame(origin=rep("上海",10),
                           
                           destination=c("济南","武汉","蚌埠","乌鲁木齐",
                                         
                                         "北京","天津","沈阳","菏泽",
                                         
                                         "广州","贵阳"),
                           
                           color=c("#FFE4B5","#FFD700","#FFB5C5","#EEEEE0","#A2CD5A","#96CDCD","#8B864E",
                                   "#00868B","#1874CD","#71C671")
                           
)

markline_control_theme <-markLineControl(symbol='circle',
                                         symbolSize=c(2,2),
                                         
                                         smooth=T,
                                         
                                         smoothness=0,
                                         
                                         effect=T,
                                         
                                         lineWidth=1,
                                         
                                         lineType="solid"
                                         
)
#====================================shinyServer============================#
shinyServer(
  function(input,output){
#=========准备数据=============#
    #需要绘制地图的数据
    datasetinput<-reactive(
      {
        switch(
          input$Data,
          "Person_Count"=Person_Count,
          "Money_Count"=Money_Count
          
        )
      }
    )
    #绘制地图的主题
    mainsetinput<-reactive(
      {
        switch(
          input$Data,
          "Person_Count"="客户量在中国各地的分布",
          "Money_Count"="借贷总额在中国各地的分布"
          
        )
      }
    )
    #绘制地图的背景
    colorsetinput<-reactive(
      {
        switch(
          input$Data,
          "Person_Count"=c('#1e90ff','#f0ffff'),
          "Money_Count"=c("#EEEEE0","#E0FFFF")
          
        )
      }
    )
     #1:
    output$view_table=renderTable(
      {
        data <-datasetinput()
        head(data)
      }
    )
    
    #2:绘制中国地图输出
    output$chinamap = renderREmap(
      {
        datainput<-datasetinput()
        
        maininput<-mainsetinput()
        
        colorinput<-colorsetinput()
        
        remapC(data=datainput,maptype = 'china',title=maininput,
               markPointData=markpoint_data,markPointTheme=markpoint_control_theme,
               markLineData=markline_data,markLineTheme=markline_control_theme,
               color=colorinput)
      }
    )
    
  }
)