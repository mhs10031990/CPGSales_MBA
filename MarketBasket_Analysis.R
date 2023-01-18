if (!require(tibble)) install.packages("tibble")
library(tibble)
if (!require(tidyverse)) install.packages("tidyverse")
library(tidyverse)
if (!require(lubridate)) install.packages("lubridate")
library(lubridate)
if (!require(viridis)) install.packages("viridis")
library(viridis)
if (!require(ggthemes)) install.packages("ggthemes")
library(ggthemes)
if (!require(gridExtra)) install.packages("gridExtra")
library(gridExtra)
if (!require(ggridges)) install.packages("ggridges")
library(ggridges)
if (!require(arules)) install.packages("arules")
library(arules)
if (!require(arulesViz)) install.packages("arulesViz")
library(arulesViz)



x <- read.csv("/data/BreadBasket_DMS.csv") %>%
  mutate(Date=as.Date(Date),
         Time=hms(Time)
  )
summary(x)

glimpse(x)

#item Frequency
jpeg(file="/data/R/most_popular_items.jpeg")
x1 <- x %>% 
  group_by(Item) %>% 
  summarise(Count = n()) %>% 
  arrange(desc(Count)) %>%
  slice(1:10) %>% # keep the top 10 items
  ggplot(aes(x=reorder(Item,Count),y=Count,fill=Item))+
  geom_bar(stat="identity")+
  coord_flip()+
  ggtitle("Most popular items")+
  theme(legend.position="none")
x1
dev.off()

# Line items sold per day
jpeg(file="/data/R/Line_items_sold_per_day.jpeg")
x2 <- x %>% 
  group_by(Date) %>% 
  summarise(Count= n()) %>% 
  mutate(Day=wday(Date,label=T)) %>% 
  ggplot(aes(x=Date,y=Count,fill=Day))+
  theme_fivethirtyeight()+
  geom_bar(stat="identity")+
  ggtitle("Line items sold per day")+
  scale_fill_viridis(discrete=TRUE)
x2
dev.off()


# Total line items sold per weekday
jpeg(file="/data/R/Line_items_sold_per_weekday.jpeg")
x3 <- x %>% 
  mutate(Day = wday(Date,label=T)) %>% 
  group_by(Day) %>% 
  summarise(Count= n()) %>% 
  ggplot(aes(x=Day,y=Count,fill=Day))+
  theme_fivethirtyeight()+
  geom_bar(stat="identity")+
  ggtitle("Total line items sold per weekday")+
  theme(legend.position="none")
x3
dev.off()


# Total unique transactions per weekday
jpeg(file="/data/R/Unique_transactions_per_weekday.jpeg")
x4 <- x %>% 
  mutate(wday=wday(Date,label=T)) %>% 
  group_by(wday,Transaction) %>% 
  summarise(n_distinct(Transaction)) %>% 
  summarise(Count=n()) %>% 
  ggplot(aes(x=wday,y=Count,fill=wday))+
  theme_fivethirtyeight()+
  geom_bar(stat="identity")+
  ggtitle("Unique_transactions_per_weekday")+
  theme(legend.position="none")
x4
dev.off()

# Line items sold per Hour
jpeg(file="/data/R/items_sold_per_hour.jpeg")
x7 <- x %>%
  mutate(Hour = as.factor(hour(x$Time))) %>% 
  group_by(Hour) %>% 
  summarise(Count=n()) %>% 
  ggplot(aes(x=Hour,y=Count,fill=Hour))+
  theme_fivethirtyeight()+
  geom_bar(stat="identity")+
  ggtitle("Line items sold per Hour")+
  theme(legend.position="none")
x7
dev.off()

#visualize transaction density person per hour
jpeg(file="/data/R/transaction_density_per_hour.jpeg")
x10 <- x %>% 
  mutate(Hour=as.factor(hour(Time)),
         Day=wday(Date,label=T)) %>% 
  group_by(Day,Hour,Transaction) %>% 
  summarise(Count=n()) %>% 
  ggplot(aes(x=Hour,y=Day,group=Day,fill=..density..))+
  theme_fivethirtyeight()+
  ggtitle("Transaction density per Hour by Day")+
  theme(legend.position="none")+
  geom_density_ridges_gradient(scale=2, rel_min_height=0.01)+
  scale_fill_viridis(option="magma")
x10
dev.off()


y <- read.transactions("/data/BreadBasket_DMS.csv",
                       format="single",
                       cols=c(3,4),
                       sep=","
)
summary(y)


jpeg("/data/R/Relative_vs_Absolute_Sales_per_item.jpeg")
par(mfrow=c(1,2))
itemFrequencyPlot(y,topN=5,type="relative")
itemFrequencyPlot(y,topN=5,type="absolute")
dev.off()
