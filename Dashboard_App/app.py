import streamlit as st
import streamlit.components.v1 as components
import pandas as pd

st.set_page_config(page_title="Refract",layout="wide", page_icon="")
st.header("Market Basket Analysis")
st.write("This analysis is based on The Bread Basket a bakery located in Edinburgh")

with st.sidebar:
    from PIL import Image
    image = Image.open('refract.png')
    st.image(image)
    st.subheader("The Bread Basket bakery, Edinburgh (Scotland)")
    st.write("Dataset Summary:")
    st.write("The dataset has transactions of customers who have ordered different items online during the mentioned timeline")
    df1 =  pd.DataFrame({"Analysis Start Date":{0:" October, 2011"}, "Analysis End Date" : {0:"April, 2012"}})
    st.table(df1)
    st.write("Applicable Tags:")
    st.write("Retail, Shopping, Business, Investing, Bakery, Cafe")

tab1, tab2, tab3, tab4 = st.tabs(["Data Profile", "Visualization", "Insights", "Forecast"])
with tab1:
    HtmlFile = open("data_profile.html", 'r', encoding='utf-8')
    source_code = HtmlFile.read() 
    components.html(source_code, height = 600, scrolling=True)
    
with tab2:
    imagea = Image.open('most_popular_items.jpeg')
    image0 = Image.open('Relative_vs_Absolute_Sales_per_item.jpeg')
    image1 = Image.open('items_sold_basis_daily.JPG')
    image2 = Image.open('items_sold_basis_daytime.JPG')
    image3 = Image.open('items_solds_in_a_week.JPG')
    image4 = Image.open('items_sold_per_hour.JPG')
    image5 = Image.open('items_sold_basis_month.JPG')
    image6 = Image.open('weekday_vs_weekend.JPG')

    col1, col2 = st.columns(2)
    col1.image(imagea, caption='Top items sold')
    col2.image(image0, caption='Relative versus Absolute item sold')
    st.write("#")
    
    st.image(image1, caption='Day wise item sales breakup')
    st.write("#")

    st.image(image2, caption='Daytime wise item sales breakup')
    st.write("#")

    st.image(image3, caption='Day wise item sales % breakup')
    st.write("#")

    st.image(image4, caption='Hourly item sales breakup')
    st.write("#")

    st.image(image5, caption='Monthly item sales breakup')
    st.write("#")

    st.image(image6, caption='Weekday versue Weekend sales')

with tab3:
    st.markdown("Business or sales insights: ")
    st.markdown("- Coffee is always the best selling product and followed by Bread and Tea in every month.")
    st.markdown("- The most transactions is at 10 a.m — 12 p.m, with a peak at 11 a.m.") 
    st.markdown("- Saturday is the day of the most transactions, followed by Friday and Sunday.") 
    st.markdown("- Transactions during the most crowded sales occurred in November") 
    
    st.write("#")
    st.markdown("Business strategy to improve sales: ")
    st.markdown("- Combo offer on items can entice customers to buy other items along with best selling product or the other way round.")
    st.markdown("- Arranging placements of items close to best selling product at ordering counter can be a good strategy to tempt customers into buying them.") 
    st.markdown("- Running promotional discount campaign during non peak hours of the weekdays might boost sales further")  
    st.markdown("- Run subscription based campaign to attract customer memberships for retention")  
    st.markdown('''<style>
    [data-testid="stMarkdownContainer"] ul{padding-left:40px;}
    </style>
    ''', unsafe_allow_html=True)
    
with tab4:
    image1 = Image.open('/forecast_charts/coffee_acf_pacf.png')
    image2 = Image.open('/forecast_charts/coffee_sarimax_forecast.png')
    image3 = Image.open('/forecast_charts/tea_acf_pacf.png')
    image4 = Image.open('/forecast_charts/tea_sarimax_forecast.png')
    image5 = Image.open('/forecast_charts/bread_acf_pacf.png')
    image6 = Image.open('/forecast_charts/bread_sarimax_forecast.png')

    col1, col2 = st.columns(2)
    col1.image(image1, caption='Coffee Autocorrelation and Partial Autocorrelation plot')
    col2.image(image2, caption='Coffee sales forecast for next 7 days')
    st.write("#")

    col3, col4 = st.columns(2)
    col3.image(image3, caption='Tea Autocorrelation and Partial Autocorrelation plot')
    col4.image(image4, caption='Tea sales forecast for next 7 days')
    st.write("#")
    
    col5, col6 = st.columns(2)
    col5.image(image5, caption='Bread Autocorrelation and Partial Autocorrelation plot')
    col6.image(image6, caption='Bread sales forecast for next 7 days')
    st.write("#")