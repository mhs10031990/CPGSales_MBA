import streamlit as st
import streamlit.components.v1 as components
import pandas as pd

st.set_page_config(page_title="Refract",layout="wide", page_icon="")
st.header("Market Basket Analysis")
st.write("This analysis is based on The Bread Basket a bakery located in Edinburgh")

with st.sidebar:
    from PIL import Image
    image = Image.open('refract.png')
    df1 =  pd.DataFrame({"Analysis Start Date":{0:" October, 2011"}, "Analysis End Date" : {0:"April, 2012"}})
    st.table(df1)
    st.write("The dataset has transactions of customers who have ordered different items from this bakery online during the above mentioned timeline")
    st.write("#")
    st.write("Applicable Tags")
    st.write("Retail, Shopping, Business, Investing")
    st.write("#")
    st.write("#")
    st.write("#")
    st.write("#")
    st.write("#")
    st.write("#")
    st.write("#")
    st.write("#")
    st.write("#")
    st.write("#")
    st.write("This app is powered by Refract and Streamlit")

tab1, tab2, tab3 = st.tabs(["Data Profile", "Visualization", "Insights"])
with tab1:
    HtmlFile = open("data_profile.html", 'r', encoding='utf-8')
    source_code = HtmlFile.read() 
    components.html(source_code, height = 600, scrolling=True)
    
with tab2:
    image1 = Image.open('items_sold_basis_daily.JPG')
    image2 = Image.open('items_sold_basis_daytime.JPG')
    image3 = Image.open('items_solds_in_a_week.JPG')
    image4 = Image.open('items_sold_per_hour.JPG')
    image5 = Image.open('items_sold_basis_month.JPG')
    image6 = Image.open('weekday_vs_weekend.JPG')

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
    st.markdown("Few insights that might help you run your business more efficiently: ")
    st.write("#")
    st.markdown("- Coffee is always the best selling product and followed by Bread and Tea in every month.")
    
    st.markdown("- The most transactions is at 10 a.m — 12 p.m, with a peak at 11 a.m.") 
    st.markdown("- Saturday is the day of the most transactions, followed by Friday and Sunday.") 
    st.markdown("- Transactions during the most crowded sales occurred in November") 
    
    st.markdown('''<style>
    [data-testid="stMarkdownContainer"] ul{padding-left:40px;}
    </style>
    ''', unsafe_allow_html=True)