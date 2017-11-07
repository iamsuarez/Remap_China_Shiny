library(shiny)
library(REmap)

shinyUI(
  fluidPage(
    #设置主题
    titlePanel("Data From China"),
    #设置左侧输入栏、设置右侧展示栏
    sidebarLayout(
      #设置左侧输入栏
      sidebarPanel(
        #1:设置选项卡
        selectInput(inputId="Data",label = "客户数据",
                      choices = c("Person_Count","Money_Count"))
        
      ),
      #设置右侧展示栏
      mainPanel(
        REmapOutput("chinamap"),
        tableOutput("view_table")
        
      )
    )
  )
)