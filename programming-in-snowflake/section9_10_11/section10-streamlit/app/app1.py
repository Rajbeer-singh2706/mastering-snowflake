import streamlit as st
st.title("Hierarchical Data Viewer")

import pandas as pd
filename = "data/employee-manager.csv"
df = pd.read_csv(filename).convert_dtypes()
st.dataframe(df)

import modules.graphs as graphs
graph = graphs.getEdges(df)
st.graphviz_chart(graph)



### 
#/Users/../work/repos-new/mastering-snowflake/programming-in-snowflake-masterclass/section10-streamlit/app
#streamlit run app1.py