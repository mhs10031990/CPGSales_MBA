install.packages("xgboost")
install.packages("corrplot")
install.packages("cowplot")

library(data.table)
library(dplyr)
library(ggplot2)
library(caret)
library(corrplot)
library(xgboost)
library(cowplot)

train = fread("/data/BigMart_Sales_train.csv")
test = fread("/data/BigMart_Sales_test.csv")

dim(train); dim(test)

names(train)
names(test)

str(train)
str(test)


test[, Item_Outlet_Sales := NA]
combi = rbind(train, test)
dim(combi)

#Univariate Analysis
ggplot(train) + geom_histogram(aes(train$Item_Outlet_Sales), binwidth = 100, fill = "darkblue") + xlab("Item Outlet Sales")
#Target is skewed and we would need some transformation to treat the skewneess


p1 = ggplot(combi) + geom_histogram(aes(Item_Weight), binwidth=0.5, fill="blue")
p2 = ggplot(combi) + geom_histogram(aes(Item_Visibility), binwidth=0.005, fill="blue")
p3 = ggplot(combi) + geom_histogram(aes(Item_MRP), binwidth=1, fill="blue")
plot_grid(p1, p2, p3, nrow=3)
#No clear pattern in Item_Weight
#Item_Visibility is skewed and need treatment for skewness
#Item_MRP has 4 different distribution


ggplot(combi %>% group_by(Item_Fat_Content) %>% summarise(Count = n())) + 
geom_bar(aes(Item_Fat_Content, Count), stat="identity", fill="coral1")
#In the above figure LF, low fat and Low Fat are one and the same. Similarly reg and Regular.
#This needs to be preprocessed to create two categories only.


combi$Item_Fat_Content[combi$Item_Fat_Content == "LF"] = "Low Fat"
combi$Item_Fat_Content[combi$Item_Fat_Content == "low fat"] = "Low Fat"
combi$Item_Fat_Content[combi$Item_Fat_Content == "reg"] = "Regular"


ggplot(combi %>% group_by(Item_Fat_Content) %>% summarise(Count = n())) + 
geom_bar(aes(Item_Fat_Content, Count), stat="identity", fill="coral1")


p4 = ggplot(combi %>% group_by(Item_Type) %>% summarise(Count =n())) + geom_bar(aes(Item_Type, Count), stat="identity", fill="coral1") + xlab("") +
geom_label(aes(Item_Type, Count, label=Count), vjust=0.5) + theme(axis.text.x=element_text(angle=45, hjust=1)) +ggtitle("Item_type")
p5 = ggplot(combi %>% group_by(Outlet_Identifier) %>% summarise(Count =n())) + geom_bar(aes(Outlet_Identifier, Count), stat="identity", fill="coral1") + xlab("") +
geom_label(aes(Outlet_Identifier, Count, label=Count), vjust=0.5) + theme(axis.text.x=element_text(angle=45, hjust=1)) +ggtitle("Item_type")
p6 = ggplot(combi %>% group_by(Outlet_Size) %>% summarise(Count =n())) + geom_bar(aes(Outlet_Size, Count), stat="identity", fill="coral1") + xlab("") +
geom_label(aes(Outlet_Size, Count, label=Count), vjust=0.5) + theme(axis.text.x=element_text(angle=45, hjust=1)) +ggtitle("Item_type")

second_row = plot_grid(p5, p6, nrow=1)
plot_grid(p4, second_row, ncol=1)
#Outlet Size has 4016 rows as blank, Need to check these and recategorize them appropriately.


p7 = ggplot(combi %>%  group_by(Outlet_Establishment_Year) %>% summarise(Count = n())) + 
geom_bar(aes(factor(Outlet_Establishment_Year), Count), stat="identity", fill="coral1") +
geom_label(aes(factor(Outlet_Establishment_Year), Count, label=Count), vjust=0.5) + 
xlab("Outlet_Establishment_Year") +
theme(axis.text.x=element_text(size=8.5))


p8 = ggplot(combi %>%  group_by(Outlet_Type) %>% summarise(Count = n())) + 
geom_bar(aes(factor(Outlet_Type), Count), stat="identity", fill="coral1") +
geom_label(aes(factor(Outlet_Type), Count, label=Count), vjust=0.5) + 
theme(axis.text.x=element_text(size=8.5))

plot_grid(p7, p8, ncol=2)
#less number of rows for year 1998
#Supermarket type 1 seems to be quite popular


#Bivariate Analysis with respect to target variable 

train = combi[1:nrow(train)]

p9 = ggplot(train) + geom_point(aes(Item_Weight, Item_Outlet_Sales), colour="violet", alpha=0.3) + theme(axis.title=element_text(size=8.5))
p10 = ggplot(train) + geom_point(aes(Item_Visibility, Item_Outlet_Sales), colour="violet", alpha=0.3) + theme(axis.title=element_text(size=8.5))
p11 = ggplot(train) + geom_point(aes(Item_MRP, Item_Outlet_Sales), colour="violet", alpha=0.3) + theme(axis.title=element_text(size=8.5))
second_row_2 = plot_grid(p10, p11, ncol=2)
plot_grid(p9, second_row_2, nrow=2)

#Item_Weight is well spread across Item_Outlet_Sales
#Item_Visibility = 0.0 for quite a few rows, need to dig deeper into this.
#Item_MRP sees 4 different segements of Price.


p12 = ggplot(train) + geom_violin(aes(Item_Type, Item_Outlet_Sales), fill="magenta") + 
theme(axis.text.x=element_text(angle=45, hjust=1), axis.text=element_text(size=6), axis.title=element_text(size=8.5))

p13 = ggplot(train) + geom_violin(aes(Item_Fat_Content, Item_Outlet_Sales), fill="magenta") + 
theme(axis.text.x=element_text(angle=45, hjust=1), axis.text=element_text(size=6), axis.title=element_text(size=8.5))

p14 = ggplot(train) + geom_violin(aes(Outlet_Identifier, Item_Outlet_Sales), fill="magenta") + 
theme(axis.text.x=element_text(angle=45, hjust=1), axis.text=element_text(size=6), axis.title=element_text(size=8.5))

second_row_3 = plot_grid(p13,p14, ncol=2)
plot_grid(p12, second_row_3, ncol=1)

#Distribution of Outlet_Sales across Item_type and Item_Fat_Content is not very distinctive.
#Distribution of OUT010 and OUT019 is very much similar and different from rest of the outlets.


ggplot(train) + geom_violin(aes(Outlet_Size, Item_Outlet_Sales), fill="magenta")
#The distribution of Small outlet Size is same as to the blank category.
#SO one way we can impute blank as Small.


p15 = ggplot(train) + geom_violin(aes(Outlet_Location_Type, Item_Outlet_Sales), fill="magenta")
p16 = ggplot(train) + geom_violin(aes(Outlet_Type, Item_Outlet_Sales), fill="magenta")
plot_grid(p15,p16, ncol=1)


#Tier_1 and 2 Location type sales look similar
#In GroceryStore, the datapoints are at lower scale values compared to other types.


## ---> Missing Value Imputation <--- ##
#Impute Missing Value

missing_index = which(is.na(combi$Item_Weight)) 
sum(is.na(combi$Item_Weight))

for (i in missing_index){
    item = combi$Item_Identifier[i]
    combi$Item_Weight[i] = mean(combi$Item_Weight[combi$Item_Identifier == item], na.rm = T)
}


sum(is.na(combi$Item_Weight))

#Impute missing visibility ()
zero_index = which(combi$Item_Visibility == 0)
for (i in zero_index) {
    item = combi$Item_Identifier[i]
    combi$Item_Visibility[i] =  mean(combi$Item_Visibility[combi$Item_Identifier == item], na.rm = T)
}

## --> Feature Creation <-- ##
test[, Item_Outlet_Sales := NA]
combi = rbind(train, test)
dim(combi)


combi$Item_Fat_Content[combi$Item_Fat_Content == "LF"] = "Low Fat"
combi$Item_Fat_Content[combi$Item_Fat_Content == "low fat"] = "Low Fat"
combi$Item_Fat_Content[combi$Item_Fat_Content == "reg"] = "Regular"


sum(is.na(combi$Item_Weight))
#Impute Missing Value

missing_index = which(is.na(combi$Item_Weight)) 
for (i in missing_index){
    item = combi$Item_Identifier[i]
    combi$Item_Weight[i] = mean(combi$Item_Weight[combi$Item_Identifier == item], na.rm = T)
}


perishable = c("Breads", "Breakfast","Dairy","Fruits and Vegetables","Meat","Seafood")
non_perishable = c("Baking Goods", "Canned","Frozen Foods","Hard Drinks","Health and Hygiene","Household", "Soft Drinks")

#create a new feature "Item_Type_new"
combi[,Item_Type_new := ifelse(Item_Type %in% perishable, "perishable",ifelse(Item_Type %in% non_perishable, "non_perishable","not_sure"))]

table(combi$Item_Type_new)

table(combi$Item_Type, substr(combi$Item_Identifier,1,2))

combi[,Item_category := substr(combi$Item_Identifier,1,2)]

combi$Item_Fat_Content[combi$Item_Category == "NC"] = "Non-Edible"

combi[,Outlet_Years :=2013 - Outlet_Establishment_Year]
combi$Outlet_Establishment_Year =  as.factor(combi$Outlet_Establishment_Year)
combi[,price_per_unit_wt := Item_MRP/Item_Weight]

combi[, Item_MRP_clusters := ifelse(Item_MRP < 69, "1st", ifelse(Item_MRP >=69 & Item_MRP <136, "2nd", ifelse(Item_MRP >= 136 & Item_MRP < 203, "3rd","4th")))]

head(combi)

##--> Label Encoding <--##
combi[, Outlet_Size_num := ifelse(Outlet_Size == "Small",0,ifelse(Outlet_Size == "Medium",1,2))]
combi[, Outlet_Location_Type_num := ifelse(Outlet_Location_Type == "Tier 3",0,ifelse(Outlet_Location_Type == "Tier 2",1,2))]
combi[,c("Outlet_Size", "Outlet_Location_Type") := NULL]

ohe = dummyVars("~.", data = combi[,-c("Item_Identifier", "Outlet_Establishment_Year","Item_Type")], fullRank=T)
ohe_df = data.table(predict(ohe, combi[,-c("Item_Identifier", "Outlet_Establishment_Year","Item_Type")]))
combi  = cbind(combi[,"Item_Identifier"], ohe_df)

#Removing Skewness
combi[,Item_Visibility := log(Item_Visibility + 1)]
combi[,price_per_unit_wt := log(price_per_unit_wt + 1)]

#Scaling numeric variables
num_vars = which(sapply(combi, is.numeric))
num_vars_names = names(num_vars)
combi_numeric = combi[,setdiff(num_vars_names,"Item_Outlet_Sales"), with=F]
prep_num = preProcess(combi_numeric, method=c("center","scale"))
combi_numeric_form = predict(prep_num,combi_numeric)

combi[,setdiff(num_vars_names, "Item_Outlet_Sales"), with=F]
combi = cbind(combi, combi_numeric_form)

train = combi[1:nrow(train)]
test = combi[nrow(train)+1 : nrow(combi)]
test[,Item_Outlet_Sales := NULL]

write.csv(train, "/data/BigMart_Sales_model_train.csv", row.names=FALSE)
write.csv(test, "/data/BigMart_Sales_model_test.csv", row.names=FALSE)

#---> Modeling <-------#
train = fread("/data/BigMart_Sales_model_train.csv")
test = fread("/data/BigMart_Sales_model_test.csv")

--> Rework on Model building <--
--> Register Model <--
--> Deploy Model and test <--


